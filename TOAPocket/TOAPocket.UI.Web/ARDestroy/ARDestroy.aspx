<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="ARDestroy.aspx.cs" Inherits="TOAPocket.UI.Web.ARDestroy.ARDestroy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />

    <script type="text/javascript">

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
                                                    <table id="tbArWhDestroy" class="table table-bordered table-striped" width="100%">
                                                        <thead>
                                                            <tr>
                                                                <th style="text-align: center;">ชื่อ Sale</th>
                                                                <th style="text-align: center;">นน. ประมาณ (20)</th>
                                                                <th style="text-align: center;">นน. ประมาณ (30)</th>
                                                                <th style="text-align: center;">นน. ประมาณ (60)</th>
                                                                <th style="text-align: center;">นน. ประมาณ (kg.)</th>
                                                                <th style="text-align: center;">นน. รับจริง  (kg.)</th>
                                                                <th style="text-align: center;">หมายเหตุ</th>
                                                            </tr>
                                                        </thead>
                                                    </table>
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
