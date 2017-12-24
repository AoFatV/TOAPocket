<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="StockBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Stock.StockBarcode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>

    <script type="text/javascript">
        $(function () {

            $("[id*='txtEditStart']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtEditEnd']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            //InitialDepartment();
            //InitialStatus();
            //InitialTb_1();
        });

        function InitialDepartment() {
            var postUrl = "../Common/FetchData.asmx/GetDepartment";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{condition: "' + "" + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindDropdown,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function InitialStatus() {
            var postUrl = "../Common/FetchData.asmx/GetStatus";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{condition: "' + "" + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindStatus,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindDropdown(response) {
            var data = JSON.parse(response.d);

            var ddl1 = $("[id*='ddlDepartment']");

            ddl1.empty();
            $.each(data, function () {
                ddl1.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            var ddl2 = $("[id*='ddlToDepartment']");

            //$("[id*='ddlToDepartment']").val($("[id*='hdDepartment']").val());
        }

        function BindStatus(response) {
            var data = JSON.parse(response.d);

            var ddl1 = $("[id*='ddlStatus']");

            ddl1.empty();
            ddl1.append(
                $('<option></option>').val("").html("ALL")
            );
            $.each(data, function () {
                ddl1.append($("<option></option>").val(this['STATUS_ID']).html(this['STATUS_NAME']));
                //Default is first value 
            });


        }

        function InitialTb_1() {
            var postUrl = "StockBarcode.aspx/GetStockBarcode";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{barcode: "' + ""
                    + '",poNo:"' + ""
                    + '",lastEditStart:"' + ""
                    + '",lastEditEnd:"' + ""
                    + '",department:"' + ""
                    + '",status:"' + ""
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTb_1,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindTb_1(response) {

            var data = JSON.parse(response.d);
            console.log(data);
            var table = $('#tbStockBarcode').DataTable({
                //"processing": true,
                "responsive": true,
                "data": (data),
                //"columnDefs": [
                //    { responsivePriority: 1, targets: 0 },
                //    //{ responsivePriority: 2, targets: 5 },
                //    //{ responsivePriority: 3, targets: 6 }
                //],
                "columns": [
                    {
                        "data": null, className: "dt-center"
                    },
                    {
                        "data": "BARCODE", className: "dt-body-center"
                    },
                    {
                        "data": "PO_NO", className: "dt-body-center"
                    },
                    {
                        "data": "LAST_DEPARTMENT", className: "dt-body-center"
                    }, {
                        "data": "CREATE_DATE",
                        render: function (data, type, row) {
                            var date = "";
                            if (data != null) {
                                date = new Date(parseInt(data.substr(6)));

                                var dd = date.getDate();
                                var mm = date.getMonth() + 1; //January is 0!
                                var yyyy = date.getFullYear();
                                if (dd < 10) {
                                    dd = '0' + dd;
                                }
                                if (mm < 10) {
                                    mm = '0' + mm;
                                }

                                date = dd + '/' + mm + '/' + yyyy;
                            }
                            return date;
                        }, className: "dt-body-center"
                    }, {
                        "data": "LAST_UPDATE_DATE",
                        render: function (data, type, row) {
                            var date = "";
                            if (data != null) {
                                date = new Date(parseInt(data.substr(6)));

                                var dd = date.getDate();
                                var mm = date.getMonth() + 1; //January is 0!
                                var yyyy = date.getFullYear();
                                if (dd < 10) {
                                    dd = '0' + dd;
                                }
                                if (mm < 10) {
                                    mm = '0' + mm;
                                }

                                date = dd + '/' + mm + '/' + yyyy;
                            }
                            return date;
                        }, className: "dt-body-center"
                    },
                    {
                        "data": "LAST_UPDATE_BY", className: "dt-body-center"
                    },
                    {
                        "data": "STATUS_NAME", className: "dt-body-center"
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "iDisplayLength": 15,
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbStockBarcode').DataTable().page.info().page * $('#tbStockBarcode').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }
                //, "scrollX": true
            });
        }

        function SearchStock() {

            var dt = $('#tbStockBarcode').dataTable();
            var postUrl = "StockBarcode.aspx/GetStockBarcode";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{barcode: "' + $("[id*='txtBarcode']").val()
                    + '",poNo:"' + $("[id*='txtPoNo']").val()
                    + '",lastEditStart:"' + $("[id*='txtEditStart']").val()
                    + '",lastEditEnd:"' + $("[id*='txtEditEnd']").val()
                    + '",department:"' + $("[id*='ddlDepartment'] option:selected").text()
                    + '",status:"' + $("[id*='ddlStatus'] option:selected").val()
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    //var dt = $('#tbUnReceive').dataTable();
                    var data = JSON.parse(response.d);
                    console.log(data);
                    if (data.length > 0) {
                        dt.fnClearTable();
                        dt.fnAddData(data);
                        dt.fnDraw();
                    } else dt.fnClearTable();
                },
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function CancelSearch() {
            $("[id*='txtBarcode']").val('');
            $("[id*='txtPoNo']").val('');
            $("[id*='txtEditStart']").val('');
            $("[id*='txtEditEnd']").val('');
            $("[id*='ddlDepartment']").val($("[id*='ddlDepartment'] option:first").val());
            $("[id*='ddlStatus']").val($("[id*='ddlStatus'] option:first").val());

        }

        function ExportToExcel() {
            var postUrl = "StockBarcode.aspx/ExportToExcel";
            $.ajax({
                type: "POST",
                url: postUrl,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: alert(1),
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }
    </script>

    <style type="text/css">
        .pagination-ys {
            /*display: inline-block;*/
            padding-left: 0;
            margin: 20px 0;
            border-radius: 4px;
        }

            .pagination-ys table > tbody > tr > td {
                display: inline;
            }

                .pagination-ys table > tbody > tr > td > a,
                .pagination-ys table > tbody > tr > td > span {
                    position: relative;
                    float: left;
                    padding: 8px 12px;
                    line-height: 1.42857143;
                    text-decoration: none;
                    color: #dd4814;
                    background-color: #ffffff;
                    border: 1px solid #dddddd;
                    margin-left: -1px;
                }

                .pagination-ys table > tbody > tr > td > span {
                    position: relative;
                    float: left;
                    padding: 8px 12px;
                    line-height: 1.42857143;
                    text-decoration: none;
                    margin-left: -1px;
                    z-index: 2;
                    color: #aea79f;
                    background-color: #f5f5f5;
                    border-color: #dddddd;
                    cursor: default;
                }

                .pagination-ys table > tbody > tr > td:first-child > a,
                .pagination-ys table > tbody > tr > td:first-child > span {
                    margin-left: 0;
                    border-bottom-left-radius: 4px;
                    border-top-left-radius: 4px;
                }

                .pagination-ys table > tbody > tr > td:last-child > a,
                .pagination-ys table > tbody > tr > td:last-child > span {
                    border-bottom-right-radius: 4px;
                    border-top-right-radius: 4px;
                }

                .pagination-ys table > tbody > tr > td > a:hover,
                .pagination-ys table > tbody > tr > td > span:hover,
                .pagination-ys table > tbody > tr > td > a:focus,
                .pagination-ys table > tbody > tr > td > span:focus {
                    color: #97310e;
                    background-color: #eeeeee;
                    border-color: #dddddd;
                }


        .hiddencol {
            display: none;
        }

        .visiblecol {
            display: block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper" style="min-height: 990px;">
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">คลังสินค้า</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdDepartment" />
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <asp:HiddenField runat="server" ID="hdUserName" />
                            <asp:HiddenField runat="server" ID="hdDepartmentName" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-1 col-xs-offset-2">
                                                    Barcode 
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtBarcode"></asp:TextBox>
                                                </div>
                                                <div class="col-xs-1">
                                                    PO No.
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtPoNo"></asp:TextBox>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-2 col-xs-offset-1 text-right">
                                                    วันที่แก้ไขล่าสุด 
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtEditStart"></asp:TextBox>
                                                </div>
                                                <div class="col-xs-1">
                                                    ถึง
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtEditEnd"></asp:TextBox>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-1 col-xs-offset-2">
                                                    แผนก/คลัง 
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:DropDownList runat="server" CssClass="form-control" ID="ddlDepartment" />
                                                </div>
                                                <div class="col-xs-1">
                                                    สถานะ
                                                </div>
                                                <div class="col-xs-2">
                                                    <asp:DropDownList runat="server" CssClass="form-control" ID="ddlStatus" />
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-md-5 col-md-offset-5 col-xs-5 col-xs-offset-5">
                                                    <button type="button" class="btn btn-success" runat="server" id="btnSearch" onserverclick="btnSearch_OnServerClick">
                                                        <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelSearch()">
                                                        <span class="glyphicon glyphicon-remove"></span>&nbsp;ยกเลิก
                                                    </button>
                                                    <button type="button" class="btn btn-success" runat="server" id="btnExport" onserverclick="btnExport_OnServerClick">
                                                        <span class="glyphicon glyphicon-save"></span>&nbsp;Export
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <%-- <table id="tbStockBarcode" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 1%; text-align: center;">ลำดับ</th>
                                                        <th style="text-align: center;">Barcode</th>
                                                        <th style="text-align: center;">PO No.</th>
                                                        <th style="text-align: center;">แผนก/คลัง</th>
                                                        <th style="text-align: center;">วันที่เริ่มต้น</th>
                                                        <th style="text-align: center;">วันที่แก้ไขล่าสุด</th>
                                                        <th style="text-align: center;">ผู้แก้ไขล่าสุด</th>
                                                        <th style="text-align: center;">สถานะ</th>
                                                    </tr>
                                                </thead>
                                            </table>--%>
                                            <asp:GridView runat="server" ID="gridStockBarcode" CssClass="table table-striped table-bordered table-hover" AllowPaging="true" PageSize="10" AutoGenerateColumns="False"
                                                OnPageIndexChanging="gridStockBarcode_OnPageIndexChanging">
                                                <Columns>
                                                    <asp:BoundField DataField="No" HeaderText="ลำดับ" ItemStyle-Width="3%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="Barcode" HeaderText="Barcode" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="PONo" HeaderText="PO No." ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="Department" HeaderText="แผนก/คลัง" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="CreateDate" HeaderText="วันที่เริ่มต้น" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="LastEditDate" HeaderText="วันที่แก้ไขล่าสุด" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="LastEditBy" HeaderText="ผู้แก้ไขล่าสุด" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="Status" HeaderText="สถานะ" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                </Columns>
                                                <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>

</asp:Content>
