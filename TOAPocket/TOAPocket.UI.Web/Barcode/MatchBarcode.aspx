<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="MatchBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.MatchBarcode" %>

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

            //$('#SuccessBox').on('hidden.bs.modal', function () {
            //    window.location = "MatchBarcode.aspx";
            //});


            $("[id*='txtBarcodeStart']").change(function () {
                CalBarcodeQty();
            });

            $("[id*='txtBarcodeEnd']").change(function () {
                CalBarcodeQty();
            });
        });

        function CalBarcodeQty() {
            $("[id*='lbTotalBarcode']").text('');

            if ($("[id*='txtBarcodeStart']").val() != "" && $("[id*='txtBarcodeEnd']").val() != "") {
                var bcStart = $("[id*='txtBarcodeStart']").val().replace(/[^\d.]/g, '');;
                var bcEnd = $("[id*='txtBarcodeEnd']").val().replace(/[^\d.]/g, '');;


                var qty = parseInt(bcEnd) - parseInt(bcStart) + 1;

                $("[id*='lbTotalBarcode']").text(qty);
            }
        }

        function ConfirmMatching() {

            confirmBox("คุณต้องการยืนยันการ Matching หรือไม่?", MatchBarcode)

            return false;
        }

        function MatchBarcode() {

            $("[id*='btnSave1']").click();

            return false;
        }

        function ConfirmMatching2() {

            var valid = true;

            if ($("[id*='txtProcessOrder']").val() == "") {
                dangerMsg("กรุณาใส่ ProcessOrder !");
                valid = false;
            } else if ($("[id*='txtBarcodeStart']").val() == "") {
                dangerMsg("กรุณาใส่ Barcode เริ่มต้น !");
                valid = false;
            } else if ($("[id*='txtBarcodeEnd']").val() == "") {
                dangerMsg("กรุณาใส่ Barcode สิ้นสุด !");
                valid = false;
            }

            if (valid) {
                confirmBox("คุณต้องการยืนยันการ Matching หรือไม่?", MatchBarcode2)
            }

            return false;
        }

        function MatchBarcode2() {

            $("[id*='btnSave2']").click();

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
                            <h3 class="box-title">Match Barcode</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdProcessOrderValid" Value="N" />
                            <div class="box-body">
                                <div class="form-group" id="dvProcessOrder" runat="server">
                                    <div class="col-md-12 col-xs-12">
                                        <div class="row">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5 text-right">
                                                    <label for="txtTypeScan">Type</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:RadioButtonList runat="server" ID="rdoType" RepeatDirection="Horizontal" CellPadding="20" CellSpacing="20"
                                                        OnSelectedIndexChanged="rdoType_SelectedIndexChanged" AutoPostBack="true">
                                                        <asp:ListItem Text="Scan" Value="1" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Text="ระบุเป็นตัวเลข" Value="2"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height: 39px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5  text-right">
                                                    <label for="txtProcessOrder">ProcessOrder</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtProcessOrder" AutoPostBack="True" OnTextChanged="txtProcessOrder_TextChanged"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height: 39px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5  text-right">
                                                    <label for="txtBtfs">BTFS</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtBtfs" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height: 39px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5  text-right">
                                                    <label for="txtProcessOrder">Material</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtMaterial" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height: 39px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5  text-right">
                                                    <label for="txtMatDesc">Material Description</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtMatDesc" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <%--style="height: 45px;"--%>
                                        <div class="row" style="height: 45px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5  text-right">
                                                    <label for="txtOrderQty">Order Qty</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtOrderQty" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height: 41px;">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12">
                                                <div class="col-xs-4 col-md-5 text-right">
                                                    <label for="txtCoinType">ประเภทเหรียญ</label>
                                                </div>
                                                <div class="col-xs-8 col-md-7">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtCoinType" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-5 col-xs-offset-4">
                                            </div>
                                        </div>
                                        <div class="row" runat="server" id="dvButton">
                                            <div class="col-md-4 col-md-offset-4 col-xs-10 col-xs-offset-2">
                                                <div class="col-xs-12 col-md-8  col-md-offset-4  col-xs-offset-1">
                                                    <button type="button" class="btn btn-success" runat="server" id="btnScan" onserverclick="btnScan_ServerClick">
                                                        <span class="glyphicon glyphicon-save">Scan</span>
                                                    </button>
                                                    <button type="button" class="btn" runat="server" id="btnCancelProcessOrder" onserverclick="btnCancelProcessOrder_ServerClick">
                                                        <span class="glyphicon glyphicon-remove">Cancel</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="dvScanBarcode" runat="server">
                                    <div class="col-md-12 col-xs-12">
                                        <div class="row">
                                            <div class="col-md-8 col-md-offset-4 col-xs-10 col-xs-offset-2">
                                                <div class="col-xs-12 col-md-4">
                                                    <label>ProcessOrder  :</label>
                                                    <label id="lbPrOrder" runat="server"></label>
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
                                                    <label>Order Qty  :</label>
                                                    <label id="lbOrderQty" runat="server"></label>
                                                </div>
                                                <div class="col-xs-12 col-md-3" style="color: green;">
                                                    <label>Match Qty: </label>
                                                    <label id="lbMatchQty" runat="server"></label>
                                                </div>
                                                <div class="col-xs-12 col-md-3" style="color: blue;">
                                                    <label>Remain Qty: </label>
                                                    <label id="lbRemainQty" runat="server"></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4 col-md-offset-4 col-xs-12 col-xs-offset-1">
                                                <div class="col-xs-5 col-md-4">
                                                    <label for="txtBarcodeScan" id="lbBarcodeScan" runat="server">Barcode :</label>
                                                </div>
                                                <div class="col-xs-6 col-md-8">
                                                    <asp:TextBox runat="server" CssClass="form-control" ID="txtBarcodeScan" OnTextChanged="txtBarcodeScan_OnTextChanged" AutoPostBack="True"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <br />
                                        <div class="row">
                                            <div class="col-xs-5 col-xs-offset-2 col-md-5 col-md-offset-4">
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
                                            <div class="col-md-4 col-md-offset-4 col-xs-10 col-xs-offset-1">
                                                <div class="col-xs-10 col-md-8  col-md-offset-4  col-xs-offset-2">
                                                    <asp:LinkButton ID="btnSaveTemp"
                                                        runat="server"
                                                        CssClass="btn btn-success"
                                                        OnClientClick="return ConfirmMatching()">
                                                        <span class="glyphicon glyphicon-save">ยืนยัน</span>
                                                    </asp:LinkButton>
                                                    <button type="button" class="btn" runat="server" id="btnSave1" onserverclick="btnSave_ServerClick" style="display: none;">
                                                    </button>
                                                    <button type="button" class="btn" runat="server" id="btnCancelScanBarcode" onserverclick="btnCancelScanBarcode_ServerClick">
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
                                <div class="form-group" id="dvRangesBarcode" runat="server">
                                    <div class="row">
                                        <div class="col-md-8 col-md-offset-3 col-xs-12">
                                            <div class="col-xs-5 col-md-3">
                                                <label>Barcode เริ่มต้น</label>
                                            </div>
                                            <div class="col-xs-7 col-md-3">
                                                <%--<input type="number" id="txtBarcodeStart" runat="server" class="form-control" />--%>
                                                <asp:TextBox runat="server" ID="txtBarcodeStart" CssClass="form-control"> </asp:TextBox>
                                            </div>
                                            <div class="col-xs-5 col-md-1">
                                                <label>ถึง</label>
                                            </div>
                                            <div class="col-xs-7 col-md-3">
                                                <%--<input type="number" id="txtBarcodeEnd" runat="server" class="form-control" />--%>
                                                <asp:TextBox runat="server" ID="txtBarcodeEnd" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-8 col-md-offset-3 col-xs-12">
                                            <div class="col-xs-5 col-md-3">
                                                <label>ช่วงที่กำหนด</label>
                                            </div>
                                            <div class="col-xs-7 col-md-3">
                                                <asp:Label ID="lbTotalBarcode" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-4 col-md-offset-4 col-xs-10 col-xs-offset-1">
                                            <div class="col-xs-10 col-md-8  col-md-offset-4  col-xs-offset-2">
                                                <asp:LinkButton ID="btnSaveTmp2"
                                                    runat="server"
                                                    CssClass="btn btn-success"
                                                    OnClientClick="return ConfirmMatching2()">
                                                        <span class="glyphicon glyphicon-save">ยืนยัน</span>
                                                </asp:LinkButton>
                                                <button type="button" class="btn" runat="server" id="btnSave2" onserverclick="btnSave2_ServerClick" style="display: none;">
                                                </button>
                                                <button type="button" class="btn" runat="server" id="btnCancel2" onserverclick="btnCancelScanBarcode_ServerClick">
                                                    <span class="glyphicon glyphicon-remove">ยกเลิก</span>
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
