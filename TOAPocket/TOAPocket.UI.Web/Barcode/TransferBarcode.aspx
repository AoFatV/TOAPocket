<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="TransferBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.TranferBarcode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--<script src="https://cdn.uni-kl.de/js/datatables/1.10.15/extensions/Responsive/js/dataTables.responsive.js"></script>--%>
    <%--<link rel="stylesheet" href="https://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css" />--%>
    <%--<link rel="stylesheet" href="https://cdn.datatables.net/responsive/1.0.7/css/responsive.dataTables.min.css" />--%>
    <script type="text/javascript">
        var trUpdate;
        $(function () {
            $("[id*='txtTfDateStart']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtTfDateEnd']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });


            InitialTb_1();
            InitialDepartment();
        });

        function InitialTb_1() {
            var postUrl = "TransferBarcode.aspx/GetBarcodeTransfer";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{department: ' + $("[id*='hdDepartment']").val()
                    + ',trNo:"' + ""
                    + '",fromDept:"' + ""
                    + '",toDept:"' + ""
                    + '",barcodeStart:"' + ""
                    + '",barcodeEnd:"' + ""
                    + '",dateStart:"' + ""
                    + '",dateEnd:"' + ""
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

        function InitialDepartment() {
            var postUrl = "../Common/FetchData.asmx/GetDepartment";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{condition: 1 }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindDropdown,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindDropdown(response) {
            var data = JSON.parse(response.d);

            var ddl1 = $("[id*='ddlFromDepartment']");

            ddl1.empty();
            $.each(data, function () {
                ddl1.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            var ddl2 = $("[id*='ddlToDepartment']");

            ddl2.empty();
            $.each(data, function () {
                ddl2.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            $("[id*='ddlToDepartment']").val($("[id*='hdDepartment']").val());
        }

        function BindTb_1(response) {

            var data = JSON.parse(response.d);
            //console.log(data);
            var table = $('#tbUnReceive').DataTable({
                //"processing": true,
                "responsive": true,
                "data": (data),
                "columnDefs": [
                    { responsivePriority: 1, targets: 0 },
                    { responsivePriority: 2, targets: 5 },
                    { responsivePriority: 3, targets: 6 }
                ],
                "columns": [
                    {
                        "data": null,
                        render: function (data, type, row) {
                            return "";
                        }, className: "dt-body-center"

                    },
                    {
                        "data": "TR_NO"
                    },
                    {
                        "data": "TR_DATE",
                        render: function (data, type, row) {

                            var date = new Date(parseInt(data.substr(6)));

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
                            return date;
                        }, className: "dt-body-center"
                    },
                    {
                        "data": "RECEIVE_DATE",
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
                        "data": "FromDept", className: "dt-body-center"
                    },
                    {
                        "data": "ToDept", className: "dt-body-center"
                    },
                    {
                        "data": "TOTAL_QTY", className: "dt-body-center"
                    },
                    {
                        "data": null,
                        render: function (data, type, row) {
                            var value = row.BARCODE_FROM + "-" + row.BARCODE_TO;
                            return value;
                        }, className: "dt-body-center"
                    }, {
                        "data": "STATUS_NAME", className: "dt-body-center"
                    }, {
                        "data": null,
                        render: function (data, type, row) {
                            var data = "'" + row.TR_NO + "'";
                            var buttonOk = '<button type="button" class="btn btn-success" onclick="CallConfirm(' + data + ');"><span class="glyphicon glyphicon-ok"></span></button>';
                            return buttonOk;
                        }, className: "dt-body-center"

                    }, {
                        "data": null,
                        render: function (data, type, row) {
                            var data = "'" + row.TR_NO + "'";
                            var buttonReject = '<button type="button" class="btn btn-danger" onclick="CallReject(' + data + ');"><span class="glyphicon glyphicon-remove"></span></button>';
                            return buttonReject;
                        }, className: "dt-body-center"

                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "iDisplayLength": 15
            });
        }

        function CreateTransferBarcode() {
            window.location = "TransferBarcode_Create.aspx";
        }

        function CallConfirm(trNo) {
            //console.log(row);
            trUpdate = "";
            trUpdate = trNo;
            confirmBox("ยืนยันการรับ Barcode ", ConfirmReceiveBarcode);
        }

        function CallReject() {

        }

        function ConfirmReceiveBarcode() {
           
            //Confirm to receive barcode
            var postUrl = "TransferBarcode.aspx/ConfirmReceiveBarcode";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{department: ' + $("[id*='hdDepartment']").val()
                    + ',trNo:"' + trUpdate
                    + '",fromDept:"' + $("[id*='ddlFromDepartment']").val()
                    + '",toDept:"' + $("[id*='ddlToDepartment']").val()
                    + '",barcodeStart:"' + $("[id*='txtBarcodeStart']").val()
                    + '",barcodeEnd:"' + $("[id*='txtBarcodeEnd']").val()
                    + '",dateStart:"' + $("[id*='txtTfDateStart']").val()
                    + '",dateEnd:"' + $("[id*='txtTfDateEnd']").val()
                    + '",updateBy:"' + $("[id*='hdUserId']").val()
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: alert(1),
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function RejectReceiveBarcode() {

        }

        function Search() {

            var postUrl = "TransferBarcode.aspx/GetBarcodeTransfer";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{department: ' + $("[id*='hdDepartment']").val()
                    + ',trNo:"' + $("[id*='txtTranferNo']").val()
                    + '",fromDept:"' + ""
                    + '",toDept:"' + ""
                    + '",barcodeStart:"' + ""
                    + '",barcodeEnd:"' + ""
                    + '",dateStart:"' + ""
                    + '",dateEnd:"' + ""
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var dt = $('#tbUnReceive').dataTable();
                    var data = JSON.parse(response.d);
                    ////console.log(data);
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
    </script>


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
                            <h3 class="box-title">โอนย้าย Barcode</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdDepartment" />
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Tranfer No.
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtTranferNo" class="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        แผนกที่โอน
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server" id="ddlFromDepartment">
                                                        </select>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        แผนกที่รับ
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server" id="ddlToDepartment" disabled="True">
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Barcode เริ่มต้น
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeStart" class="form-control" />
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeEnd" class="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        วันที่โอน
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtTfDateStart" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtTfDateEnd" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-xs-offset-5">
                                            <div class="col-xs-2 col-md-1">
                                                <button type="button" class="btn btn-info" onclick="Search()">
                                                    <span class="glyphicon glyphicon-search"></span>ค้นหา
                                               
                                                </button>
                                            </div>
                                            <div class="col-xs-2 col-md-1">
                                                <button type="button" class="btn" onclick="SearchByPO()">
                                                    <span class="glyphicon glyphicon-remove"></span>ยกเลิก
                                               
                                                </button>
                                            </div>
                                            <div class="col-xs-2 col-md-1">
                                                <button type="button" class="btn btn-success" onclick="CreateTransferBarcode()">
                                                    <span class="glyphicon glyphicon-transfer"></span>สร้างรายการโอน
                                               
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="nav-tabs-custom">
                                                <ul class="nav nav-tabs">
                                                    <li class="active"><a href="#tab_1" data-toggle="tab" onclick="Opentab(1);">รายการค้างรับ</a></li>
                                                    <li><a href="#tab_2" data-toggle="tab" onclick="Opentab(2);">ประวัติการโอน</a></li>
                                                    <li><a href="#tab_3" data-toggle="tab" onclick="Opentab(3);">ประวัติการรับโอน</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div class="tab-pane active" id="tab_1">
                                                        <div class="row">
                                                            <div class="col-xs-12">
                                                                <table id="tbUnReceive" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="width: 1%;"></th>
                                                                            <th>Transfer No.</th>
                                                                            <th>วันที่โอน</th>
                                                                            <th>วันที่รับ</th>
                                                                            <th>แผนกที่โอน</th>
                                                                            <th>แผนกที่รับ</th>
                                                                            <th>Qty.</th>
                                                                            <th data-priority="1">ช่วง Barcode</th>
                                                                            <th data-priority="1">สถานะ</th>
                                                                            <th data-priority="1">ยืนยันการรับ</th>
                                                                            <th data-priority="2">ปฏิเสธการรับ</th>
                                                                        </tr>
                                                                    </thead>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="tab-pane" id="tab_2">
                                                    </div>
                                                    <div class="tab-pane" id="tab_3">
                                                    </div>
                                                </div>
                                            </div>
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
