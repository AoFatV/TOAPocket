<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="Painter.aspx.cs" Inherits="TOAPocket.UI.Web.Painter.Painter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>
    <script type="text/javascript">

        $(function () {

            InitialTb();

        });

        function InitialTb() {
            var postUrl = "Painter.aspx/GetPainter";
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
            console.log(data);
            var table = $('#tbPainter').DataTable({
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
                        "data": "PAINTER_NO",
                        render: function (data, type, row) {
                            return "<a href='Painter_Detail.aspx?Id=" + row.ID + "' >" + row.PAINTER_NO + "</a>";
                        }, className: "dt-center"
                    },
                    {
                        "data": "FIRST_NAME", className: "dt-center",
                        render: function (data, type, row) {
                            var name = row.FIRST_NAME + " " + row.LAST_NAME;
                            return name;
                        }
                    },
                    {
                        "data": "EMAIL", className: "dt-center"
                    },
                    {
                        "data": "AREA_DESC", className: "dt-center"
                    },
                    {
                        "data": "OCCUPATION_DESC", className: "dt-center"
                    },
                    {
                        "data": "IS_REGISTER", className: "dt-center",
                        render: function (data, type, row) {
                            if (row.IS_REGISTER == "Y") {
                                var buttonOk = '<button type="button" class="btn btn-success btn-circle"><span class="glyphicon glyphicon-ok"></span></button>';
                            } else {
                                var buttonOk = '<button type="button" class="btn btn-danger btn-circle"><span class="glyphicon glyphicon-remove"></span></button>';
                            }
                            return buttonOk;
                        }
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbPainter').DataTable().page.info().page * $('#tbPainter').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }, "scrollX": true
            });
        }

        function SearchPainter() {
            var dt = $('#tbPainter').dataTable();
            var postUrl = "Painter.aspx/GetPainter";
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

        .btn-circle {
            width: 30px;
            height: 30px;
            text-align: center;
            padding: 6px 0;
            font-size: 12px;
            line-height: 1.42;
            border-radius: 15px;
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
                            <h3 class="box-title">ข้อมูล Painter</h3>
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
                                                        <button type="button" class="btn btn-info" onclick="SearchPainter()">
                                                            <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-12">
                                                    <table id="tbPainter" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 1%; text-align: center;"></th>
                                                                <th style="text-align: center;">Painter No.</th>
                                                                <th style="text-align: center;">ชื่อ</th>
                                                                <th style="text-align: center;">E-Mail</th>
                                                                <th style="text-align: center;">เขตพื้นที่</th>
                                                                <th style="text-align: center;">อาชีพ</th>
                                                                <th style="text-align: center;">Register</th>
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
