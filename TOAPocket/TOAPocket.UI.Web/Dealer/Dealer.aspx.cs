using System;
using System.Data;
using System.Web.Services;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Dealer
{
    public partial class Dealer : System.Web.UI.Page
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
        public static string GetDealer(string search)
        {

            string result = "";

            try
            {
                BLDealer blDealer = new BLDealer();
                DataSet ds = new DataSet();
                Utility utility = new Utility();

                ds = blDealer.GetDealer(search.Trim());
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;

        }
    }
}