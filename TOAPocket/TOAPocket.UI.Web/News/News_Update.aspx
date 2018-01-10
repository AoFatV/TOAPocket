<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="News_Update.aspx.cs" Inherits="TOAPocket.UI.Web.News.News_Update" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/bower_components/ckeditor/ckeditor.js"></script>

    <script type="text/javascript">
        var hasUpload = false;
        $(function () {

            $("[id*='txtStartDate']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtEndDate']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            CKEDITOR.replace('editor1');
            CKEDITOR.instances.editor1.setData($("[id*='hdEditor']").val());


            $('#SuccessBox').on('hidden.bs.modal', function () {
                window.location = "News.aspx";
            });
        });

        function ConfirmCreateNews() {
            var valid = true;
            if ($("[id*='txtNewsName']").val() == "") {
                dangerMsg("กรุณาระบุ ชื่อเรื่อง!");
                valid = false;
            } else if ($("[id*='txtStartDate']").val() == "") {
                dangerMsg("กรุณาระบุ วันที่เริ่มต้น!");
                valid = false;
            } else if (CKEDITOR.instances.editor1.getData() == "") {
                dangerMsg("กรุณาระบุ เนื้อหา!");
                valid = false;
            } else if (!hasUpload) {
                dangerMsg("กรุณาอัพโหลด Thumbnail!");
                valid = false;
            }

            if (valid) {
                UploadImage();
            }
        }

        function UpdateNews(extension) {

            var postUrl = "News_Create.aspx/UpdateNews";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{refNo: "' + $("[id*='txtRefNo']").text()
                    + '",newsName:"' + $("[id*='txtNewsName']").val()
                    + '",newsStartDate:"' + $("[id*='txtStartDate']").val()
                    + '",newsEndDate:"' + $("[id*='txtEndDate']").val()
                    + '",userType:"' + $("[id*='ddlUserType'] option:selected").text()
                    + '",status:"' + $("[id*='rdStatus'] :checked").val()
                    + '",extension:"' + extension
                    + '",createBy: "' + $("[id*='hdUserName']").val()
                    + '",detail: "' + CKEDITOR.instances.editor1.getData()
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (data.length > 0) {
                        if (data[0].result) {
                            successMsg("บันทึกข้อมูลเรียบร้อย");
                        } else {
                            dangerMsg("เกิดข้อผิดพลาด!");
                        }
                    }
                },
                failure: function (response) {
                    console.log(response.d);
                }
            });

        }

        function InitialRefNo() {
            $("[id*='txtRefNo']").val('');
            var postUrl = "News_Create.aspx/GetRefRunningNo";
            $.ajax({
                type: "POST",
                url: postUrl,
                //data: '{condition: 1 }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindRefNo,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindRefNo(response) {
            var data = JSON.parse(response.d);
            if (data.length > 0) {
                $("[id*='txtRefNo']").text(data[0].Running);
            }
        }

        function previewFile() {
            var preview = document.querySelector("[id*='imgPreview']");
            var file = document.querySelector('input[type=file]').files[0];
            var reader = new FileReader();

            reader.onloadend = function () {
                preview.src = reader.result;
            }

            if (file) {
                reader.readAsDataURL(file);

                hasUpload = true;
            } else {
                preview.src = "";

                hasUpload = false;
            }
        }

        function UploadImage() {
            //$("#btnUpload").click(function (evt) {
            var fileUpload = $("[id*='fileThumbnail']").get(0);
            var files = fileUpload.files;
            var extension = "";
            var data = new FormData();
            for (var i = 0; i < files.length; i++) {
                data.append(files[i].name, files[i]);
                //console.log(files[i].name);
                extension = files[i].name.split('.').pop();
            }

            $.ajax({
                url: "../Common/FileUploadHandler.ashx",
                type: "POST",
                data: data,
                contentType: false,
                processData: false,
                success: function (result) {
                    UpdateNews(extension);
                    //alert(result);
                },
                error: function (err) {
                    //alert(err.statusText);
                }
            });

            //    evt.preventDefault();
            //});
        }

        function CancelCreateNews() {
            window.location = "News.aspx";
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
                            <h3 class="box-title">ข่าวกิจกรรม</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <asp:HiddenField runat="server" ID="hdUserName" />
                            <asp:HiddenField runat="server" ID="hdEditor" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-9">
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Ref No.
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <label id="txtRefNo" class="form-control" runat="server"></label>
                                                    </div>
                                                </div>
                                                <div class="col-xs-3">
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        ชื่อเรื่อง
                                                    </div>
                                                    <div class="col-xs-10">
                                                        <asp:TextBox runat="server" ID="txtNewsName" class="form-control"></asp:TextBox>
                                                    </div>

                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        กลุ่มผู้รับข่าว
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server" id="ddlUserType">
                                                        </select>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        สถานะ
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <asp:RadioButtonList runat="server" ID="rdStatus" RepeatDirection="Horizontal" CellPadding="20" CellSpacing="20">
                                                            <asp:ListItem Text="Active"
                                                                Value="Y"
                                                                Selected="True" />
                                                            <asp:ListItem Text="InActive"
                                                                Value="N" />
                                                        </asp:RadioButtonList>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        วันที่เริ่มต้น
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtStartDate" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        วันที่สิ้นสุด
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtEndDate" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <textarea id="editor1" name="editor1" rows="10" cols="80">
                                                    </textarea>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-3">
                                                    <button type="button" class="btn btn-success" onclick="ConfirmCreateNews()">
                                                        <span class="glyphicon glyphicon-save"></span>บันทึก
                                                   
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelCreateNews()">
                                                        <span class="glyphicon glyphicon-remove"></span>ยกเลิก
                                                   
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-xs-3">
                                            <div class="row">
                                                <div class="col-xs-12">
                                                    <button type="button" class="btn btn-info" onclick="document.getElementById('fileThumbnail').click();">
                                                        <span class="glyphicon glyphicon-folder-open"></span>&nbsp;Browse
                                                    </button>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-12">
                                                    <img id="imgPreview" width="150" height="150" alt="" runat="server"/>
                                                    <input id="fileThumbnail" type="file" onchange="previewFile()" style="display: none;" runat="server" />
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
