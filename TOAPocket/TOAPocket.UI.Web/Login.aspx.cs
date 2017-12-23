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
        public string msg;
        public bool actionResult = false;
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
                DataSet dsUsers = blUser.GetUser(txtUserName.Value, txtPassword.Value);
                if (dsUsers.Tables.Count > 0)
                {
                    if (dsUsers.Tables[0].Rows.Count == 0)
                    {
                        //Invalid User
                        msg = "Username หรือ Password ผิดพลาด กรุณา Login ใหม่";
                    }
                    else
                    {
                        actionResult = true;
                        User users = new User();

                        users.UserId = dsUsers.Tables[0].Rows[0]["USER_ID"].ToString();
                        //users.UserName = dsUsers.Tables[0].Rows[0]["USER_NAME"].ToString();
                        users.UserName = dsUsers.Tables[0].Rows[0]["CUSTOMER_DESCRIPTION"].ToString();
                        users.DeptId = dsUsers.Tables[0].Rows[0]["DEPT_ID"].ToString();
                        users.Email = dsUsers.Tables[0].Rows[0]["EMAIL"].ToString();
                        users.DeptName = dsUsers.Tables[0].Rows[0]["DEPT_NAME"].ToString();
                        users.RoleMenus = new List<string>();
                        foreach (DataRow dr in dsUsers.Tables[0].Rows)
                        {
                            users.RoleMenus.Add(dr["MENU_ID"].ToString());
                        }

                        Session["User"] = users;

                        Response.Redirect("Home/Index.aspx");
                    }
                }
                else
                {
                    msg = "Username หรือ Password ผิดพลาด กรุณา Login ใหม่";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}