<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="TransferBarcode_Create.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.TransferBarcode_Create" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

        $(function () {
            InitialTrNo();
            InitialDepartment();

            //$("#btnCloseSuccess").click(function () {
            //    window.location = "TransferBarcode.aspx";
            //});

            $('#SuccessBox').on('hidden.bs.modal', function () {
                window.location = "TransferBarcode.aspx";
            });

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!

            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd;
            }
            if (mm < 10) {
                mm = '0' + mm;
            }

            today = dd + '/' + mm + '/' + yyyy;

            $("[id*='txtTfDate']").val(today);
        });

        function InitialTrNo() {
            $("[id*='txtTranferNo']").val('');
            var postUrl = "TransferBarcode_Create.aspx/GetTrRunningNo";
            $.ajax({
                type: "POST",
                url: postUrl,
                //data: '{condition: 1 }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindTrNo,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }


        function InitialDepartment() {
            var postUrl = "TransferBarcode_Create.aspx/GetDepartment";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{condition: 1 }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: BindDropdown,
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function BindTrNo(response) {
            var data = JSON.parse(response.d);
            if (data.length > 0) {
                $("[id*='txtTranferNo']").text(data[0].Running);
            }
        }

        function BindDropdown(response) {
            var data = JSON.parse(response.d);

            var ddl1 = $("[id*='ddlFromDepartment']");

            ddl1.empty();
            $.each(data, function () {
                ddl1.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            var ddl2 = $("[id*='ddlToDepartment']");

            ddl2.empty();
            $.each(data, function () {
                ddl2.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });
        }

        function CalBarcodeQty() {
            $("[id*='lbBarcodeQty']").text('');

            if ($("[id*='txtBarcodeStart']").val() != "" && $("[id*='txtBarcodeEnd']").val() != "") {
                var bcStart = $("[id*='txtBarcodeStart']").val().replace(/[^\d.]/g, '');;
                var bcEnd = $("[id*='txtBarcodeEnd']").val().replace(/[^\d.]/g, '');;


                var qty = parseInt(bcEnd) - parseInt(bcStart) + 1;

                $("[id*='lbBarcodeQty']").text(qty);
            }
        }

        function ConfirmCreateTransfer() {
            var postUrl = "TransferBarcode_Create.aspx/ConfirmCreateTransfer";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{trNo: "' + $("[id*='txtTranferNo']").text() + '" ,fromDept: "' + $("[id*='ddlFromDepartment'] option:selected").text() +
                    '" ,toDept: "' + $("[id*='ddlToDepartment'] option:selected").text() + '" ,startBar: "' + $("[id*='txtBarcodeStart']").val() +
                    '" ,endBar: "' + $("[id*='txtBarcodeEnd']").val() + '" ,qty: "' + $("[id*='lbBarcodeQty']").text() +
                    '" ,transDate: "' + $("[id*='txtTfDate']").val() +
                    '" ,createBy: "' + $("[id*='hdUserName']").val() +
                    '"}',
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
                            <h3 class="box-title">การโอน Barcode</h3>
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
                                                        Tranfer No.
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <label id="txtTranferNo" class="form-control"></label>
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
                                                        <select class="form-control" runat="server" id="ddlFromDepartment">
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        แผนกที่รับ
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <select class="form-control" runat="server" id="ddlToDepartment">
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
                                                        <input type="text" id="txtBarcodeStart" class="form-control" onchange="CalBarcodeQty()" />
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeEnd" class="form-control" onchange="CalBarcodeQty()" />
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        จำนวน
                                                   
                                                    </div>
                                                    <div class="col-xs-2">
                                                        <label id="lbBarcodeQty" class="form-control"></label>
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
                                                            <input type="text" class="form-control pull-left" id="txtTfDate" runat="server" readonly="readonly" />
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
                                                    <div class="col-xs-2">
                                                        วันที่รับ
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <label class="form-control pull-left" id="txtRcDate" runat="server"></label>
                                                        <%--<div class="input-group date">
                                                            <input type="text" class="form-control pull-left" id="txtRcDate" runat="server" />
                                                            <div class="input-group-addon">
                                                                <i class="fa fa-calendar"></i>
                                                            </div>
                                                        </div>--%>
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        สถานะ
                                                   
                                                    </div>
                                                    <div class="col-xs-1">
                                                        <label id="lbStatus" class="form-control">-</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-3">
                                                    <button type="button" class="btn btn-info" onclick="ConfirmCreateTransfer()">
                                                        <span class="glyphicon glyphicon-save"></span>ยืนยันการโอน
                                                   
                                                    </button>
                                                    <button type="button" class="btn" onclick="CancelCreateTransfer()">
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
