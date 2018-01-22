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

namespace TOAPocket.UI.Web.Barcode
{
    public partial class VoidShipment : System.Web.UI.Page
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
                ViewState["gridShipment"] = null;
                SetGridData("");

                dvScanBarcode.Style["display"] = "none";
                btnSaveTmp.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                btnBack.Visible = false;
                ViewState["gridBarcodeScan"] = null;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                SetGridData(txtShipmentNo.Text.Trim());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private DataTable InitialTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("ShipmentId", typeof(string)));
            dt.Columns.Add(new DataColumn("Scan", typeof(string)));
            dt.Columns.Add(new DataColumn("ShipmentNo", typeof(string)));
            dt.Columns.Add(new DataColumn("BTFS", typeof(string)));
            dt.Columns.Add(new DataColumn("VoidQty", typeof(string)));
            dt.Columns.Add(new DataColumn("ScanQty", typeof(string)));
            dt.Columns.Add(new DataColumn("Material", typeof(string)));
            dt.Columns.Add(new DataColumn("MatDesc", typeof(string)));
            dt.Columns.Add(new DataColumn("BatchNo", typeof(string)));
            dt.Columns.Add(new DataColumn("CreateDate", typeof(string)));
            dt.Columns.Add(new DataColumn("Status", typeof(string)));

            return dt;
        }

        private void SetGridData(string shipmentNo)
        {
            try
            {
                BLBarcode blBarcode = new BLBarcode();
                DataSet ds = new DataSet();
                DataTable dt = InitialTable();
                ds = blBarcode.GetShipment(shipmentNo);

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow dtr;
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            dtr = dt.NewRow();
                            dtr["ShipmentId"] = dr["SHIP_ID"].ToString();
                            dtr["ShipmentNo"] = dr["SHIP_NO"].ToString();
                            dtr["BTFS"] = dr["BTFS"].ToString();
                            dtr["VoidQty"] = dr["VOID_QTY"].ToString();
                            dtr["ScanQty"] = dr["SCAN_QTY"].ToString();
                            dtr["Material"] = dr["MAT_NO"].ToString();
                            dtr["MatDesc"] = dr["MAT_DESC"].ToString();
                            dtr["BatchNo"] = dr["BATCH_NO"].ToString();
                            if (!String.IsNullOrEmpty(dr["CREATE_DATE"].ToString()))
                            {
                                DateTime dti = Convert.ToDateTime(dr["CREATE_DATE"].ToString());
                                dtr["CreateDate"] = dti.Day.ToString() + '/' + dti.Month.ToString() + '/' + dti.Year.ToString();
                            }
                            //dtr["CreateDate"] = dr["CREATE_DATE"].ToString();
                            dtr["Status"] = dr["STATUS_NAME"].ToString();

                            dt.Rows.Add(dtr);
                        }
                    }
                }

                ViewState["gridShipment"] = dt;
                gridShipment.DataSource = dt;
                gridShipment.DataBind();

                foreach (GridViewRow item in gridShipment.Rows)
                {
                    var voidQty = !IsDigitsOnly(item.Cells[4].Text) ? 0 : Convert.ToInt32(item.Cells[4].Text);
                    var scanQty = !IsDigitsOnly(item.Cells[5].Text) ? 0 : Convert.ToInt32(item.Cells[5].Text);

                    if (voidQty == scanQty)
                    {
                        item.Cells[4].Style["background-color"] = "green";
                        item.Cells[5].Style["background-color"] = "green";

                        //Field Button Scan
                        //item.Cells[1].Visible = false;
                    }
                    else
                    {
                        item.Cells[4].Style["background-color"] = "orange";
                        item.Cells[5].Style["background-color"] = "orange";
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridShipment_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                if (ViewState["gridShipment"] != null)
                {
                    DataTable dt = (DataTable)ViewState["gridShipment"];
                    gridShipment.PageIndex = e.NewPageIndex;
                    gridShipment.DataSource = dt;
                    gridShipment.DataBind();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridShipment_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ScanBarcode")
                {
                    var index = Convert.ToInt32(e.CommandArgument);

                    dvShipment.Style["display"] = "none";
                    dvShipmentScan.Style["display"] = "none";
                    dvScanBarcode.Style["display"] = "block";

                    if (ViewState["gridShipment"] != null)
                    {
                        DataTable dt = (DataTable)ViewState["gridShipment"];

                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (i == index)
                            {
                                DataRow dr = dt.Rows[i];
                                hdShipId.Value = dr["ShipmentId"].ToString();

                                lbShipmentNo.InnerText = dr["ShipmentNo"].ToString();
                                lbBtfs.InnerText = dr["BTFS"].ToString();
                                lbVoidQty.InnerText = dr["VoidQty"].ToString();
                                lbScanQty.InnerText = String.IsNullOrEmpty(dr["ScanQty"].ToString()) ? "0" : dr["ScanQty"].ToString();
                                var remainQty = Convert.ToInt32(lbVoidQty.InnerText) - Convert.ToInt32(lbScanQty.InnerText);
                                lbRemainQty.InnerText = remainQty.ToString();

                                btnBack.Visible = true;

                                lbBarcode.Style["display"] = "block";
                                txtBarcodeScan.Style["display"] = "block";
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

        #region "Scan Barcode"
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
        protected void txtBarcodeScan_OnTextChanged(object sender, EventArgs e)
        {
            int rowIndex = 0;
            try
            {
                if (!String.IsNullOrEmpty(txtBarcodeScan.Text) && txtBarcodeScan.Text.Length == 11 && IsDigitsOnly(txtBarcodeScan.Text))
                {
                    BLBarcode blBarcode = new BLBarcode();
                    DataSet ds = blBarcode.GetBarcodeShipment(hdShipId.Value, txtBarcodeScan.Text.Trim());

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
                        btnSaveTmp.Visible = true;
                        btnSave.Visible = true;
                        btnCancel.Visible = true;
                    }
                    else
                    {
                        btnSaveTmp.Visible = false;
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
                        btnSaveTmp.Visible = true;
                        btnSave.Visible = true;
                        btnCancel.Visible = true;
                    }
                    else
                    {
                        btnSaveTmp.Visible = false;
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

                result = blBarcode.InsertBarcodeShipment(hdShipId.Value, barcode, users.UserName, users.DeptName);

                if (result)
                {
                    var spBarcode = barcode.Split(',');
                    DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                    foreach (var bc in spBarcode)
                    {
                        DataSet ds = blBarcode.GetBarcodeShipment(hdShipId.Value, bc);

                        foreach (DataRow dr in dt.Rows)
                        {
                            if (dr["Barcode"].ToString().Equals(bc))
                            {
                                dr["Status"] = ds.Tables[0].Rows[0]["STATUS"];
                            }
                        }
                    }

                    ViewState["gridBarcodeScan"] = dt;
                    //ViewState["gridBarcodeScan"] = null;
                    gridBarcodeScan.Columns[3].Visible = true;
                    gridBarcodeScan.Columns[2].Visible = false;

                    gridBarcodeScan.DataSource = dt;
                    gridBarcodeScan.DataBind();

                    var countVoid = 0;
                    foreach (GridViewRow item in gridBarcodeScan.Rows)
                    {
                        var status = item.Cells[3].Text;

                        if (status.Equals("OK"))
                        {
                            item.Cells[3].Style["background-color"] = "green";
                            countVoid++;
                        }
                        else
                        {
                            item.Cells[3].Style["background-color"] = "red";
                        }
                    }

                    gridBarcodeScan.HeaderRow.Cells[0].CssClass = "visiblecol";

                    btnSaveTmp.Visible = false;
                    btnSave.Visible = false;
                    btnCancel.Visible = false;
                    btnBack.Visible = true;

                    var voidQty = Convert.ToInt32(lbVoidQty.InnerText);
                    var scanQty = Convert.ToInt32(lbScanQty.InnerText) + countVoid;
                    var remainQty = voidQty - scanQty;

                    lbScanQty.InnerText = scanQty.ToString();
                    lbRemainQty.InnerText = remainQty.ToString();

                    lbBarcode.Style["display"] = "none";
                    txtBarcodeScan.Style["display"] = "none";

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
                Response.Redirect("VoidShipment.aspx");
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
                Response.Redirect("VoidShipment.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}