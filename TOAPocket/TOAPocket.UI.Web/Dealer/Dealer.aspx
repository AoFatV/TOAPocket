<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="Dealer.aspx.cs" Inherits="TOAPocket.UI.Web.Dealer.Dealer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>
    <script type="text/javascript">

        $(function () {

            InitialTb();

        });

        function InitialTb() {
            var postUrl = "Dealer.aspx/GetDealer";
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
            var table = $('#tbDealer').DataTable({
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
                        }, className: "dt-center"

                    },
                    {
                        "data": "DEALER_ID",
                        render: function (data, type, row) {
                            return "<a href='Dealer_Detail.aspx?Dealer=" + row.DEALER_ID + "' >" + row.DEALER_ID + "</a>";
                        }, className: "dt-center"
                    },
                    {
                        "data": "DEALER_NAME", className: "dt-center"
                    },
                    {
                        "data": "CITY_DESC", className: "dt-center"
                    },
                    {
                        "data": "MOBILE", className: "dt-center"
                    },
                    {
                        "data": "EMAIL", className: "dt-center"
                    },
                    {
                        "data": "SALES_TA_NAME", className: "dt-center"
                    },
                    {
                        "data": "SALES_TB_NAME", className: "dt-center"
                    },
                    {
                        "data": "RECEIVE_MAX_QTY", className: "dt-center"
                    },
                    {
                        "data": "TAX_NO_3", className: "dt-center"
                    },
                    {
                        "data": "VENDOR_CODE", className: "dt-center"
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                //"pageLength": 50,
                "sPaginationType": "full_numbers",
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbDealer').DataTable().page.info().page * $('#tbDealer').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }, "scrollX": true
            });
        }

        function SearchDealer() {
            var dt = $('#tbDealer').dataTable();
            var postUrl = "Dealer.aspx/GetDealer";
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
                            <h3 class="box-title">ข้อมูล Dealer</h3>
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
                                                    <div class="col-xs-3 col-md-2 text-center">
                                                        ค้นหา
                                                    </div>
                                                    <div class="col-xs-6 col-md-4">
                                                        <input type="text" id="txtSearch" class="form-control" runat="server" />
                                                    </div>
                                                    <div class="col-xs-3 col-ms-4">
                                                        <button type="button" class="btn btn-info" onclick="SearchDealer()">
                                                            <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-12">
                                                    <table id="tbDealer" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 1%; text-align: center;"></th>
                                                                <th data-priority="1" style="text-align: center;">Dealer ID</th>
                                                                <th data-priority="1" style="text-align: center;">ชื่อร้านค้า</th>
                                                                <th data-priority="1" style="text-align: center;">City</th>
                                                                <th data-priority="1" style="text-align: center;">Mobile</th>
                                                                <th style="text-align: center;">E-mail</th>
                                                                <th style="text-align: center;">ชื่อ Sale TA</th>
                                                                <th style="text-align: center;">ชื่อ Sale TB</th>
                                                                <th style="text-align: center;">Sale รับได้สูงสุด</th>
                                                                <th style="text-align: center;">Tax No.3</th>
                                                                <th style="text-align: center;">Vendor Code</th>
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
