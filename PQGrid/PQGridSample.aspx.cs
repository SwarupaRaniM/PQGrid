using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PQGrid
{
    public partial class PQGridSample : System.Web.UI.Page
    {

        static string connString = ConnectionString();
        static SqlConnection conn;
        static SqlCommand cmd;
        private static string ConnString = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod()]
        public static object ReadExcelData()
        {
            try
            {
                string ConStr = "";
                string path = @"D:\Novo Nordis\Source\NNTMS\TestWebApplication\Test.xlsx";
                //for .xls
                //  ConStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                ConStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=Excel 12.0";
                string query = "select * from [Sheet1$]";
                OleDbConnection conn1 = new OleDbConnection(ConStr);
                if (conn1.State == ConnectionState.Closed)
                {
                    conn1.Open();
                }

                OleDbCommand cmd1 = new OleDbCommand(query, conn1);
                OleDbDataAdapter da = new OleDbDataAdapter(cmd1);
                DataSet ds = new DataSet();
                //fill the Excel data to data set  
                da.Fill(ds);
                conn1.Close();
                var lstModel = new List<Model>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    var model = new Model();
                    model.rank = Convert.ToInt32(dr["rank"]);
                    model.company = dr["company"].ToString();
                    model.losses = float.Parse(dr["losses"].ToString());
                    model.profits = float.Parse(dr["profits"].ToString());
                    model.balance = float.Parse(dr["balance"].ToString());
                    lstModel.Add(model);
                }
                //   var result = JsonConvert.SerializeObject(ds.Tables[0]);

                foreach (var item in lstModel)
                {
                    item.balance = item.profits - item.losses;
                    string insertQuery = String.Format("INSERT INTO [dbo].[Data] (rank,company,losses,profits,balance) VALUES(" + item.rank + ",'" + item.company + "'," + item.losses + "," + item.profits + "," + item.balance + ")");
                    conn = new SqlConnection(connString);
                    conn.Open();
                    cmd = new SqlCommand(insertQuery, conn);
                    cmd.ExecuteNonQuery();
                }

                List<Model> totrows = GetData();

                // var result = JsonConvert.SerializeObject(totrows);
                return totrows;

                //   return lstModel;
            }
            catch (Exception ex)
            {
                return ex;
            }
        }


        [WebMethod()]
        public static string ModifiedExcelData(Model[] modifiedRows)  //Model ModifiedData
        {
            var v = HttpContext.Current.Request;
            return "";
        }

        [WebMethod()]
        public static object batch(DataModel list)
        {
            List<Model> result = new List<Model>();
            if (list.addList.Count != 0)
            {
                result = AddList(list.addList);
            }

            if (list.updateList.Count != 0)
            {
                result = new List<Model>();
                result = UpdateList(list.updateList);
            }


            if (list.deleteList.Count != 0)
            {
                result = new List<Model>();
                result = DeleteList(list.deleteList);
            }
         
            return result;

        }

        private static List<Model> AddList(List<Model> addList)
        {

            string sqlQuery = String.Format("select max(rank) from [dbo].[Data]");
            conn = new SqlConnection(connString);
            conn.Open();
            SqlCommand cmd = new SqlCommand(sqlQuery, conn);

            int rankID = Convert.ToInt32(cmd.ExecuteScalar());
            rankID = rankID + 1;

            string insertQuery = String.Format("INSERT INTO [dbo].[Data] (rank) VALUES(" + rankID + ")");
            cmd = new SqlCommand(insertQuery, conn);
            int i = cmd.ExecuteNonQuery();
            List<Model> totrows = GetData();

            // var result = JsonConvert.SerializeObject(totrows);
            return totrows;
        }

        private static List<Model> UpdateList(List<Model> updateList)
        {
            conn = new SqlConnection(connString);
            conn.Open();

            foreach (var item in updateList)
            {
                item.balance = item.profits - item.losses;
                string updateQuery = String.Format("update[dbo].[Data] set company = '" + item.company + "', losses= " + item.losses + ",profits =" + item.profits + ",balance =" + item.balance + "where rank = " + item.rank);
                cmd = new SqlCommand(updateQuery, conn);
                cmd.ExecuteNonQuery();
            }

            List<Model> totrows = GetData();

            // var result = JsonConvert.SerializeObject(totrows);
            return totrows;

        }

        private static List<Model> DeleteList(List<Model> deleteList)
        {
            conn = new SqlConnection(connString);
            conn.Open();

            foreach (var item in deleteList)
            {
                string updateQuery = String.Format("delete from [dbo].[Data] where rank = " + item.rank);
                cmd = new SqlCommand(updateQuery, conn);
                cmd.ExecuteNonQuery();
            }

            List<Model> totrows = GetData();
            return totrows;
        }



        private static string ConnectionString()
        {
            ConnString = ConfigurationManager.ConnectionStrings["ConnString"].ConnectionString;
            return ConnString;
        }


        [WebMethod()]
        public static List<Model> GetData()
        {
            string connString = ConnectionString();
            SqlConnection conn = new SqlConnection(connString);
            conn.Open();

            string getQuery = String.Format("select * from [dbo].[Data]");
            SqlCommand cmd = new SqlCommand(getQuery, conn);
            SqlDataReader result1 = cmd.ExecuteReader();
            Model model = null;
            List<Model> totrows = new List<Model>();
            if (result1.HasRows)
            {

                while (result1.Read())
                {
                    model = new Model();

                    model.rank = Convert.ToInt32(result1["rank"]);
                    model.company = result1["company"].ToString();
                    float losses;
                    float profits;
                    float balance;
                    float.TryParse(result1["losses"].ToString(), out losses);
                    model.losses = losses;
                    float.TryParse(result1["profits"].ToString(), out profits);
                    model.profits = profits;
                    float.TryParse(result1["balance"].ToString(), out balance);
                    model.balance = balance;
                    totrows.Add(model);
                }
            }

            conn.Close();
            return totrows;

        }
    }
}