<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="News.aspx.cs" Inherits="TOAPocket.UI.Web.News.News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--<link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />--%>
    <link href="../Content/jquery.dataTables.min2.css" rel="stylesheet" />
    <link href="../Content/responsive.dataTables.min2.css" rel="stylesheet" />
    <script src="../Scripts/dataTables.responsive.js"></script>
    <script type="text/javascript">
        $(function () {

            $("[id*='txtNewsStart']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtNewsEnd']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtNewsStart']").datepicker("setDate", new Date());
            $("[id*='txtNewsEnd']").datepicker("setDate", new Date());


            InitialTbNews();
        });

        function InitialTbNews() {

            //data: '{newsName: "' + ""
            //      + '",newsStartDate:"' + $("[id*='txtNewsStart']").val()
            //      + '",newsEndDate:"' + $("[id*='txtNewsEnd']").val()
            //      + '",userType:"' + $("[id*='ddlUserType'] option:selected").text()
            //      + '",status:"' + $("[id*='ddlStatus'] option:selected").val()
            //      + '",refNo:"' + ""
            //      + '" }',

            var postUrl = "News.aspx/GetNews";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{newsName: "' + ""
                    + '",newsStartDate:"' + ""
                    + '",newsEndDate:"' + ""
                    + '",userType:"' + $("[id*='ddlUserType'] option:selected").text()
                    + '",status:"' + $("[id*='ddlStatus'] option:selected").val()
                    + '",refNo:"' + ""
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTable,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindTable(response) {

            //console.log(response.d);
            var data = JSON.parse(response.d);

            var table = $('#tbNews').DataTable({
                //"processing": true,
                "responsive": true,
                "data": (data),
                "columns": [
                    {
                        "data": null, className: "dt-center"
                    },
                    {
                        "data": "REF_NO",
                        render: function (data, type, row) {
                            return "<a href='News_Update.aspx?refNO=" + row.REF_NO + "' >" + row.REF_NO + "</a>";
                        }, className: "dt-center"
                    },
                    { "data": "SUBJECT", className: "dt-center" },
                    { "data": "USER_TYPE_NAME", className: "dt-center" },
                    {
                        "data": "DATE_FROM", render: function (data, type, row) {
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
                        }, className: "dt-center"
                    },
                    {
                        "data": "DATE_TO", render: function (data, type, row) {
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
                        }, className: "dt-center"
                    },
                    {
                        "data": "Status", className: "dt-center", "width": "10%"
                    }
                ],
                "bFilter": false,
                //"order": [[3, "desc"]],
                "ordering": false,
                "bPaginate": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $("td:first", nRow).html(($('#tbNews').DataTable().page.info().page * $('#tbNews').DataTable().page.info().length) + iDisplayIndex + 1);
                    return nRow;
                }, "scrollX": true
            });
        }

        function SearchNews() {
            var dt = $('#tbNews').dataTable();
            var postUrl = "News.aspx/GetNews";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{newsName: "' + $("[id*='txtNewsName']").val()
                    + '",newsStartDate:"' + $("[id*='txtNewsStart']").val()
                    + '",newsEndDate:"' + $("[id*='txtNewsEnd']").val()
                    + '",userType:"' + $("[id*='ddlUserType'] option:selected").text()
                    + '",status:"' + $("[id*='ddlStatus'] option:selected").val()
                    + '",refNo:"' + ""
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

        function CreateNews() {
            window.location = "News_Create.aspx";
        }

        function CancelSearch() {
            $("[id*='txtNewsName']").val("");
            $("[id*='txtNewsStart']").datepicker("setDate", new Date());
            $("[id*='txtNewsEnd']").datepicker("setDate", new Date());
            $("[id*='ddlUserType']").val("");
            $("[id*='ddlStatus']").val("");
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
                            <h3 class="box-title">ข่าวสาร</h3>
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
                                                <div class="col-xs-3 col-xs-offset-2 col-md-1 col-md-offset-2">
                                                    ชื่อเรื่อง 
                                                </div>
                                                <div class="col-xs-6 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtNewsName"></asp:TextBox>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-3 col-xs-offset-2 col-md-1 col-md-offset-2">
                                                    ช่วงวันที่ 
                                                </div>
                                                <div class="col-xs-6 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtNewsStart"></asp:TextBox>
                                                </div>
                                                <div class="col-xs-3 col-xs-offset-2 col-md-1 col-md-offset-0">
                                                    ถึง
                                                </div>
                                                <div class="col-xs-6 col-md-2">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtNewsEnd"></asp:TextBox>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-4 col-xs-offset-1 col-md-1 col-md-offset-2">
                                                    กลุ่มผู้รับข่าว
                                                </div>
                                                <div class="col-xs-6 col-md-2">
                                                    <asp:DropDownList runat="server" CssClass="form-control" ID="ddlUserType" />
                                                </div>
                                                <div class="col-xs-3 col-xs-offset-2 col-md-1 col-md-offset-0">
                                                    สถานะ
                                                </div>
                                                <div class="col-xs-6 col-md-2">
                                                    <asp:DropDownList runat="server" CssClass="form-control" ID="ddlStatus" />
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-md-5 col-md-offset-5 col-xs-11 col-xs-offset-1">
                                                    <button type="button" class="btn btn-success" runat="server" id="btnSearch" onclick="SearchNews()">
                                                        <span class="glyphicon glyphicon-search"></span>&nbsp;ค้นหา
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelSearch()">
                                                        <span class="glyphicon glyphicon-remove"></span>&nbsp;ยกเลิก
                                                    </button>
                                                    <button type="button" class="btn btn-success" runat="server" id="btnCreateNews" onclick="CreateNews()">
                                                        <span class="glyphicon glyphicon-plus"></span>&nbsp;เพิ่มข้อมูล
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <table id="tbNews" class="table responsive display nowrap dtr-inline collapsed" cellspacing="0" width="100%">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 1%; text-align: center;">ลำดับ</th>
                                                        <th style="text-align: center;">Ref No.</th>
                                                        <th style="text-align: center;">ชื่อเรื่อง</th>
                                                        <th style="text-align: center;">กลุ่มผู้รับข่าว</th>
                                                        <th style="text-align: center;">วันที่เริ่มต้น</th>
                                                        <th style="text-align: center;">วันที่สิ้นสุด</th>
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
