using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class VoidBarcode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                //SetInitialRow("test");
            }
        }

        protected void txtBarcodeScan_OnTextChanged(object sender, EventArgs e)
        {
            int rowIndex = 0;
            try
            {
                if (!String.IsNullOrEmpty(txtBarcodeScan.Text) && txtBarcodeScan.Text.Length == 11 && IsDigitsOnly(txtBarcodeScan.Text))
                {
                    if (ViewState["gridBarcodeScan"] != null)
                    {
                        DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                        DataRow dr = null;

                        if (dt.Rows.Count > 0)
                        {
                            if (!IsDupplicateBarcode(dt, txtBarcodeScan.Text))
                            {
                                dr = dt.NewRow();
                                dr["No"] = dt.Rows.Count + 1;
                                dr["Barcode"] = txtBarcodeScan.Text;

                                dt.Rows.Add(dr);

                                ViewState["gridBarcodeScan"] = dt;

                                gridBarcodeScan.DataSource = dt;
                                gridBarcodeScan.DataBind();
                            }
                            else
                            {
                                //Barcode Dupplicate
                            }
                        }
                        else
                        {
                            //after delete all
                            SetInitialRow(txtBarcodeScan.Text);
                        }
                    }
                    else
                    {
                        //First Record
                        SetInitialRow(txtBarcodeScan.Text);
                    }


                }
                else
                {
                    //Barcode invalid
                }

                //Set Focus
                txtBarcodeScan.Focus();
                txtBarcodeScan.Text = "";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void SetInitialRow(string barcode)
        {
            DataTable dt = new DataTable();
            DataRow dr = null;
            dt.Columns.Add(new DataColumn("No", typeof(string)));
            dt.Columns.Add(new DataColumn("Barcode", typeof(string)));
            dt.Columns.Add(new DataColumn("Delete", typeof(string)));
            dr = dt.NewRow();
            dr["No"] = 1;
            dr["Barcode"] = barcode;
            dr["Delete"] = string.Empty;
            dt.Rows.Add(dr);

            ViewState["gridBarcodeScan"] = dt;
            gridBarcodeScan.DataSource = dt;
            gridBarcodeScan.DataBind();

        }

        bool IsDigitsOnly(string str)
        {
            foreach (char c in str)
            {
                if (c < '0' || c > '9')
                    return false;
            }

            return true;
        }

        private bool IsDupplicateBarcode(DataTable dt, string barcode)
        {
            bool dupp = false;
            try
            {
                foreach (DataRow dr in dt.Rows)
                {
                    if (dr["Barcode"].ToString().ToLower().Equals(barcode.ToLower()))
                    {
                        dupp = true;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dupp;
        }

        protected void gridBarcodeScan_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                if (ViewState["gridBarcodeScan"] != null)
                {
                    DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                    gridBarcodeScan.PageIndex = e.NewPageIndex;
                    gridBarcodeScan.DataSource = dt;
                    gridBarcodeScan.DataBind();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridBarcodeScan_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "DeleteBarcode")
                {
                    var index = Convert.ToInt32(e.CommandArgument);

                    if (ViewState["gridBarcodeScan"] != null)
                    {
                        DataTable dt = (DataTable)ViewState["gridBarcodeScan"];

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (i == index)
                            {
                                DataRow drDel = dt.Rows[i];
                                drDel.Delete();
                            }
                        }

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            DataRow dr = dt.Rows[i];
                            dr["No"] = i + 1;
                        }

                        ViewState["gridBarcodeScan"] = dt;

                        gridBarcodeScan.DataSource = dt;
                        gridBarcodeScan.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridBarcodeScan_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}