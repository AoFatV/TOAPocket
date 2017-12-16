using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] != null)
            {
                Response.Redirect("Home/Index.aspx");
            }

            if (!IsPostBack)
            {
                
            }
        }

        protected void btnLogin_ServerClick(object sender, EventArgs e)
        {
            BLUser blUser = new BLUser();

            try
            {
                DataSet dsUsers = blUser.GetUser(txtUserName.Value);
                if (dsUsers.Tables.Count == 0)
                {
                    //Invalid User
                }
                else
                {
                    //Session["User"] = dsUsers;
                    User users = new User();
                    foreach (DataRow dr in dsUsers.Tables[0].Rows)
                    {
                        users.UserId = dr["USER_ID"].ToString();
                        users.UserName = dr["USER_NAME"].ToString();
                        users.DeptId = dr["DEPT_ID"].ToString();
                        users.Email = dr["EMAIL"].ToString();
                    }

                    Session["User"] = users;

                    //FormsAuthentication.SetAuthCookie(dsUsers.Tables[0].Rows[0]["USER_ID"].ToString(), true);
                    Response.Redirect(!String.IsNullOrEmpty(Request.Params["ReturnUrl"])
                        ? Request.Params["ReturnUrl"]
                        : "Home/Index.aspx");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}