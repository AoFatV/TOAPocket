﻿using System;
using System.Data;
using System.Web.Services;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Painter
{
    public partial class Painter : System.Web.UI.Page
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
        public static string GetPainter(string search)
        {

            string result = "";

            try
            {
                BLPainter blPainter = new BLPainter();
                DataSet ds = new DataSet();
                Utility utility = new Utility();

                ds = blPainter.GetPainter(search.Trim());
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