<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="ConfirmReceive.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.ConfirmReceive" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        var actionResult = "<%=actionResult %>";
        var msgResult = "<%=msg %>";
        $(function () {
            if (msgResult != "") {
                if (actionResult == 'True') {
                    successMsg(msgResult);
                } else {
                    dangerMsg(msgResult);
                }
            }

            InitialTbByPO();
            InitialTbByBarcode();

        });

        function InitialTbByPO() {

            var postUrl = "ConfirmReceive.aspx/GetBarcodeByPO";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{po: " " }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTable,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function InitialTbByBarcode() {

            var postUrl = "ConfirmReceive.aspx/GetBarcodeByBarcode";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{po: "",barcodeStart:"' + $("[id*='txtBarcodeStart']").val() + '",barcodeEnd:"' + $("[id*='txtBarcodeEnd']").val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTable_2,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindTable(response) {

            //console.log(response.d);
            var data = JSON.parse(response.d);

            var table = $('#tbRcAllPO').DataTable({
                //"processing": true,
                "responsive": true,
                "data": (data),
                "columns": [
                    {
                        "data": null, className: "dt-body-center"
                    },
                    {
                        "data": "PONo",
                        render: function (data, type, row) {
                            if (type === 'display') {
                                return '<input type="checkbox" value="' + data + '" name="chkPO">';
                            }
                            return data;
                        },
                        className: "dt-body-center", "orderable": false
                    },
                    { "data": "PONo", "width": "20%", className: "dt-body-center" },
                    { "data": "Total", "width": "20%", className: "dt-body-center" },
                    { "data": "TotalReceive", "width": "20%", className: "dt-body-center" },
                    //{ "data": null },
                    {
                        "data": "Status", className: "dt-body-center"
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "iDisplayLength": 15,
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbRcAllPO').DataTable().page.info().page * $('#tbRcAllPO').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }, "scrollX": true
            });

            $('#chkAll').on('click', function () {
                // Get all rows with search applied
                var rows = table.rows({ 'search': 'applied' }).nodes();
                // Check/uncheck checkboxes for all rows in the table
                $('input[type="checkbox"]', rows).prop('checked', this.checked);
            });

            //$("#dtTable_length").hide();
        }

        function BindTable_2(response) {

            //console.log(response.d);
            var data = JSON.parse(response.d);

            var table = $('#tbRcBarcode').DataTable({
                //"processing": true,
                "responsive": true,
                "data": (data),
                "columns": [
                    {
                        "data": null,
                    },
                    {
                        "data": "Barcode",
                        render: function (data, type, row) {
                            if (type === 'display') {
                                return '<input type="checkbox" value="' + data + '" name="chkBarcode">';
                            }
                            return data;
                        },
                        className: "dt-body-center", "orderable": false
                    },
                    { "data": "PONo", "width": "50%" },
                    { "data": "Barcode", "width": "50%" }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "iDisplayLength": 15,
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbRcBarcode').DataTable().page.info().page * $('#tbRcBarcode').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }, "scrollX": true
            });

            $('#chkAllBarcode').on('click', function () {
                // Get all rows with search applied
                var rows = table.rows({ 'search': 'applied' }).nodes();
                // Check/uncheck checkboxes for all rows in the table
                $('input[type="checkbox"]', rows).prop('checked', this.checked);
            });

        }

        function PreparePO() {
            if ($("input[name='chkPO']:checked").length == 0) {
                dangerMsg("กรุณาเลือก PO ที่ต้องการยืนยันการรับก่อน!");
                return false;
            }

            $.each($("input[name='chkPO']:checked"), function (index, value) {
                $("[id*='hdChkPO']").val($("[id*='hdChkPO']").val() + ',' + value.value);
                //console.log(value.value);
            });

            $("[id*='hdChkPO']").val($("[id*='hdChkPO']").val().substring(1));

            return true;
        }

        function PrepareBarcode() {
            if ($("input[name='chkBarcode']:checked").length == 0) {
                dangerMsg("กรุณาเลือก Barcode ที่ต้องการยืนยันการรับก่อน!");
                return false;
            }

            $.each($("input[name='chkBarcode']:checked"), function (index, value) {
                $("[id*='hdChkBarcode']").val($("[id*='hdChkBarcode']").val() + ',' + value.value);
                //console.log(value.value);
            });

            $("[id*='hdChkBarcode']").val($("[id*='hdChkBarcode']").val().substring(1));

            return true;
        }

        function SearchByPO() {

            var postUrl = "ConfirmReceive.aspx/GetBarcodeByPO";
            var param = $('#txtSearchByPO').val();
            if (param == "") {
                param = " ";
            }
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{po: "' + param + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var dt = $('#tbRcAllPO').dataTable();
                    var data = JSON.parse(response.d);
                    //console.log(data);
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

        function SearchByBarcode() {

            var postUrl = "ConfirmReceive.aspx/GetBarcodeByBarcode";
            var param = $('#txtSearchByBarcode').val();
            if (param == "") {
                param = " ";
            }

            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{po: "' + param + '",barcodeStart:"' + $("[id*='txtBarcodeStart']").val() + '",barcodeEnd:"' + $("[id*='txtBarcodeEnd']").val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var dt = $('#tbRcBarcode').dataTable();
                    var data = JSON.parse(response.d);

                    //console.log(data);
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

        function Opentab(tab) {
            if (tab == 1) {
                SearchByPO();
            } else {
                //if (!$.fn.dataTable.isDataTable("#tbRcBarcode")) {
                //    BindTableAdjustEvent(data.Table)
                //}
                SearchByBarcode();
            }

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
                            <h3 class="box-title">รับ Barcode ตั้งต้น</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <input type="hidden" runat="server" id="hdChkPO" name="hdChkPO" />
                            <input type="hidden" runat="server" id="hdChkBarcode" name="hdChkBarcode" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="nav-tabs-custom">
                                                <ul class="nav nav-tabs">
                                                    <li class="active"><a href="#tab_1" data-toggle="tab" onclick="Opentab(1);">รับทั้ง PO</a></li>
                                                    <li><a href="#tab_2" data-toggle="tab" onclick="Opentab(2);">รับบางส่วน</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div class="tab-pane active" id="tab_1">
                                                        <div class="row">
                                                            <div class="col-xs-1 col-xs-offset-2">
                                                                PO No.
                                                            </div>
                                                            <div class="col-xs-3">
                                                                <input type="text" id="txtSearchByPO" class="form-control" />
                                                            </div>
                                                            <div class="col-xs-3">
                                                                <%--<asp:LinkButton ID="btnSearchByPO"
                                                                    runat="server"
                                                                    CssClass="btn btn-primary" OnClick="btnSearchByPO_Click">
                                                                        <span aria-hidden="true" class="glyphicon glyphicon-search"></span>
                                                                </asp:LinkButton>--%>
                                                                <button type="button" class="btn btn-success" onclick="SearchByPO()">
                                                                    <span class="glyphicon glyphicon-search"></span>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <br />
                                                        <div class="row">
                                                            <div class="col-xs-2">
                                                                <asp:Button ID="btnConfirm" runat="server" CssClass="btn btn-success" Text="ยืนยันการรับ" OnClick="btnConfirm_Click" OnClientClick="return PreparePO()" />
                                                            </div>
                                                            <div class="col-xs-10">
                                                                <table id="tbRcAllPO" class="table table-bordered table-striped" >
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="text-align: center;">ลำดับ</th>
                                                                            <th style="text-align: center;">
                                                                                <input type="checkbox" name="chkAll" value="1" id="chkAll" /></th>
                                                                            <th style="text-align: center;">PO No.</th>
                                                                            <th style="text-align: center;">จำนวน</th>
                                                                            <th style="text-align: center;">จำนวนที่รับ</th>
                                                                            <th style="text-align: center;">สถานะ</th>
                                                                        </tr>
                                                                    </thead>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- /.tab-pane -->
                                                    <div class="tab-pane" id="tab_2">
                                                        <div class="row">
                                                            <div class="col-xs-1 col-xs-offset-2">
                                                                PO No.
                                                            </div>
                                                            <div class="col-xs-3">
                                                                <input type="text" id="txtSearchByBarcode" class="form-control" />
                                                            </div>
                                                            <div class="col-xs-3">
                                                                <button type="button" class="btn btn-success" onclick="SearchByBarcode()">
                                                                    <span class="glyphicon glyphicon-search"></span>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <br />
                                                        <div class="row">
                                                            <div class="col-xs-1 col-xs-offset-2">
                                                                Barcode เริ่มต้น
                                                            </div>
                                                            <div class="col-xs-2">
                                                                <input type="text" id="txtBarcodeStart" class="form-control" />
                                                            </div>
                                                            <div class="col-xs-1 col-xs-offset-2">
                                                                Barcode สิ้นสุด
                                                            </div>
                                                            <div class="col-xs-2">
                                                                <input type="text" id="txtBarcodeEnd" class="form-control" />
                                                            </div>
                                                        </div>
                                                        <br />
                                                        <div class="row">
                                                            <div class="col-xs-2">
                                                                <asp:Button ID="btnConfirmBarcode" runat="server" CssClass="btn btn-success" Text="ยืนยันการรับ" OnClick="btnConfirmBarcode_OnClick" OnClientClick="return PrepareBarcode()" />
                                                            </div>
                                                            <div class="col-xs-10">
                                                                <table id="tbRcBarcode" class="table table-bordered table-striped" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>ลำดับ</th>
                                                                            <th>
                                                                                <input type="checkbox" name="chkAllBarcode" value="1" id="chkAllBarcode" /></th>
                                                                            <th>PO No.</th>
                                                                            <th>Barcode</th>
                                                                        </tr>
                                                                    </thead>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- /.tab-pane -->
                                                </div>
                                                <!-- /.tab-content -->
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
