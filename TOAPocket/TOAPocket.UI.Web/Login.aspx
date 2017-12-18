<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TOAPocket.UI.Web.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/message.js"></script>
    <script type="text/javascript">
        var actionResult = "<%=actionResult %>";
        var msgResult = "<%=msg %>";

        $(function () {
            if (msgResult != "") {
                if (actionResult == 'True') {
                    successMsg(msgResult);
                } else {
                    dangerMsg(msgResult);
                }
            }
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-wrapper" style="min-height: 990px; margin-left: 0px;">
        <!-- Main content -->
        <section class="content">
            <div class="row">
                <!-- right column -->
                <div class="col-md-4 col-md-offset-4">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">Login</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form class="form-horizontal" runat="server">
                            <div class="box-body">
                                <div class="form-group">
                                    <label for="txtUserName" class="col-sm-3 col-md-5 control-label">User Name</label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" id="txtUserName" placeholder="" runat="server" required="required" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="txtPassword" class="col-sm-3 col-md-5 control-label">Password</label>
                                    <div class="col-sm-5">
                                        <input type="password" class="form-control" id="txtPassword" placeholder="Password" runat="server" required="required" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-5 col-sm-5">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" id="chkRemember" runat="server" />
                                                Remember me
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <asp:Button runat="server" ID="btnLogin" OnClick="btnLogin_ServerClick" CssClass="btn btn-info pull-right" Text="Log in" />

                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                    <!-- /.box -->
                </div>
                <!--/.col (right) -->
            </div>
            <!-- /.row -->
        </section>
        <!-- /.content -->
    </div>
</asp:Content>

