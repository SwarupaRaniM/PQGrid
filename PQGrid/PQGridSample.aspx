<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PQGridSample.aspx.cs" Inherits="PQGrid.PQGridSample" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet"
        href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/themes/base/jquery-ui.css" />
    <!--ParamQuery Grid files-->
    <link rel="stylesheet" href="Scripts/pqgrid.min.css" />
    <style>
        .pq-grid .pq-select-button {
            padding: 3px 5px;
        }

       .vert-slider-center{
           width:17px;overflow:hidden;background:#b6cefb url(images/vert-slider-bg.png) !important;
       }
       
       .horiz-slider-center{
           height:17px;overflow:hidden;background:#b6cefb url(images/horiz-slider-bg.png) !important;
       }

    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <button type="button" onclick ="return ReadExcelDAta();">Read Excel Data </button>
          <%--  <div style="margin: auto; text-align: center;">
               <button type="button" onclick="return callIsdirtfunc();">Get Modified Rows</button>
                <input type="checkbox" id="range_chkbox" />
                Use range condition in Shipping Region (Range condition allows multiple values)
            </div>--%>
            <div id="grid_filter" style="margin: 5px auto;" ></div>

        </div>
    </form>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
    <!--Include Touch Punch file to provide support for touch devices
    <script type="text/javascript" src="Scripts/jquery.ui.touch-punch.js" ></script>  -->
    <script type="text/javascript" src="Scripts/pqgrid.min.js"></script>
    <script type="text/javascript">

        var modifiedRows = [];
        var updatedmodels = [];
        var addmodels = [];
        var deletedmodels = [];

        function callIsdirtfunc() {
            alert('from modified rows button');
            debugger;
            var modRows = $("#grid_filter").pqGrid("isDirty");

            var grid = $("#grid_filter").pqGrid("getInstance").grid;
           // var gridRows = [];
          //  gridRows = grid.pdata;
            grid.pdata.forEach(function (record) {

                console.log('rowIndx:' + record.rowIndx);
                  console.log('rowData:' + record.rowData);
             // var status=  grid.isDirty({ rowIndx: record.rowIndx, rowData: record.rowData });
            });
        }

        function ReadExcelDAta() {
            debugger;
            $.ajax({
                type: "POST",
                url: "/PQGridSample.aspx/ReadExcelData",   
                contentType: "application/json;charset=utf-8",
                //dataType: 'JSON',
                cache: false,
                async: true,
                success: function (Response) {
                    debugger;
                    console.log(Response);
                    var grid = $grid.pqGrid("getInstance").grid;
                    var response = { data: [] };
                    console.log(Response.d);
                    grid.option("dataModel.data", Response.d); 
                    grid.refreshDataAndView();
                    grid.hideLoading();
                }
            });
  

        }


        $(function () {
            debugger;

            function Model() { this.rank = 0; this.company = ""; this.losses = 0.0; this.profits = 0.0; this.balance = 0.0 };
            //define colModel
            var colM = [
                {
                    title: "Rank", width: 100, dataIndx: "rank",
                    filter: { type: 'textbox', condition: 'begin', listeners: ['keyup'] }
                },
                {
                    title: "Company", width: 120, dataIndx: "company",
                    filter: {
                        type: "textbox", condition: 'begin', listeners: ['keyup']
                    }
                },
                {
                    title: "Profits", minWidth: 130, dataIndx: "profits", dataType: "float",   
                    filter: { type: 'textbox', condition: "between", listeners: ['keyup'] }
                },
                {
                    title: "Losses", minWidth: "190", dataIndx: "losses", dataType: "float",
                    filter: { type: 'textbox', condition: "between", listeners: ['change'] }  
                },
                {
                    title: "Balance", minWidth: "190", dataIndx: "balance", dataType: "float",
                    filter: { type: 'textbox', condition: "between", listeners: ['change'] }  
                },
                {
                    title: "", editable: false, minWidth: 83, sortable: false,
                    render: function (ui) {
                        return "<button type='button' class='delete_btn'>Delete</button>";
                    }
                }

            ];
            //define dataModel
            var dataModel = {
                location: "local",
                sorting: "local",
                sortIndx: "losses",
                sortDir: "up",
                recIndx: "rank"
            }
            var obj = {
                width: 800, height: 500,
                dataModel: dataModel,
                colModel: colM,
                hwrap: false,
                pageModel: { type: "local", rPP: 50, rPPOptions: [5, 10, 50, 100, 500, 1000] },
                editable: true,
                selectionModel: { type: 'cell' },
                filterModel: { on: true, mode: "AND", header: true },
                title: "Budget Calculation",
                resizable: true,
                numberCell: { show: true },
                columnBorders: true,
                freezeCols: 2,
                trackModel: { on: true },
                editModel: {
                    allowInvalid: true,
                    saveKey: $.ui.keyCode.ENTER,
                    uponSave: 'next'
                },
                toolbar: {
                    items: [
                        {
                            type: 'button', icon: 'ui-icon-plus', label: 'New Product', listener:
                                {
                                    "click": function (evt, ui) {
                                      //  alert('from new product');
                                        debugger;

                                      //  this.rank = 0; this.company = ""; this.losses = 0.0; this.profits = 0.0; this.balance = 0.0
                                        //append empty row at the end.                            
                                        var rowData = { rank:0 }; //empty row  ,Company: 'New Company',losses:0.0,profits:0.0,balance:0.0
                                        var rowIndx = $grid.pqGrid("addRow", { rowData: rowData });
                                        $grid.pqGrid("goToPage", { rowIndx: rowIndx });
                                        $grid.pqGrid("setSelection", null);
                                        $grid.pqGrid("setSelection", { rowIndx: rowIndx });  //, dataIndx: 'Company'
                                        $grid.pqGrid("editFirstCellInRow", { rowIndx: rowIndx });
                                    }
                                }
                        },
                        { type: 'separator' },
                        {
                            //type: 'button', icon: 'ui-icon-arrowreturn-1-s', label: 'Undo', cls: 'changes', listener:
                            //    {
                            //        "click": function (evt, ui) {
                            //            $grid.pqGrid("history", { method: 'undo' });
                            //        }
                            //    },
                            //options: { disabled: true }
                        },
                        {
                            //type: 'button', icon: 'ui-icon-arrowrefresh-1-s', label: 'Redo', listener:
                            //    {
                            //        "click": function (evt, ui) {
                            //            $grid.pqGrid("history", { method: 'redo' });
                            //        }
                            //    },
                            //options: { disabled: true }
                        },
                        {
                            //type: "<span class='saving'>Saving...</span>"
                        }
                    ]
                },
                change: function (evt, ui) {
                    debugger;
                    if (ui.source == 'commit' || ui.source == 'rollback') {
                        return;
                    }
                    console.log(ui);
                    var $grid = $(this),
                        grid = $grid.pqGrid('getInstance').grid;
                    var rowList = ui.rowList,
                        addList = [],
                        recIndx = grid.option('dataModel').recIndx,
                        deleteList = [],
                        updateList = [];

                    for (var i = 0; i < rowList.length; i++) {
                        var obj = rowList[i],
                            rowIndx = obj.rowIndx,
                            newRow = obj.newRow,
                            type = obj.type,
                            rowData = obj.rowData;
                        if (type == 'add') {
                            var valid = grid.isValid({ rowData: newRow, allowInvalid: true }).valid;
                            if (valid) {
                                addList.push(newRow);
                            }
                        }
                        else if (type == 'update') {
                            var valid = grid.isValid({ rowData: rowData, allowInvalid: true }).valid;
                            if (valid) {
                                if (rowData[recIndx] == null) {
                                    addList.push(rowData);
                                }
                                //else if (grid.isDirty({rowData: rowData})) {
                                else {
                                    updateList.push(rowData);
                                }
                            }
                        }
                        else if (type == 'delete') {
                            if (rowData[recIndx] != null) {
                                deleteList.push(rowData);
                            }
                        }
                    }
                    if (addList.length || updateList.length || deleteList.length) {
                        debugger;

                        addList.forEach(function (record) {
                            var model = new Model();
                            model.rank = record.rank;
                            model.company = record.company;
                            model.losses = record.losses;
                            model.profits = record.profits;
                            model.balance = record.balance;
                            addmodels.push(model);
                        });

                        updateList.forEach(function (record) {
                            var model = new Model();
                            model.rank = record.rank;
                            model.company = record.company;
                            model.losses = record.losses;
                            model.profits = record.profits;
                            model.balance = record.balance;
                            updatedmodels.push(model);
                        });


                         deleteList.forEach(function (record) {
                            var model = new Model();
                            model.rank = record.rank;
                            model.company = record.company;
                            model.losses = record.losses;
                            model.profits = record.profits;
                            model.balance = record.balance;
                            deletedmodels.push(model);
                        });


                        debugger;

                        //  let mydata = '{"modifiedRows":' + JSON.stringify(models) + '}';
                        // var list = [];
                        let data =
                           //  '{"list":' + JSON.stringify(updatedmodels) + '}';
                            '{"list":' + JSON.stringify({
                                updateList: updatedmodels,
                                addList: addmodels,
                                deleteList: deletedmodels
                            }) + '}';

                        console.log(data);
                        $.ajax({

                            url: 'PQGridSample.aspx/batch',
                            data: data,
                            contentType: 'application/json; charset=utf-8',
                            type: 'POST',
                           // dataType: 'json',
                            async: true,
                            beforeSend: function (jqXHR, settings) {
                                $(".saving", $grid).show();
                            },
                            success: function (changes) {  
                                debugger;
                                console.log(changes.d);
                                //commit the changes.                                   
                                grid.commit({ type: 'add', rows: changes.addList });
                                grid.commit({ type: 'update', rows: changes.updateList });
                                grid.commit({ type: 'delete', rows: changes.deleteList });
                                data = [];
                                addmodels = [];
                                updatedmodels = [];
                                grid.option("dataModel.data", changes.d); //response.data
                                grid.refreshDataAndView();

                            },
                            complete: function () {
                                debugger;
                                $(".saving", $grid).hide();     
                            }
                        });
                    }
                },
                history: function (evt, ui) {
                    var $grid = $(this);
                    if (ui.canUndo != null) {
                        $("button.changes", $grid).button("option", { disabled: !ui.canUndo });
                    }
                    if (ui.canRedo != null) {
                        $("button:contains('Redo')", $grid).button("option", "disabled", !ui.canRedo);
                    }
                    $("button:contains('Undo')", $grid).button("option", { label: 'Undo (' + ui.num_undo + ')' });
                    $("button:contains('Redo')", $grid).button("option", { label: 'Redo (' + ui.num_redo + ')' });
                },
                refresh: function () {
                    $("#grid_filter").find("button.delete_btn").button({ icons: { primary: 'ui-icon-scissors' } })
                        .unbind("click")
                        .bind("click", function (evt) {
                            debugger;
                            var $tr = $(this).closest("tr");
                            var rowIndx = $grid.pqGrid("getRowIndx", { $tr: $tr }).rowIndx;
                            $grid.pqGrid("deleteRow", { rowIndx: rowIndx });
                        });
                }
            };

            debugger;
            var $grid = $("#grid_filter").pqGrid(obj);


            //load all data at once
            $grid.pqGrid("showLoading");

            $.ajax({
                type: "POST",
                url: "/PQGridSample.aspx/GetData",   //ReadExcelData
                contentType: "application/json;charset=utf-8",
                //dataType: 'JSON',
                cache: true,
                async: true,
                success: function (Response) {
                    debugger;
                    console.log(Response);
                    var grid = $grid.pqGrid("getInstance").grid;
                    var response = { data: [] };
                    console.log(Response.d);
                    grid.option("dataModel.data", Response.d); 
                    grid.refreshDataAndView();
                    grid.hideLoading();
                }
            });
  
            //$("#grid_filter").pqGrid({
            //    // freezeCols: 2,
            //    cellSave: function (event, ui) {
            //        alert("Hi...from cell save");
            //        debugger;
            //        ui.rowData.balance = ui.rowData.profits - ui.rowData.losses;
            //        $("#grid_filter").pqGrid("refreshCell", { rowIndx: ui.rowIndx, dataIndx: 'balance' });
            //        var rowData = $("#grid_filter").pqGrid("getRowData", { rowIndxPage: ui.rowIndx });
            //        debugger;
            //        modifiedRows.push(rowData);
            //    }
            //});

        });

        function Model() { this.rank = 0; this.company = ""; this.losses = 0.0; this.profits = 0.0; this.balance = 0.0 };

        function modifiedData() {
            //  alert("Getting Modified data");
            debugger;

            
            var models = [];


            console.log(JSON.stringify(modifiedRows) + "\n");
            modifiedRows.forEach(function (record) {
                var model = new Model();
                model.rank = record.rank;
                model.company = record.company;
                model.losses = record.losses;
                model.profits = record.profits;
                model.balance = record.balance;
                models.push(model);
            });

            let mydata = '{"modifiedRows":' + JSON.stringify(models) + '}';
            console.log(mydata);

            // alert(mydata);
            $.ajax({

                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                url: 'WebForm2.aspx/ModifiedExcelData',
                data: mydata,
                dataType: 'json',

                success: function (msg) {

                    debugger;
                    //  alert(msg);

                },
                failure: function (x, e) {
                    debugger;
                    alert("failed");
                }

            });

        }
    </script>
</body>
</html>

