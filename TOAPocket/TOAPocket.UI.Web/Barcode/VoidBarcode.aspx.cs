using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class VoidBarcode : System.Web.UI.Page
    {
        public string msg;
        public bool actionResult = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                //SetInitialRow("test");
                btnSave.Visible = false;
                btnCancel.Visible = false;
                btnBack.Visible = false;
                ViewState["gridBarcodeScan"] = null;
            }
        }

        protected void txtBarcodeScan_OnTextChanged(object sender, EventArgs e)
        {
            int rowIndex = 0;
            try
            {
                if (!String.IsNullOrEmpty(txtBarcodeScan.Text) && txtBarcodeScan.Text.Length == 11 && IsDigitsOnly(txtBarcodeScan.Text))
                {
                    BLBarcode blBarcode = new BLBarcode();
                    DataSet ds = blBarcode.GetBarcodeVoidDamage(txtBarcodeScan.Text.Trim());

                    if (ViewState["gridBarcodeScan"] != null)
                    {
                        DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                        DataRow dr = null;


                        if (dt.Rows.Count > 0)
                        {
                            if (!IsDupplicateBarcode(dt, txtBarcodeScan.Text) && ds.Tables[0].Rows.Count == 0)
                            {
                                dr = dt.NewRow();
                                dr["No"] = dt.Rows.Count + 1;
                                dr["Barcode"] = txtBarcodeScan.Text;

                                dt.Rows.Add(dr);

                                ViewState["gridBarcodeScan"] = dt;

                                gridBarcodeScan.DataSource = dt;
                                gridBarcodeScan.DataBind();
                                actionResult = true;
                            }
                            else
                            {
                                //Barcode Dupplicate
                                actionResult = false;
                                msg = "Barcode ถูกยิงไปแล้ว กรุณาลองใหม่!";
                            }
                        }
                        else
                        {
                            if (ds.Tables[0].Rows.Count == 0)
                            {
                                //after delete all
                                SetInitialRow(txtBarcodeScan.Text);
                                actionResult = true;
                            }
                            else
                            {
                                //Barcode Dupplicate
                                actionResult = false;
                                msg = "Barcode ถูกยิงไปแล้ว กรุณาลองใหม่!";
                            }
                        }
                    }
                    else
                    {
                        if (ds.Tables[0].Rows.Count == 0)
                        {
                            //First Record
                            SetInitialRow(txtBarcodeScan.Text);
                            actionResult = true;
                        }
                        else
                        {
                            //Barcode Dupplicate
                            actionResult = false;
                            msg = "Barcode ถูกยิงไปแล้ว กรุณาลองใหม่!";
                        }
                    }

                    if (gridBarcodeScan.Rows.Count > 0 || actionResult)
                    {
                        btnSave.Visible = true;
                        btnCancel.Visible = true;
                    }
                    else
                    {
                        btnSave.Visible = false;
                        btnCancel.Visible = false;
                    }

                }
                else
                {
                    //Barcode invalid
                    actionResult = false;
                    msg = "รูปแบบ Barcode ไม่ถูกต้อง กรุณาลองใหม่!";
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
            dt.Columns.Add(new DataColumn("Status", typeof(string)));
            dr = dt.NewRow();
            dr["No"] = 1;
            dr["Barcode"] = barcode;
            dr["Delete"] = string.Empty;
            dr["Status"] = string.Empty;
            dt.Rows.Add(dr);

            ViewState["gridBarcodeScan"] = dt;
            gridBarcodeScan.DataSource = dt;
            gridBarcodeScan.DataBind();

            gridBarcodeScan.Columns[2].Visible = true;
            gridBarcodeScan.Columns[3].Visible = false;

            btnBack.Visible = false;
        }

        private bool IsDigitsOnly(string str)
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


                    if (gridBarcodeScan.Rows.Count > 0)
                    {
                        btnSave.Visible = true;
                        btnCancel.Visible = true;
                    }
                    else
                    {
                        btnSave.Visible = false;
                        btnCancel.Visible = false;
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

        protected void btnSave_ServerClick(object sender, EventArgs e)
        {
            try
            {
                bool result = false;
                BLBarcode blBarcode = new BLBarcode();
                string barcode = "";

                var users = (User)Session["User"];

                if (ViewState["gridBarcodeScan"] != null)
                {
                    DataTable dt = (DataTable)ViewState["gridBarcodeScan"];

                    foreach (DataRow dr in dt.Rows)
                    {
                        barcode = barcode + dr["Barcode"].ToString() + ",";
                    }

                    barcode = barcode.Substring(0, barcode.Length - 1);
                }

                result = blBarcode.InsertBarcodeVoidDamage(barcode, users.UserName, users.DeptName);

                if (result)
                {
                    var spBarcode = barcode.Split(',');
                    DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                    foreach (var bc in spBarcode)
                    {
                        DataSet ds = blBarcode.GetBarcodeVoidDamage(bc);

                        foreach (DataRow dr in dt.Rows)
                        {
                            if (dr["Barcode"].ToString().Equals(bc))
                            {
                                dr["Status"] = ds.Tables[0].Rows[0]["STATUS"];
                            }
                        }
                    }

                    //ViewState["gridBarcodeScan"] = dt;
                    ViewState["gridBarcodeScan"] = null;
                    gridBarcodeScan.Columns[3].Visible = true;
                    gridBarcodeScan.Columns[2].Visible = false;

                    gridBarcodeScan.DataSource = dt;
                    gridBarcodeScan.DataBind();

                    gridBarcodeScan.HeaderRow.Cells[0].CssClass = "visiblecol";

                    btnSave.Visible = false;
                    btnCancel.Visible = false;
                    btnBack.Visible = true;

                    actionResult = true;
                    msg = "บันทึกข้อมูลสำเร็จ";
                }
                else
                {
                    actionResult = false;
                    msg = "เกิดข้อผิดพลาด กรุณาตรวจสอบ!";
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnCancel_ServerClick(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnBack_OnServerClick(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("VoidBarcode.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}