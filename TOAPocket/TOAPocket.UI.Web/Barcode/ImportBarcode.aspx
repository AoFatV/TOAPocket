<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="ImportBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.ImportBarcode" %>

<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        var actionResult = "<%=actionResult %>";
        var msgResult = "<%=msg %>";

        var totalData = 0;
        $(function () {
            if (msgResult != "") {
                if (actionResult == 'True') {
                    successMsg(msgResult);
                } else {
                    dangerMsg(msgResult);
                }
            }

            $('#tbBarcode').DataTable({
                'paging': true,
                'lengthChange': false,
                'searching': false,
                'ordering': true,
                'info': true,
                'autoWidth': false
            });

            $("[id*='fileUpload']").change(function () {
                var file = this.files[0];
                var reader = new FileReader();

                $("#txtFileUploadName").val(file.name);

            });


            totalData = "<%=dtUpload.Rows.Count%>";
        });

        function checkFileUpload() {

            if ($("#txtFileUploadName").val() == "") {
                dangerMsg("กรุณาเลือกไฟล์ก่อนทำการ Upload");
                return false;
            }

            return true;
        }

        function clearFileUpload() {
            $("#txtFileUploadName").val("");
        }

        function ImportBarode() {
            if (totalData == 0) {
                dangerMsg("กรุณาทำการ Upload ไฟล์ก่อน");
                return false;
            }

            return true;
        }
    </script>
    <style type="text/css">
        .btn-bs-file input[type="file"] {
            position: absolute;
            top: -9999999;
            filter: alpha(opacity=0);
            opacity: 0;
            width: 0;
            height: 0;
            outline: none;
            cursor: inherit;
        }

        .btn-bs-file {
            position: relative;
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
                            <h3 class="box-title">Import Barcode</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-2">
                                            <label for="fileUpload">File input</label>
                                        </div>
                                        <div class="col-xs-3">
                                            <input type="text" disabled="disabled" id="txtFileUploadName" class="form-control" />
                                        </div>
                                        <div class="col-xs-6">
                                            <label class="btn-bs-file btn btn-default">
                                                <span class="glyphicon glyphicon-folder-open"></span>
                                                <span class="">Browse</span>
                                                <%--<input type="file" id="fileUpload" runat="server" />--%>
                                                <asp:FileUpload ID="fileUpload" runat="server" />
                                            </label>
                                            <asp:Button runat="server" ID="btnUpload" OnClick="btnUpload_OnClick" Text="Upload" CssClass="btn btn-info" OnClientClick="return checkFileUpload()" />

                                            <div class="btn btn-info" onclick="clearFileUpload();">
                                                <span class="glyphicon glyphicon-trash"></span>
                                                <span class="">Clear</span>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-xs-12">
                                        <table id="tbBarcode" class="table table-bordered table-striped">
                                            <thead>
                                                <tr>
                                                    <th class="text-center">PO No</th>
                                                    <th class="text-center">QR Code</th>
                                                    <th class="text-center">Barcode</th>
                                                    <th class="text-center">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% foreach (DataRow dr in dtUpload.Rows)
                                                    {
                                                %>
                                                <tr>
                                                    <td class="text-center"><%=dr[0] %></td>
                                                    <td class="text-center"><%=dr[1] %></td>
                                                    <td class="text-center"><%=dr[2] %></td>
                                                    <td class="text-center"><%=dr[3] %></td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="row">
                                    <div class="col-xs-3  col-sm-offset-3">
                                        <asp:Button runat="server" ID="btnImport" Text="Import" CssClass="btn btn-success" OnClick="btnImport_OnClick" OnClientClick="return ImportBarode()" />
                                        <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="btn btn-success" OnClick="btnCancel_OnClick" />
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
