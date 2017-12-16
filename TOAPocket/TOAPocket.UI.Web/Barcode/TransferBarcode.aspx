<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="TransferBarcode.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.TranferBarcode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        $(function () {
            $("[id*='txtTfDateStart']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });

            $("[id*='txtTfDateEnd']").datepicker({
                autoclose: true,
                format: 'dd/mm/yyyy'
            });


            InitialTb_1();
        });

        function InitialTb_1() {

        }

        function CreateTransferBarcode() {
            window.location = "TransferBarcode_Create.aspx";
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
                            <h3 class="box-title">โอนย้าย Barcode</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Tranfer No.
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtTranferNo" class="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        แผนกที่โอน
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server">
                                                        </select>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        แผนกที่รับ
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server">
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        Barcode เริ่มต้น
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeStart" class="form-control"  />
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeEnd" class="form-control" />
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        วันที่โอน
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtTfDateStart" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtTfDateEnd" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12 col-xs-offset-6">
                                            <div class="col-xs-1">
                                                <button type="button" class="btn btn-info" onclick="SearchByPO()">
                                                    <span class="glyphicon glyphicon-search"></span> ค้นหา
                                                </button>
                                            </div>
                                            <div class="col-xs-1">
                                                <button type="button" class="btn" onclick="SearchByPO()">
                                                    <span class="glyphicon glyphicon-remove"></span> ยกเลิก
                                                </button>
                                            </div>
                                            <div class="col-xs-1">
                                                <button type="button" class="btn btn-success" onclick="CreateTransferBarcode()">
                                                    <span class="glyphicon glyphicon-transfer"></span> สร้างรายการโอน
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="nav-tabs-custom">
                                                <ul class="nav nav-tabs">
                                                    <li class="active"><a href="#tab_1" data-toggle="tab" onclick="Opentab(1);">รายการค้างรับ</a></li>
                                                    <li><a href="#tab_2" data-toggle="tab" onclick="Opentab(2);">ประวัติการโอน</a></li>
                                                    <li><a href="#tab_3" data-toggle="tab" onclick="Opentab(3);">ประวัติการรับโอน</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div class="tab-pane active" id="tab_1">
                                                        <div class="row">
                                                            <div class="col-xs-12">
                                                                <table id="tbUnReceive" class="table table-bordered table-striped" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Transfer No.</th>
                                                                            <th>วันที่โอน</th>
                                                                            <th>วันที่รับ</th>
                                                                            <th>แผนกที่โอน</th>
                                                                            <th>แผนกที่รับ</th>
                                                                            <th>Qty.</th>
                                                                            <th>ช่วง Barcode</th>
                                                                            <th>สถานะ</th>
                                                                            <th>ยืนยันการรับ</th>
                                                                            <th>ปฏิเสธการรับ</th>
                                                                        </tr>
                                                                    </thead>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="tab-pane" id="tab_2">
                                                    </div>
                                                    <div class="tab-pane" id="tab_3">
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
