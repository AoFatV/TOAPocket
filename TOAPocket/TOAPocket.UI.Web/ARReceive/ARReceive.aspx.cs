using System;
using System.Data;
using System.Web.Services;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.ARReceive
{
    public partial class ARReceive : System.Web.UI.Page
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
                hdUserName.Value = users.UserName;
                hdDepartmentName.Value = users.DeptName;
            }
        }

        [WebMethod]
        public static string GetSaleRedeem(string search)
        {

            string result = "";

            try
            {
                BLArWhReceive blArWhReceive = new BLArWhReceive();
                DataSet ds = new DataSet();
                Utility utility = new Utility();

                ds = blArWhReceive.GetSaleRedeem(search.Trim());
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;

        }

        [WebMethod]
        public static string InsertWhRedeemQty(string saleId, string saleReturn20Qty, string whReturn20Qty, string saleReturn30Qty, string whReturn30Qty, string saleReturn60Qty, string whReturn60Qty, string totalLostReturnQty, string createBy)
        {
            string result = "";
            try
            {
                Utility utility = new Utility();
                bool resultUps = false;
                BLArWhReceive blArWhReceive = new BLArWhReceive();
                DataTable dt = new DataTable();

                dt.Columns.Add("result");
                dt.Rows.Add("false");

                resultUps = blArWhReceive.InsertWhRedeemQty(saleId, saleReturn20Qty, whReturn20Qty, saleReturn30Qty, whReturn30Qty, saleReturn60Qty, whReturn60Qty, totalLostReturnQty, createBy);
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