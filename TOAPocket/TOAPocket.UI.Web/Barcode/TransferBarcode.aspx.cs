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
        public static string GetBarcodeTransfer(string department, string trNo, string fromDept, string toDept, string barcodeStart, string barcodeEnd, string dateStart, string dateEnd, string status)
        {
            string result = "";
            try
            {
                DataSet ds = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                Utility utility = new Utility();
                ds = blBarcode.GetBarcodeTransfer(department, trNo, fromDept, toDept, barcodeStart, barcodeEnd, dateStart, dateEnd, status);
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
                    dsBarTr = blBarcode.GetBarcodeTransfer(department, trNo, fromDept, toDept, barcodeStart, barcodeEnd, dateStart, dateEnd, "20");

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

                DataTable dt = new DataTable();

                dt.Columns.Add("result");
                dt.Rows.Add("false");
                if (resultUps)
                    dt.Rows[0]["result"] = "true";

                result = utility.DataTableToJSONWithJavaScriptSerializer(dt);

            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }

        [WebMethod]
        public static string ConfirmRejectBarcode(string trNo, string updateBy, string remark)
        {
            string result = "";
            try
            {
                Utility utility = new Utility();
                bool resultUps = false;
                BLBarcode blBarcode = new BLBarcode();
                DataTable dt = new DataTable();

                dt.Columns.Add("result");
                dt.Rows.Add("false");

                resultUps = blBarcode.UpdateBarcodeTransfer(trNo, updateBy, "22", remark);
                if (resultUps)
                    dt.Rows[0]["result"] = "true";

                result = utility.DataTableToJSONWithJavaScriptSerializer(dt);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }
    }
}