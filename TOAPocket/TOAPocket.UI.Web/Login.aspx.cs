using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;

namespace TOAPocket.UI.Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //if (Session["User"] == null || !User.Identity.IsAuthenticated)
                //{
                //    Response.Redirect("Login.aspx");
                //}
            }
        }

        protected void btnLogin_ServerClick(object sender, EventArgs e)
        {
            BLUser blUser = new BLUser();
            //User users = new User();
            try
            {
                var users = blUser.GetUser(txtUserName.Value);
                if (users.Tables.Count == 0)
                {
                    //Invalid User
                }
                else
                {

                    Session["User"] = users;
                    //FormsAuthentication.SetAuthCookie(txtUserName.Value, false);
                    FormsAuthentication.SetAuthCookie(users.Tables[0].Rows[0]["USER_ID"].ToString(), true);
                    Response.Redirect("Home/Index.aspx");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}