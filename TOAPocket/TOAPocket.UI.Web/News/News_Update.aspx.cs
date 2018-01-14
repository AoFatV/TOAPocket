using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;
using Image = System.Drawing;

namespace TOAPocket.UI.Web.News
{
    public partial class News_Update : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request.Params["refNo"]))
                {
                    var users = (User)Session["User"];
                    hdUserId.Value = users.UserId;
                    hdUserName.Value = users.UserName;

                    InitialDropdown();
                    InitialRadio();

                    SetDataNews(Request.Params["refNo"]);
                }
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
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void InitialRadio()
        {
            try
            {
                rdStatus.Items.Add(new ListItem("Active", "Y"));
                rdStatus.Items.Add(new ListItem("InActive", "N"));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void SetDataNews(string refNo)
        {
            try
            {
                BLNews blNews = new BLNews();

                DataSet ds = blNews.GetNews("", "", "", "", "", refNo);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            txtRefNo.InnerText = refNo;
                            txtNewsName.Text = dr["SUBJECT"].ToString();
                            ddlUserType.Items.FindByText(dr["USER_TYPE_NAME"].ToString()).Selected = true;

                            rdStatus.SelectedValue = dr["IS_ACTIVE"].ToString();
                            //.Items.FindByValue(dr["STATUS"].ToString()).Selected = true;

                            if (!String.IsNullOrEmpty(dr["DATE_FROM"].ToString()))
                            {
                                DateTime dt = Convert.ToDateTime(dr["DATE_FROM"].ToString());
                                txtStartDate.Value = dt.Day.ToString() + '/' + dt.Month.ToString() + '/' + dt.Year.ToString();
                            }

                            if (!String.IsNullOrEmpty(dr["DATE_TO"].ToString()))
                            {
                                DateTime dt = Convert.ToDateTime(dr["DATE_TO"].ToString());
                                txtEndDate.Value = dt.Day.ToString() + '/' + dt.Month.ToString() + '/' + dt.Year.ToString();
                            }

                            hdEditor.Value = dr["DETAIL"].ToString();

                            if (!String.IsNullOrEmpty(dr["THUMBNAIL"].ToString()))
                            {
                                byte[] bytes = (byte[])dr["THUMBNAIL"];
                                string base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
                                imgPreview.Src = "data:image/jpg;base64," + base64String;
                                hdHasImage.Value = "Y";
                            }
                        }
                    }



                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string UpdateNews(string refNo, string newsName, string newsStartDate, string newsEndDate, string userType, string status, string fileName, string updateBy, string detail)
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

                result = blNews.UpdateNews(refNo, newsName, newsStartDate, newsEndDate, userType, status, data, updateBy, detail);

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