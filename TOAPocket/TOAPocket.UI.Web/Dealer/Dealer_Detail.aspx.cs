using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;
using System.Data;
using System.Web.Services;

namespace TOAPocket.UI.Web.Dealer
{
    public partial class Dealer_Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                if (!String.IsNullOrEmpty(Request.Params["Dealer"]))
                {
                    var users = (User)Session["User"];
                    hdUserId.Value = users.UserId;
                    hdUserName.Value = users.UserName;
                    hdDealer.Value = Request.Params["Dealer"];
                    //InitialDropdown();
                    //InitialRadio();

                    SetDataDealer(Request.Params["Dealer"]);
                }
            }
        }

        private void SetDataDealer(string DealerId)
        {
            try
            {
                BLDealer blDealer = new BLDealer();
                DataSet ds = blDealer.GetDealerById(DealerId);

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            lbDealerId.InnerText = dr["DEALER_ID"].ToString();
                            lbDealerName.InnerText = dr["DEALER_NAME"].ToString();
                            lbVendorCode.InnerText = dr["VENDOR_CODE"].ToString();
                            lbTextNo1.InnerText = dr["TAX_NO_1"].ToString();
                            lbTextNo4.InnerText = dr["TAX_NO_4"].ToString();
                            lbTextNo3.InnerText = dr["TAX_NO_3"].ToString();
                            lbSaleA.InnerText = dr["SALES_TA_NAME"].ToString();
                            lbSaleTK.InnerText = dr["SALES_TK_NAME"].ToString();
                            lbSaleB.InnerText = dr["SALES_TB_NAME"].ToString();
                            txtMaxReceive.Value = dr["RECEIVE_MAX_QTY"].ToString();
                            lbAccountName.InnerText = dr["ACCOUNT_NAME"].ToString();
                            lbBank.InnerText = dr["BANK_NAME"].ToString();
                            lbBranch.InnerText = dr["BANK_BRANCH"].ToString();
                            lbAccountNumber.InnerText = dr["BANK_ACCOUNT"].ToString();
                            txtAddress.Text = dr["STREET"].ToString() + " " +
                                dr["STREET4"].ToString() + " " +
                                dr["STREET5"].ToString() + " " +
                                dr["DISTRICT_DESC"].ToString() + " " +
                                dr["CITY_DESC"].ToString() + " " +
                                dr["POST_CODE"].ToString();
                            lbMobile.InnerText = dr["MOBILE"].ToString();
                            lbEmail.InnerText = dr["EMAIL"].ToString();
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
        public static string UpdateDealer(string dealerId, string maxReceive, string updateBy)
        {
            string str = "";
            try
            {
                BLDealer blDealer = new BLDealer();
                bool result = false;
                DataTable dt = new DataTable();

                Utility utility = new Utility();

                result = blDealer.UpdateDealer(dealerId, maxReceive, updateBy);

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