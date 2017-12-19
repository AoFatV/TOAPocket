using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class TransferBarcode_Create : System.Web.UI.Page
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
            }
        }

        public static string DataTableToJSONWithJavaScriptSerializer(DataTable table)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
            Dictionary<string, object> childRow;
            foreach (DataRow row in table.Rows)
            {
                childRow = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    childRow.Add(col.ColumnName, row[col]);
                }
                parentRow.Add(childRow);
            }
            return jsSerializer.Serialize(parentRow);
        }

        [WebMethod]
        public static string GetDepartment(string condition)
        {
            DataSet ds = new DataSet();
            BLDepartment blDepartment = new BLDepartment();
            string result = "";
            Utility utility = new Utility();
            try
            {
                ds = blDepartment.GetDepartment(condition == "1" ? "DEPT_STATUS = 'T'" : "");
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }

        [WebMethod]
        public static string GetTrRunningNo()
        {
            DataSet ds = new DataSet();
            BLBarcode blBarcode = new BLBarcode();
            string result = "";
            Utility utility = new Utility();
            try
            {
                ds = blBarcode.GetTrRunningNo();
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }

        [WebMethod]
        public static string ConfirmCreateTransfer(string trNo, string fromDept, string toDept, string startBar, string endBar, string qty, string transDate, string createBy)
        {
            BLBarcode blBarcode = new BLBarcode();
            bool result = false;
            DataTable dt = new DataTable();
            string str = "";
            try
            {
                result = blBarcode.InsertBarcodeTransfer(trNo, fromDept, toDept, startBar, endBar, qty, transDate,
                    createBy);

                dt.Columns.Add("result");
                dt.Rows.Add("false");

                if (result)
                    dt.Rows[0]["result"] = "true";

                str = DataTableToJSONWithJavaScriptSerializer(dt);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return str;
        }
    }
}