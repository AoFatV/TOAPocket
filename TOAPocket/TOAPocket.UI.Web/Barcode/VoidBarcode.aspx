<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="VoidBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.VoidBarcode" %>

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
                            <h3 class="box-title">Void Barcode ชำรุด</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-4 col-md-offset-4 col-xs-8 col-xs-offset-3">
                                            <div class="col-xs-3 col-md-4">
                                                <label for="txtBarcodeScan">Barcode :</label>
                                            </div>
                                            <div class="col-xs-5 col-md-8">
                                                <asp:TextBox runat="server" CssClass="form-control" ID="txtBarcodeScan" OnTextChanged="txtBarcodeScan_OnTextChanged" AutoPostBack="True"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-xs-5 col-xs-offset-4">
                                            <asp:GridView runat="server" AutoGenerateColumns="false" ID="gridBarcodeScan" CssClass="table table-striped table-bordered table-hover" AllowPaging="true" PageSize="3"
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
                                        <div class="col-md-4 col-md-offset-4 col-xs-8 col-xs-offset-3">
                                            <div class="col-xs-5 col-md-8  col-md-offset-4  col-xs-offset-3">
                                                <button type="button" class="btn btn-success" runat="server" id="btnSave" OnServerClick="btnSave_ServerClick">
                                                    <span class="glyphicon glyphicon-save">ยืนยัน</span>
                                                </button>
                                                <button type="button" class="btn" runat="server" id="btnCancel" OnServerClick="btnCancel_ServerClick">
                                                    <span class="glyphicon glyphicon-remove">ยกเลิก</span>
                                                </button>
                                                <button type="button" class="btn" runat="server" id="btnBack" OnServerClick="btnBack_OnServerClick">
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
