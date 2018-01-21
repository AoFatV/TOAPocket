<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="ConfirmGR.aspx.cs" Inherits="TOAPocket.UI.Web.GR.ConfirmGR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>
    <script type="text/javascript">
        $(function () {

            $("[id*='txtGrStart']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtGrEnd']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!

            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd;
            }
            if (mm < 10) {
                mm = '0' + mm;
            }

            today = dd + '/' + mm + '/' + yyyy;

            $("[id*='txtGrStart']").val(today);
            $("[id*='txtGrEnd']").val(today);

            InitialTb_1();
        });

        function InitialTb_1() {
            var postUrl = "ConfirmGR.aspx/GetProcessOrderGR";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{processOrder: "' + ""
                    + '",btfs:"' + ""
                    + '",status:"' + ""
                    + '",grStart:"' + ""
                    + '",grEnd:"' + ""
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
            var table = $('#tbGr').DataTable({
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
                        "data": "PROCESS_ID",
                        render: function (data, type, row, meta) {
                            //console.log(meta.row);
                            //console.log(type);
                            //console.log(row);
                            if (type === 'display') {
                                return '<input type="checkbox" name="chkPO" id="chkPO_' + meta.row + '" value="' + data + '"  class="chk" style="display:none;" >';
                            }
                            return "";
                        },
                        className: "dt-center", "orderable": false
                    },
                    {
                        "data": "PROCESS_NO", className: "dt-body-center"
                    },
                    {
                        "data": "MAT_NO", className: "dt-body-center"
                    },
                    {
                        "data": "MAT_DESC", className: "dt-body-center"
                    },
                    {
                        "data": "BTFS", className: "dt-body-center"
                    },
                    {
                        "data": "BATCH_NO", className: "dt-body-center"
                    },
                    {
                        "data": "ORDER_QTY", className: "dt-body-center"
                    },
                    {
                        "data": "GR_QTY", className: "dt-body-center"
                    },
                    {
                        "data": "MATCH_QTY", className: "dt-body-center"
                    },
                    {
                        "data": "LAST_REL_DATE",
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
                        "data": "GR_DATE",
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
                        "data": "STATUS_NAME", className: "dt-body-center"
                    },
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                //"iDisplayLength": 15,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
                //"fnRowCallback": function (nRow, aData, iDisplayIndex) {
                //    $("td:first", nRow).html(($('#tbGr').DataTable().page.info().page * $('#tbGr').DataTable().page.info().length) + iDisplayIndex + 1);
                //    return nRow;
                //}
                //, "scrollX": true
            });
        }

        function SearchGR() {
            var dt = $('#tbGr').dataTable();
            var postUrl = "ConfirmGR.aspx/GetProcessOrderGR";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{processOrder: "' + $("[id*='txtProcessOrder']").val()
                    + '",btfs:"' + $("[id*='txtBtfs']").val()
                    + '",status:"' + $("[id*='ddlStatus']").val()
                    + '",grStart:"' + $("[id*='txtGrStart']").val()
                    + '",grEnd:"' + $("[id*='txtGrEnd']").val()
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
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!

            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd;
            }
            if (mm < 10) {
                mm = '0' + mm;
            }

            today = dd + '/' + mm + '/' + yyyy;

            $("[id*='txtProcessOrder']").val('');
            $("[id*='txtBtfs']").val('');
            $("[id*='ddlStatus']").val('');
            $("[id*='txtGrStart']").val(today);
            $("[id*='txtGrEnd']").val(today);
        }


        function GetGR() {

            $('#tbGr').find('tbody tr').each(function (i, el) {
                var $tds = $(this).find('td');
                //console.log(i);
                var grQty = $tds.eq(7).text();
                var matchQty = $tds.eq(8).text();
                
                if (grQty == matchQty) {
                    $tds.eq(7).css("background-color", "green");
                    $tds.eq(8).css("background-color", "green");

                    $("[id*='chkPO_" + i + "']").css("display", "block");
                } else {
                    $tds.eq(7).css("background-color", "red");
                    $tds.eq(8).css("background-color", "red");
                }
            });

        }

        function ConfirmGR() {
            var valid = true;
            if ($("[id*='chkPO']:checked").length == 0) {
                dangerMsg("กรุณาเลือก Process Order ก่อน !");
                valid = false;
            }

            if (valid) {
                var chkPo = "";
                $.each($("[id*='chkPO']:checked"), function (index, value) {
                    //console.log(value.value);
                    chkPo = chkPo + value.value + ",";
                });

                chkPo = chkPo.substring(0, chkPo.length - 1);

                var postUrl = "ConfirmGR.aspx/ConfirmProcessOrderGR";
                $.ajax({
                    type: "POST",
                    url: postUrl,
                    data: '{poId: "' + chkPo
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
        }
    </script>
    <style type="text/css">
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0px;
        }

        /*.hideChk {
            display: none;
        }*/
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
                            <h3 class="box-title">Confirm GR</h3>
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
                                                <div class="col-xs-2 col-md-2 col-md-offset-2 text-right">
                                                    Process Order 
                                                </div>
                                                <div class="col-xs-4 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtProcessOrder"></asp:TextBox>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-2 col-md-2 col-md-offset-2 text-right">
                                                    BTFS 
                                                </div>
                                                <div class="col-xs-4 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtBtfs"></asp:TextBox>
                                                </div>
                                                <div class="col-xs-2 col-md-1  text-right">
                                                    สถานะ
                                                </div>
                                                <div class="col-xs-4 col-md-2">
                                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-2 col-md-2 col-md-offset-2 text-right">
                                                    วันที่ GR. 
                                                </div>
                                                <div class="col-xs-4 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtGrStart"></asp:TextBox>
                                                </div>
                                                <div class="col-xs-2 col-md-1  text-right">
                                                    ถึง
                                                </div>
                                                <div class="col-xs-4 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtGrEnd"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-12 col-md-8 col-md-offset-6">
                                            <div class="row">
                                                <div class="col-xs-12 col-md-12">
                                                    <button type="button" class="btn btn-success" onclick="ConfirmGR()">
                                                        <span class="glyphicon glyphicon-save"></span>&nbsp;Confirm GR
                                                    </button>
                                                    <button type="button" class="btn btn-warning" onclick="GetGR()">
                                                        <span class="glyphicon glyphicon-search"></span>&nbsp;ดึงข้อมูล GR
                                                    </button>
                                                    <button type="button" class="btn btn-info" onclick="SearchGR()">
                                                        <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelSearch()">
                                                        <span class="glyphicon glyphicon-remove"></span>&nbsp;ยกเลิก
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <table id="tbGr" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                <thead>
                                                    <tr>
                                                        <th data-priority="1" style="text-align: center;"></th>
                                                        <th data-priority="1" style="text-align: center;">Process Order</th>
                                                        <th data-priority="1" style="text-align: center;">Material</th>
                                                        <th style="text-align: center;">Mat Description</th>
                                                        <th style="text-align: center;">BTFS</th>
                                                        <th style="text-align: center;">Batch No</th>
                                                        <th style="text-align: center;">Order Qty</th>
                                                        <th data-priority="1" style="text-align: center;">GR Qty</th>
                                                        <th data-priority="1" style="text-align: center;">Match Qty</th>
                                                        <th style="text-align: center;">Rel Date</th>
                                                        <th style="text-align: center;">GR Date</th>
                                                        <th style="text-align: center;">สถานะ</th>
                                                    </tr>
                                                </thead>
                                            </table>
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
