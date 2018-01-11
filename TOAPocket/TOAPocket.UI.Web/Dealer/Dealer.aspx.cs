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

                ds = blDealer.GetDealer(search);
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