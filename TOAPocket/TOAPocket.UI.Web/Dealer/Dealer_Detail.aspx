<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="Dealer_Detail.aspx.cs" Inherits="TOAPocket.UI.Web.Dealer.Dealer_Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        $(function () {

            $('#SuccessBox').on('hidden.bs.modal', function () {
                window.location = "Dealer.aspx";
            });
        });


        function UpdateDealer() {

            var postUrl = "Dealer_Detail.aspx/UpdateDealer";
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
            window.location = "Dealer.aspx";
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
                            <h3 class="box-title">ข้อมูล Dealer</h3>
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
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        Dealer ID
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbDealerId" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ชื่อร้าน
                                                    </div>
                                                    <div class="col-xs-7 col-md-4">
                                                        <label id="lbDealerName" runat="server" class="form-control"></label>
                                                    </div>
                                                    <div class="col-xs-5 col-md-2 text-right">
                                                        Vendor Code
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbVendorCode" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        รหัสบัตรประชาชน (Text No.1)
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbTextNo1" runat="server" class="form-control"></label>
                                                    </div>
                                                    <div class="col-md-1 col-xs-12">
                                                    </div>
                                                    <div class="col-xs-5 col-md-2 text-right">
                                                        สาขา (Text No.4)
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbTextNo4" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        เลขประจำตัวผู้เสียภาษี (Text No.3)
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbTextNo3" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ชื่อ Sale Team A
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbSaleA" runat="server" class="form-control"></label>
                                                    </div>
                                                    <div class="col-md-1 col-xs-12">
                                                    </div>
                                                    <div class="col-xs-5 col-md-2 text-right">
                                                        ชื่อ Sale Team TK
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbSaleTK" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ชื่อ Sale Team B
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbSaleB" runat="server" class="form-control"></label>
                                                    </div>
                                                    <div class="col-md-1 col-xs-12">
                                                    </div>
                                                    <div class="col-xs-5 col-md-2 text-right">
                                                        รับได้สูงสุด
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <%--<asp:TextBox ID="txtMaxReceive" runat="server" class="form-control"></asp:TextBox>--%>
                                                        <input type="number" runat="server" id="txtMaxReceive" class="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ชื่อบุัญชี
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbAccountName" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ธนาคาร
                                                    </div>
                                                    <div class="col-xs-7 col-md-4">
                                                        <label id="lbBank" runat="server" class="form-control"></label>
                                                        <%--<asp:DropDownList ID="ddlBank" runat="server" class="form-control"></asp:DropDownList>--%>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        สาขา
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbBranch" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        เลขที่บัญชี
                                                    </div>
                                                    <div class="col-xs-7 col-md-3">
                                                        <label id="lbAccountNumber" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        ที่อยู่
                                                    </div>
                                                    <div class="col-xs-7 col-md-4">
                                                        <asp:TextBox ID="txtAddress" runat="server" class="form-control" Rows="5" TextMode="MultiLine"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        Mobile
                                                    </div>
                                                    <div class="col-xs-7 col-md-4">
                                                        <label id="lbMobile" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-offset-0 col-md-offset-1">
                                                    <div class="col-xs-5 col-md-3 text-right">
                                                        E-Mail
                                                    </div>
                                                    <div class="col-xs-7 col-md-4">
                                                        <label id="lbEmail" runat="server" class="form-control"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 text-center">
                                                    <button type="button" class="btn btn-success" onclick="UpdateDealer()">
                                                        <span class="glyphicon glyphicon-save"></span>บันทึก
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelUpdateDealer()">
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
