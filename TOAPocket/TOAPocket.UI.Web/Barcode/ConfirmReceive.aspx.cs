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

namespace TOAPocket.UI.Web.Barcode
{
    public partial class ConfirmReceive : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetBarcodeByPO(string po)
        {
            BLBarcode blBarcode = new BLBarcode();
            DataSet ds = new DataSet();
            string result = "";
            try
            {
                ds = blBarcode.GetBarcodeByPO(po);
                result = DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {

            }
            return result;
        }

        [WebMethod]
        public static string GetBarcodeByBarcode(string po, string barcodeStart, string barcodeEnd)
        {
            BLBarcode blBarcode = new BLBarcode();
            DataSet ds = new DataSet();
            string result = "";
            try
            {
                ds = blBarcode.GetBarcodeByBarcode(po, barcodeStart, barcodeEnd);
                result = DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {

            }
            return result;
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

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                BLBarcode blBarcode = new BLBarcode();
                string[] hdText = hdChkPO.Value.Split(',');
                bool result = false;
                foreach (string po in hdText)
                {
                    result = blBarcode.UpdateBarcodeByPO(po, "", HttpContext.Current.User.Identity.Name);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnConfirmBarcode_OnClick(object sender, EventArgs e)
        {
            try
            {
                BLBarcode blBarcode = new BLBarcode();
                string[] hdText = hdChkBarcode.Value.Split(',');
                bool result = false;
                foreach (string barcodeId in hdText)
                {
                    result = blBarcode.UpdateBarcodeByBarcode(barcodeId, "", HttpContext.Current.User.Identity.Name);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}