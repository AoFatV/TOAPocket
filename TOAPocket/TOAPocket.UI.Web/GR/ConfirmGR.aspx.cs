using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;
using System.Data;
using System.Web.Services;

namespace TOAPocket.UI.Web.GR
{
    public partial class ConfirmGR : System.Web.UI.Page
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

                InitialDropdown();
            }
        }

        protected void InitialDropdown()
        {
            try
            {
                DataSet ds = new DataSet();
                BLStatus blStatus = new BLStatus();

                ds = blStatus.GetStatus("");
                ddlStatus.DataSource = ds;
                ddlStatus.DataValueField = "STATUS_ID";
                ddlStatus.DataTextField = "STATUS_NAME";
                ddlStatus.DataBind();

                ddlStatus.Items.Insert(0, new ListItem("ALL", ""));

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string GetProcessOrderGR(string processOrder, string btfs, string status, string grStart, string grEnd)
        {
            BLProcessOrder blPrOrder = new BLProcessOrder();
            DataSet ds = new DataSet();
            Utility utility = new Utility();
            string result = "";
            try
            {
                ds = blPrOrder.GetProcessOrderGR(processOrder, btfs, status, grStart, grEnd);
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {

            }
            return result;
        }

        [WebMethod]
        public static string ConfirmProcessOrderGR(string poId)
        {
            string result = "";
            try
            {
                Utility utility = new Utility();
                bool resultUps = false;
                BLProcessOrder blPrOrder = new BLProcessOrder();
                DataTable dt = new DataTable();

                dt.Columns.Add("result");
                dt.Rows.Add("false");

                resultUps = blPrOrder.UpdProcessOrderGR(poId);
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