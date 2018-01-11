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
                hdUserName.Value = users.UserName;

                InitialDropdown();
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
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string CreateNews(string refNo, string newsName, string newsStartDate, string newsEndDate, string userType, string status, string fileName, string createBy, string detail)
        {
            string str = "";
            try
            {
                BLNews blNews = new BLNews();
                bool result = false;
                DataTable dt = new DataTable();

                Utility utility = new Utility();
                byte[] data = null;
                if (!String.IsNullOrEmpty(fileName))
                {
                    string filePath =
                        System.Web.Hosting.HostingEnvironment.MapPath(
                            "~/Uploads/Thumbnail/" + fileName);
                    data = System.IO.File.ReadAllBytes(filePath);
                }

                result = blNews.InsertNews(refNo, newsName, newsStartDate, newsEndDate, userType, status, data, createBy, detail);

                dt.Columns.Add("result");
                dt.Rows.Add("false");

                if (result)
                    dt.Rows[0]["result"] = "true";

                str = utility.DataTableToJSONWithJavaScriptSerializer(dt);
            }
            catch (Exception ex)
            {
                //throw ex;
            }

            return str;

        }
    }
}