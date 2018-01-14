<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Layout.Master" AutoEventWireup="true" CodeBehind="TransferBarcode_Detail.aspx.cs" Inherits="TOAPocket.UI.Web.Barcode.TransferBarcode_Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {

            InitialDepartment();

            //$('#SuccessBox').on('hidden.bs.modal', function () {
            //    window.location
            //})

            $("#btnCancel").click(function () {
                window.location = "TransferBarcode.aspx";
            });
        });

        function InitialDepartment() {
            var postUrl = "../Common/FetchData.asmx/GetDepartment";
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

        function BindDropdown(response) {
            var data = JSON.parse(response.d);

            var ddl1 = $("[id*='ddlFromDepartment']");

            //ddl1.empty();
            $.each(data, function () {
                ddl1.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            var ddl2 = $("[id*='ddlToDepartment']");

            //ddl2.empty();
            $.each(data, function () {
                ddl2.append($("<option></option>").val(this['DEPT_ID']).html(this['DEPT_NAME']));
                //Default is first value 
            });

            $("[id*='ddlFromDepartment']").val($("[id*='hdFromDept']").val());
            $("[id*='ddlToDepartment']").val($("[id*='hdToDept']").val());

            var fromDept = $("[id*='ddlFromDepartment'] option").filter(function () { return $(this).html() == $("[id*='hdFromDept']").val(); }).val();
            var toDept = $("[id*='ddlToDepartment'] option").filter(function () { return $(this).html() == $("[id*='hdToDept']").val(); }).val();

            $("[id*='ddlFromDepartment']").val(fromDept);
            $("[id*='ddlToDepartment']").val(toDept);
        }

        function CallConfirm() {
            confirmBox("ยืนยันการรับ Barcode ", ConfirmReceiveBarcode);
        }

        function ConfirmReceiveBarcode() {

            //Confirm to receive barcode
            var postUrl = "TransferBarcode.aspx/ConfirmReceiveBarcode";
            $.ajax({
                type: "POST",
                url: postUrl,
                data: '{department: ' + $("[id*='hdDepartment']").val()
                    + ',trNo:"' + $("[id*='txtTranferNo']").text()
                    + '",fromDept:"' + $("[id*='ddlFromDepartment']").val()
                    + '",toDept:"' + $("[id*='ddlToDepartment']").val()
                    + '",barcodeStart:"' + $("[id*='txtBarcodeStart']").val()
                    + '",barcodeEnd:"' + $("[id*='txtBarcodeEnd']").val()
                    + '",dateStart:"' + $("[id*='txtTfDate']").val()
                    + '",dateEnd:"' + ""
                    + '",updateBy:"' + $("[id*='hdUserId']").val()
                    + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (data.length > 0) {
                        if (data[0].result) {
                            successMsg("บันทึกข้อมูลเรียบร้อย");
                        } else {
                            dangerMsg("เกิดข้อผิดพลาด");
                        }
                    }
                },
                failure: function (response) {
                    //alert(response.d);
                    console.log(response.d);
                }
            });
        }

        function RejectReceiveBarcode() {
            if ($("[id*='txtRemark']").val() == "") {
                dangerMsg("กรุณาใส่ Remark!")
            } else {

                var postUrl = "TransferBarcode.aspx/ConfirmRejectBarcode";
                $.ajax({
                    type: "POST",
                    url: postUrl,
                    data: '{trNo: "' + $("[id*='txtTranferNo']").text()
                        + '",remark:"' + $("[id*='txtRemark']").val()
                        + '",updateBy:"' + $("[id*='hdUserId']").val()
                        + '" }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var data = JSON.parse(response.d);
                        if (data.length > 0) {
                            if (data[0].result) {
                                successMsg("บันทึกข้อมูลเรียบร้อย");

                            } else {
                                dangerMsg("เกิดข้อผิดพลาด");
                            }
                        }
                    },
                    failure: function (response) {
                        //alert(response.d);
                        console.log(response.d);
                    }
                });
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
                            <h3 class="box-title">การโอน Barcode</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form role="form" runat="server">
                            <asp:HiddenField runat="server" ID="hdDepartment" />
                            <asp:HiddenField runat="server" ID="hdUserId" />
                            <asp:HiddenField runat="server" ID="hdFromDept" />
                            <asp:HiddenField runat="server" ID="hdToDept" />
                            <asp:HiddenField runat="server" ID="hdUserName" />
                            <asp:HiddenField runat="server" ID="hdDepartmentName" />
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
                                                        <label id="txtTranferNo" class="form-control" runat="server"></label>
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
                                                        <asp:DropDownList CssClass="form-control" runat="server" ID="ddlFromDepartment"></asp:DropDownList>
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
                                                        <asp:DropDownList CssClass="form-control" runat="server" ID="ddlToDepartment"></asp:DropDownList>
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
                                                        <input type="text" id="txtBarcodeStart" class="form-control" runat="server" />
                                                    </div>
                                                    <div class="col-xs-2">
                                                        ถึง
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <input type="text" id="txtBarcodeEnd" class="form-control" runat="server" />
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
                                                        <label id="lbBarcodeQty" class="form-control" runat="server"></label>
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
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-1">
                                                    <div class="col-xs-2">
                                                        สถานะ
                                                   
                                                    </div>
                                                    <div class="col-xs-4">
                                                        <label id="lbStatus" class="form-control" runat="server"></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-9 col-xs-offset-3">
                                                    <button type="button" class="btn btn-success" onclick="CallConfirm()" runat="server" id="btnConfirmReceive">
                                                        <span class="glyphicon glyphicon-save"></span>ยืนยันการรับ
                                                    </button>
                                                    <button type="button" class="btn" id="btnCancel">
                                                        <span class="glyphicon glyphicon-remove"></span>ยกเลิก
                                                    </button>
                                                    <button type="button" class="btn btn-danger" onclick="RejectReceiveBarcode()" runat="server" id="btnRejectReceive">
                                                        <span class="glyphicon glyphicon-remove"></span>ไม่รับ Barcode
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div id="RejectBox" class="modal fade" role="dialog">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                    <h4 class="modal-title"></h4>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="row">
                                                        <div class="col-xs-2">
                                                            <label for="txtRemark">Remark :</label>
                                                        </div>
                                                        <div class="col-xs-10">
                                                            <textarea class="form-control" rows="5" cols="10" id="txtRemark"></textarea>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="RejectReceiveBarcode()">Ok</button>
                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
