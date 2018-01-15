<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="ARReceive.aspx.cs" Inherits="TOAPocket.UI.Web.ARReceive.ARReceive" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <%--   <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>--%>
    <script type="text/javascript">
        var editSaleId;
        $(function () {

            InitialTb();
        });

        function InitialTb() {
            var postUrl = "ARReceive.aspx/GetSaleRedeem";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{search: "' + ""
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTb,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindTb(response) {

            var data = JSON.parse(response.d);
            //console.log(data);
            var table = $('#tbArWhReceive').DataTable({
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
                        "data": "SALE_ID",
                        render: function (data, type, row) {
                            if (type === 'display') {
                                return '<input type="checkbox" name="chkSale" id="chkSale" value="' + data + '" name="chkPO" class="chk" >';
                            }
                            return "";
                        },
                        className: "dt-center", "orderable": false
                    },
                    {
                        "data": "SALE_ID",
                        render: function (data, type, row) {
                            var name = row.SALE_ID + " " + row.SALE_NAME;
                            return name;
                        },
                        className: "col-xs-2 dt-center"
                    },
                    {
                        "data": "SALE_RETURN_20_QTY", className: "col-xs-1 dt-center",
                        render: function (data, type, row) {
                            return '<label  id="lbRt20_' + row.SALE_ID + '">' + row.SALE_RETURN_20_QTY + '</label>';
                        }
                    },
                    {
                        "data": null, className: "col-xs-2 dt-center",
                        render: function (data, type, row) {
                            return '<input type="number" id="txtRt20_' + row.SALE_ID + '" onchange="ChangeWhReem()" class="form-control " readonly min="0"/>';
                        }
                    },
                    {
                        "data": "SALE_RETURN_30_QTY", className: "col-xs-1 dt-center",
                        render: function (data, type, row) {
                            return '<label  id="lbRt30_' + row.SALE_ID + '">' + row.SALE_RETURN_30_QTY + '</label>';
                        }

                    },
                    {
                        "data": null, className: "col-xs-2 dt-center",
                        render: function (data, type, row) {
                            return '<input type="number" id="txtRt30_' + row.SALE_ID + '" onchange="ChangeWhReem()" class="form-control" readonly min="0"/>';
                        }
                    },
                    {
                        "data": "SALE_RETURN_60_QTY", className: "col-xs-1 dt-center",
                        render: function (data, type, row) {
                            return '<label  id="lbRt60_' + row.SALE_ID + '">' + row.SALE_RETURN_60_QTY + '</label>';
                        }
                    },
                    {
                        "data": null, className: "col-xs-2 dt-center",
                        render: function (data, type, row) {
                            return '<input type="number" id="txtRt60_' + row.SALE_ID + '" onchange="ChangeWhReem()" class="form-control" readonly min="0"/>';
                        }
                    },
                    {
                        "data": "SALE_RETURN_TOTAL", className: "col-xs-2 dt-center",
                        render: function (data, type, row) {
                            return '<label type="number" id="lbTotalRt_' + row.SALE_ID + '">' + row.SALE_RETURN_TOTAL + '</label>';
                        }
                    },
                    {
                        "data": null, className: "col-xs-1 dt-center",
                        render: function (data, type, row) {
                            return '<label type="number" id="lbTotalLoseRt_' + row.SALE_ID + '">0</label>';
                        }
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                //"fnRowCallback": function (nRow, aData, iDisplayIndex) {
                //    $("td:first", nRow).html(($('#tbArWhReceive').DataTable().page.info().page * $('#tbArWhReceive').DataTable().page.info().length) + iDisplayIndex + 1);
                //    return nRow;
                //}, "scrollX": true
            });


            $(table.table().container()).removeClass('form-inline');

            $('input[type=checkbox]').click(function () {
                $.each($('input[type=checkbox]'), function (key, val) {
                    this.checked = false;
                });

                this.checked = true;
                var id = this.value;

                editSaleId = id;

                $.each($("[id*='" + id + "']"), function (key, val) {
                    $("[id*='txtRt20_" + id + "']").prop('readonly', false);
                    $("[id*='txtRt30_" + id + "']").prop('readonly', false);
                    $("[id*='txtRt60_" + id + "']").prop('readonly', false);
                });
            });


            //$("[id*='txtRt20_" + editSaleId + "']").change(function () {
            //    alert(1);
            //});

            //$("[id*='txtRt30_" + editSaleId + "']").change(function () {
            //    alert(1);
            //});

            //$("[id*='txtRt60_" + editSaleId + "']").change(function () {
            //    alert(1);
            //});
        }

        function SearchArWhReceive() {
            editSaleId = "";
            var dt = $('#tbArWhReceive').dataTable();
            var postUrl = "ARReceive.aspx/GetARWHReceive";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{search: "' + $("[id*='txtSearch']").val()
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
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

        function ConfirmRedeem() {
            //valid 3 textbox
            var valid = true;
            if (editSaleId == "") {
                dangerMsg("กระรุณาระบุ Sale !");
                valid = false;
            } else if ($("[id*='txtRt20_" + editSaleId + "']").val() == "") {
                dangerMsg("กระรุณาระบุ รับคืน (20) !");
                valid = false;
            } else if ($("[id*='txtRt30_" + editSaleId + "']").val() == "") {
                dangerMsg("กระรุณาระบุ รับคืน (30) !");
                valid = false;
            } else if ($("[id*='txtRt60_" + editSaleId + "']").val() == "") {
                dangerMsg("กระรุณาระบุ รับคืน (60) !");
                valid = false;
            }

            if (valid) {
                confirmBox("ยืนยันการรับเหรียญคืน ", ConfirmArWhReceive);
            }
        }

        function ConfirmArWhReceive() {

            var postUrl = "ARReceive.aspx/InsertWhRedeemQty";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{saleId: "' + editSaleId
                   + '",saleReturn20Qty:"' + $("[id*='lbRt20_" + editSaleId + "']").text()
                   + '",whReturn20Qty:"' + $("[id*='txtRt20_" + editSaleId + "']").val()
                   + '",saleReturn30Qty:"' + $("[id*='lbRt30_" + editSaleId + "']").text()
                   + '",whReturn30Qty:"' + $("[id*='txtRt30_" + editSaleId + "']").val()
                   + '",saleReturn60Qty:"' + $("[id*='lbRt60_" + editSaleId + "']").text()
                   + '",whReturn60Qty:"' + $("[id*='txtRt60_" + editSaleId + "']").val()
                   + '",totalLostReturnQty:"' + $("[id*='lbTotalLoseRt_" + editSaleId + "']").text()
                   + '",createBy:"' + $("[id*='hdUserName']").val()
                   + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (data.length > 0) {
                        if (data[0].result == "true") {
                            successMsg("บันทึกข้อมูลเรียบร้อย");
                            Search();
                        } else {
                            dangerMsg("เกิดข้อผิดพลาด!");
                        }
                    }
                },
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function ChangeWhReem() {

            var whr1 = parseInt($("[id*='txtRt20_" + editSaleId + "']").val()) || 0;
            var whr2 = parseInt($("[id*='txtRt30_" + editSaleId + "']").val()) || 0;
            var whr3 = parseInt($("[id*='txtRt60_" + editSaleId + "']").val()) || 0;

            var totalRt = parseInt($("[id*='lbTotalRt_" + editSaleId + "']").text()) || 0;

            $("[id*='lbTotalLoseRt_" + editSaleId + "']").text(totalRt - (whr1 + whr2 + whr3));
        }

        function CancelRedeem() {


        }
    </script>


    <style type="text/css">
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0px;
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
                            <h3 class="box-title">รับเหรียญคืน</h3>
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
                                                <div class="col-xs-9">
                                                    <div class="col-xs-2 text-center">
                                                        ค้นหา
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtSearch" class="form-control" runat="server" />
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <button type="button" class="btn btn-info" onclick="SearchArWhReceive()">
                                                            <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-12">
                                                    <table id="tbArWhReceive" class="table table-bordered table-striped" width="100%">
                                                        <thead>
                                                            <tr>
                                                                <th style="text-align: center;"></th>
                                                                <th style="text-align: center;">ชื่อ Sale</th>
                                                                <th style="text-align: center;">จำนวนส่งคืน (20)</th>
                                                                <th style="text-align: center;">รับคืน (20)</th>
                                                                <th style="text-align: center;">จำนวนส่งคืน (30)</th>
                                                                <th style="text-align: center;">รับคืน (30)</th>
                                                                <th style="text-align: center;">จำนวนส่งคืน  (60)</th>
                                                                <th style="text-align: center;">รับคืน (60)</th>
                                                                <th style="text-align: center;">จำนวนรวมที่รับคืน</th>
                                                                <th style="text-align: center;">เหรียญหาย</th>
                                                            </tr>
                                                        </thead>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 text-center">
                                                    <button type="button" class="btn btn-success" onclick="ConfirmRedeem()">
                                                        <span class="glyphicon glyphicon-save"></span>ยืนยัน
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelRedeem()">
                                                        <span class="glyphicon glyphicon-remove"></span>ยกเลิก
                                                    </button>
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
