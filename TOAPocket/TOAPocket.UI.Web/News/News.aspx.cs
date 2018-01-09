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

namespace TOAPocket.UI.Web.News
{
    public partial class News : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                InitialDropdown();
            }
        }

        private void InitialDropdown()
        {
            try
            {
                BLUser blUser = new BLUser();
                DataSet ds = new DataSet();
                ds = blUser.GetUserType();
                ddlUserType.DataSource = ds;
                ddlUserType.DataTextField = "USER_TYPE_NAME";
                ddlUserType.DataValueField = "USER_TYPE_ID";
                ddlUserType.DataBind();
                ddlUserType.Items.Insert(0, new ListItem("ALL", ""));

                ddlStatus.Items.Add(new ListItem("ALL", ""));
                ddlStatus.Items.Add(new ListItem("Active", "Y"));
                ddlStatus.Items.Add(new ListItem("InActive", "N"));


            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string GetNews(string newsName, string newsStartDate, string newsEndDate, string userType, string status)
        {

            string result = "";

            try
            {
                BLNews blNews = new BLNews();
                DataSet ds = new DataSet();
                Utility utility = new Utility();

                ds = blNews.GetNews(newsName, newsStartDate, newsEndDate, userType, status);
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