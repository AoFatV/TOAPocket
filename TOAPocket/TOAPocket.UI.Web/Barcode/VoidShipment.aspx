<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="VoidShipment.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.VoidShipment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        function ConfirmVoidShipment() {

            confirmBox("คุณต้องการยืนยันการ Matching หรือไม่?", VoidShipment)

            return false;
        }

        function VoidShipment() {

            $("[id*='btnSave']").click();

            return false;
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


        .hiddencol {
            display: none;
        }

        .visiblecol {
            display: block;
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
                            <h3 class="box-title">Void สำหรับการจัดส่ง</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField ID="hdShipId" runat="server" />
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row" runat="server" id="dvShipmentScan">
                                        <div class="col-md-6 col-md-offset-1 col-xs-12 col-xs-offset-0">
                                            <div class="col-xs-4 col-md-5 text-right">
                                                <label for="txtBarcodeScan">ShipmentNo:</label>
                                            </div>
                                            <div class="col-xs-4 col-md-5">
                                                <asp:TextBox runat="server" CssClass="form-control" ID="txtShipmentNo"></asp:TextBox>
                                            </div>
                                            <div class="col-xs-2 col-md-2">
                                                <asp:LinkButton ID="btnSearch"
                                                    runat="server"
                                                    CssClass="btn btn-success"
                                                    OnClick="btnSearch_Click">
                                                        <span class="glyphicon glyphicon-search"></span>
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row" runat="server" id="dvShipment">
                                        <div class="col-xs-12 col-md-12">
                                            <asp:GridView runat="server" AutoGenerateColumns="false" ID="gridShipment" CssClass="table table-striped table-bordered table-hover" AllowPaging="true" PageSize="10" Width="100%"
                                                OnPageIndexChanging="gridShipment_PageIndexChanging" OnRowCommand="gridShipment_RowCommand">
                                                <Columns>
                                                    <asp:BoundField HeaderText="ShipmentId" DataField="ShipId" Visible="false" />
                                                    <asp:TemplateField HeaderText="Scan" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center  visible-xs visible-lg" ItemStyle-CssClass="visible-xs visible-lg">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" ID="btnScan" CssClass="btn btn-success" CommandName="ScanBarcode" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>">
                                                            Scan
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ShipmentNo" HeaderText="ShipmentNo." ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-xs visible-lg" ItemStyle-CssClass="visible-xs visible-lg" />
                                                    <asp:BoundField DataField="BTFS" HeaderText="BTFS" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-lg" ItemStyle-CssClass="visible-lg" />
                                                    <asp:BoundField DataField="VoidQty" HeaderText="VoidQty" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-xs visible-lg" ItemStyle-CssClass="visible-xs visible-lg" />
                                                    <asp:BoundField DataField="ScanQty" HeaderText="ScanQty" ItemStyle-Width="5%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-xs  visible-lg" ItemStyle-CssClass="visible-xs visible-lg" />
                                                    <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-lg" ItemStyle-CssClass="visible-lg" />
                                                    <asp:BoundField DataField="MatDesc" HeaderText="Mat Description" ItemStyle-Width="20%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center  visible-lg" ItemStyle-CssClass="visible-lg" />
                                                    <asp:BoundField DataField="BatchNo" HeaderText="BatchNo" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center visible-lg" ItemStyle-CssClass="visible-lg" />
                                                    <asp:BoundField DataField="CreateDate" HeaderText="CreateDate" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center  visible-lg" ItemStyle-CssClass="visible-lg" />
                                                    <asp:BoundField DataField="Status" HeaderText="สถานะ" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center  visible-lg" ItemStyle-CssClass="visible-lg" />
                                                </Columns>
                                                <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                    <div class="row" runat="server" id="dvScanBarcode">
                                        <div class="col-md-12 col-xs-12">
                                            <div class="row">
                                                <div class="col-md-8 col-md-offset-4 col-xs-10 col-xs-offset-2">
                                                    <div class="col-xs-12 col-md-4">
                                                        <label>Shipment No :</label>
                                                        <label id="lbShipmentNo" runat="server"></label>
                                                    </div>
                                                    <div class="col-xs-12 col-md-4">
                                                        <label>BTFS: </label>
                                                        <label id="lbBtfs" runat="server"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-8 col-md-offset-4 col-xs-11 col-xs-offset-2">
                                                    <div class="col-xs-12 col-md-3">
                                                        <label>จำนวนที่ต้อง Void:</label>
                                                        <label id="lbVoidQty" runat="server"></label>
                                                    </div>
                                                    <div class="col-xs-12 col-md-3" style="color: green;">
                                                        <label>จำนวนที่ Void แล้ว:</label>
                                                        <label id="lbScanQty" runat="server"></label>
                                                    </div>
                                                    <div class="col-xs-12 col-md-3" style="color: blue;">
                                                        <label>Remain Qty: </label>
                                                        <label id="lbRemainQty" runat="server"></label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 col-md-offset-4 col-xs-10 col-xs-offset-1">
                                            <div class="col-xs-5 col-md-4">
                                                <label for="txtBarcodeScan" id="lbBarcode" runat="server">Barcode :</label>
                                            </div>
                                            <div class="col-xs-7 col-md-8">
                                                <asp:TextBox runat="server" CssClass="form-control" ID="txtBarcodeScan" OnTextChanged="txtBarcodeScan_OnTextChanged" AutoPostBack="True"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-6 col-xs-offset-2 col-md-5 col-md-offset-4">
                                            <asp:GridView runat="server" AutoGenerateColumns="false" ID="gridBarcodeScan" CssClass="table table-striped table-bordered table-hover" AllowPaging="true" PageSize="5"
                                                OnPageIndexChanging="gridBarcodeScan_OnPageIndexChanging" OnRowCommand="gridBarcodeScan_OnRowCommand" OnRowDeleting="gridBarcodeScan_OnRowDeleting">
                                                <Columns>
                                                    <asp:BoundField DataField="No" HeaderText="ลำดับ" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:BoundField DataField="Barcode" HeaderText="Barcode" ItemStyle-Width="20%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                    <asp:TemplateField HeaderText="ลบ" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center">
                                                        <ItemTemplate>
                                                            <asp:LinkButton runat="server" ID="btnDelete" CssClass="btn btn-danger" CommandName="DeleteBarcode" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>">
                                                            <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>
                                                            </asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="10%" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center" />
                                                </Columns>
                                                <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-md-offset-4 col-xs-12 col-xs-offset-1">
                                            <div class="col-xs-8 col-md-8  col-md-offset-4  col-xs-offset-2">
                                                <asp:LinkButton ID="btnSaveTmp"
                                                    runat="server"
                                                    CssClass="btn btn-success"
                                                    OnClientClick="return ConfirmVoidShipment()">
                                                        <span class="glyphicon glyphicon-save">ยืนยัน</span>
                                                </asp:LinkButton>
                                                <button type="button" class="btn btn-success" runat="server" id="btnSave" onserverclick="btnSave_ServerClick" style="display: none;">
                                                    <span class="glyphicon glyphicon-save">ยืนยัน</span>
                                                </button>
                                                <button type="button" class="btn" runat="server" id="btnCancel" onserverclick="btnCancel_ServerClick">
                                                    <span class="glyphicon glyphicon-remove">ยกเลิก</span>
                                                </button>
                                                <button type="button" class="btn" runat="server" id="btnBack" onserverclick="btnBack_OnServerClick">
                                                    <span class="glyphicon glyphicon-arrow-left">ย้อนกลับ</span>
                                                </button>
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
