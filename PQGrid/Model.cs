using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PQGrid
{
    public class Model
    {
        public int rank { get; set; }
        public string company { get; set; }
        public float losses { get; set; }
        public float profits { get; set; }
        public float balance { get; set; }
    }


    public class DataModel
    {
        public List<Model> updateList { get; set; }
        public List<Model> addList { get; set; }
        public List<Model> deleteList { get; set; }

    }
    
}