using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class TransferBarcode_Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request.Params["trNo"]))
                {
                    var users = (User)Session["User"];
                    hdUserId.Value = users.UserId;
                    hdDepartment.Value = users.DeptId;

                    SetDataTransfer(hdDepartment.Value, Request.Params["trNo"]);
                }
            }
        }

        private void SetDataTransfer(string department, string trNo)
        {
            try
            {
                DataSet ds = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                ds = blBarcode.GetBarcodeTransfer(department, trNo, "", "", "", "", "", "", "");
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            txtTranferNo.InnerText = dr["TR_NO"].ToString();
                            hdFromDept.Value = dr["TR_FROM"].ToString();
                            hdToDept.Value = dr["TR_TO"].ToString();
                            txtBarcodeStart.Value = dr["BARCODE_FROM"].ToString();
                            txtBarcodeEnd.Value = dr["BARCODE_TO"].ToString();
                            lbBarcodeQty.InnerText = dr["TOTAL_QTY"].ToString();
                            if (!String.IsNullOrEmpty(dr["TR_DATE"].ToString()))
                            {
                                DateTime dt = Convert.ToDateTime(dr["TR_DATE"].ToString());
                                txtTfDate.Value = dt.Day.ToString() + '/' + dt.Month.ToString() + '/' + dt.Year.ToString();
                            }
                            if (!String.IsNullOrEmpty(dr["RECEIVE_DATE"].ToString()))
                            {
                                DateTime dt = Convert.ToDateTime(dr["RECEIVE_DATE"].ToString());
                                txtRcDate.InnerText = dt.Day.ToString() + '/' + dt.Month.ToString() + '/' + dt.Year.ToString();
                            }


                            lbStatus.InnerText = dr["STATUS_NAME"].ToString();


                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}