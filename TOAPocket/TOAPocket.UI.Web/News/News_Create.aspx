<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="News_Create.aspx.cs" Inherits="TOAPocket.UI.Web.News.News_Create" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/bower_components/ckeditor/ckeditor.js"></script>

    <script type="text/javascript">
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

            InitialRefNo();
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
            }

            if (valid) {
                CreateNews();
            }
        }

        function CreateNews() {
            
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

        function showImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#imagepreview').prop('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
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
                            <h3 class="box-title">ข่าวกิจกรรม</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <asp:HiddenField runat="server" ID="hdUserName" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Ref No.
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <label id="txtRefNo" class="form-control"></label>
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
                                                    <div class="col-xs-6">
                                                        <asp:TextBox runat="server" ID="txtNewsName" class="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type='file' onchange="showImage(this);" /> 
                                                        <img id="imagepreview" src="" alt="your image" /> 
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
