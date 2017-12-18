using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class TranferBarcode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                var users = (User)Session["User"];
                hdUserId.Value = users.UserId;
                hdDepartment.Value = users.DeptId;
            }
        }

        [WebMethod]
        public static string GetBarcodeTransfer(string department, string trNo, string fromDept, string toDept, string barcodeStart, string barcodeEnd, string dateStart, string dateEnd)
        {
            string result = "";
            try
            {
                DataSet ds = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                Utility utility = new Utility();
                ds = blBarcode.GetBarcodeTransfer(department, trNo, fromDept, toDept, barcodeStart, barcodeEnd, dateStart, dateEnd);
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }

        [WebMethod]
        public static string ConfirmReceiveBarcode(string department, string trNo, string fromDept, string toDept, string barcodeStart, string barcodeEnd, string dateStart, string dateEnd, string updateBy)
        {
            string result = "";
            try
            {
                DataSet dsBarTr = new DataSet();
                DataSet dsBarSt = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                Utility utility = new Utility();
                bool resultUps = false;
                //Get Transfer Barcode from TRNo
                if (!String.IsNullOrEmpty(trNo))
                {
                    dsBarTr = blBarcode.GetBarcodeTransfer(department, trNo, fromDept, toDept, barcodeStart, barcodeEnd, dateStart, dateEnd);

                    //Update [QR_STOCK_BARCODE] set ststus = 2
                    if (dsBarTr.Tables.Count > 0)
                    {
                        if (dsBarTr.Tables[0].Rows.Count > 0)
                        {
                            dsBarSt = blBarcode.GetBarcodeByBarcode("",
                                dsBarTr.Tables[0].Rows[0]["BARCODE_FROM"].ToString(),
                                dsBarTr.Tables[0].Rows[0]["BARCODE_TO"].ToString());

                            if (dsBarSt.Tables.Count > 0)
                            {
                                foreach (DataRow dr in dsBarSt.Tables[0].Rows)
                                {
                                    resultUps = blBarcode.UpdateBarcodeByBarcode(dr["Barcode"].ToString(), department,
                                        updateBy);
                                }
                            }
                        }
                    }
                }
                //21 = receive
                if (resultUps)
                    resultUps = blBarcode.UpdateBarcodeTransfer(trNo, updateBy, "21", "");


                result = utility.DataTableToJSONWithJavaScriptSerializer(dsBarSt.Tables[0]);

            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }
    }
}