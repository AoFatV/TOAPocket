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

namespace TOAPocket.UI.Web.News
{
    public partial class News_Create : System.Web.UI.Page
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

        [WebMethod]
        public static string GetRefRunningNo()
        {
            DataSet ds = new DataSet();
            BLNews blNews = new BLNews();
            string result = "";
            Utility utility = new Utility();
            try
            {
                ds = blNews.GetRefRunningNo();
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return result;
        }

        [WebMethod]
        public static string CreateNews()
        {
            try
            {

            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return "";

        }
    }
}