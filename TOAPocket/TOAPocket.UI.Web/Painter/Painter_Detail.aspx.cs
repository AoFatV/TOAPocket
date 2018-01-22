using System;
using TOAPocket.UI.Web.Model;
using System.Data;
using System.Web.Services;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;

namespace TOAPocket.UI.Web.Painter
{
    public partial class Painter_Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request.Params["Id"]))
                {
                    var users = (User)Session["User"];
                    hdUserId.Value = users.UserId;
                    hdUserName.Value = users.UserName;
                    hdPainterId.Value = Request.Params["Id"];
                    InitialDropdown();
                    //InitialRadio();

                    SetDataPainter(Request.Params["Id"]);
                }
            }
        }

        private void SetDataPainter(string painterId)
        {
            try
            {
                BLPainter blPainter = new BLPainter();
                DataSet ds = blPainter.GetPainterById(painterId);

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            lbPainterNo.InnerText = dr["PAINTER_NO"].ToString();
                            txtName.Text = dr["FIRST_NAME"].ToString();
                            txtSurname.Text = dr["LAST_NAME"].ToString();
                            txtMobileNo.Text = dr["MOBILE_NO"].ToString();
                            ddlArea.SelectedValue = dr["AREA_CODE"].ToString().Trim();
                            txtAddress.Text = dr["ADDRESS1"].ToString();
                            ddlJob.SelectedValue = dr["OCCUPATION"].ToString();
                            if (!String.IsNullOrEmpty(dr["INCOME_PER_MONTH"].ToString()))
                            {
                                ddlIncome.SelectedValue = Convert.ToInt32(dr["INCOME_PER_MONTH"]).ToString();
                            }

                            if (dr["IS_REGISTER"].ToString().Equals("Y"))
                            {
                                lbStatus.InnerText = "Register";
                            }
                            else
                            {
                                lbStatus.InnerText = "UnRegister";
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

        private void InitialDropdown()
        {
            try
            {
                BLPainter blPainter = new BLPainter();
                DataSet ds1 = blPainter.GetCustomerArea();
                ddlArea.DataSource = ds1;
                ddlArea.DataTextField = "DESC";
                ddlArea.DataValueField = "CODE";
                ddlArea.DataBind();

                DataSet ds2 = blPainter.GetOccupation();
                ddlJob.DataSource = ds2;
                ddlJob.DataTextField = "DESC";
                ddlJob.DataValueField = "CODE";
                ddlJob.DataBind();

                DataSet ds3 = blPainter.GetIncome();
                ddlIncome.DataSource = ds3;
                ddlIncome.DataTextField = "DESC";
                //ddlIncome.DataValueField = "CODE";
                ddlIncome.DataValueField = "ID";
                ddlIncome.DataBind();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string UpdatePainter(string painterId, string painterNo, string name, string surname, string mobile,
            string areaCode, string areaDesc, string address, string job, string income, string updateBy)
        {
            string str = "";
            try
            {
                BLPainter blPainter = new BLPainter();
                bool result = false;
                DataTable dt = new DataTable();

                Utility utility = new Utility();

                result = blPainter.UpdatePainter(painterId, painterNo, name, surname, mobile, areaCode.Trim(), areaDesc, address, job, income, updateBy);

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