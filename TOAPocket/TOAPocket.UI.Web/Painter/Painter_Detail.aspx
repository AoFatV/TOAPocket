<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="Painter_Detail.aspx.cs" Inherits="TOAPocket.UI.Web.Painter.Painter_Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        $(function () {

            $('#SuccessBox').on('hidden.bs.modal', function () {
                window.location = "Painter.aspx";
            });
        });


        function UpdateDealer() {

            var postUrl = "Painter_Detail.aspx/UpdatePainter";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{dealerId: "' + $("[id*='hdDealer']").val()
                    + '",maxReceive:"' + $("[id*='txtMaxReceive']").val()
                    + '",updateBy:"' + $("[id*='hdUserName']").val()
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
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }


        function CancelUpdateDealer() {
            window.location = "Painter.aspx";
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
                            <h3 class="box-title">ข้อมูล Painter</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <asp:HiddenField runat="server" ID="hdUserName" />
                            <asp:HiddenField runat="server" ID="hdDealer" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3 text-right">
                                                        Painter No
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <label id="lbPainterNo" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        ชื่อ
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:TextBox ID="txtName" runat="server" class="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        นามสกุล
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:TextBox ID="txtSurname" runat="server" class="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        Mobile No
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:TextBox ID="txtMobileNo" runat="server" class="form-control"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        เขตพื้นที่
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:DropDownList runat="server" ID="ddlArea" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 119px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        ที่อยู่
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <asp:TextBox ID="txtAddress" runat="server" class="form-control" Rows="5" TextMode="MultiLine"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        อาชีพ
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:DropDownList runat="server" ID="ddlJob" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 39px;">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        รายได้ต่อเดือน
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <asp:DropDownList runat="server" ID="ddlIncome" CssClass="form-control"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-1">
                                                    <div class="col-xs-3  text-right">
                                                        Status
                                                    </div>
                                                    <div class="col-xs-3">
                                                        <label id="lbStatus" runat="server">
                                                        </label>
                                                        <% if (lbStatus.InnerText.Equals(""))
                                                            { %>
                                                        <button type="button" class="btn btn-success btn-circle"><span class="glyphicon glyphicon-ok"></span></button>
                                                        <% }
                                                            else
                                                            { %>
                                                        <button type="button" class="btn btn-danger btn-circle"><span class="glyphicon glyphicon-remove"></span></button>
                                                        <% } %>
                                                    </div>
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
