using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Model;
using System.Data;

namespace TOAPocket.UI.Web.Barcode
{

    public partial class MatchBarcode : System.Web.UI.Page
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
                btnSaveTemp.Visible = false;
                btnCancelScanBarcode.Visible = false;
                btnBack.Visible = false;

                dvScanBarcode.Style["display"] = "none";
                dvRangesBarcode.Style["display"] = "none";

                lbMatchQty.InnerText = "0";

                hdProcessOrderValid.Value = "N";

                ViewState["gridBarcodeScan"] = null;
            }
        }

        protected void txtProcessOrder_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (!String.IsNullOrEmpty(txtProcessOrder.Text))
                {
                    BLProcessOrder blOrder = new BLProcessOrder();
                    DataSet ds = blOrder.GetProcessOrder(txtProcessOrder.Text);

                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                txtBtfs.Text = dr["BTFS"].ToString();
                                txtMaterial.Text = dr["MAT_NO"].ToString();
                                txtMatDesc.Text = dr["MAT_DESC"].ToString();
                                txtOrderQty.Text = dr["ORDER_QTY"].ToString();
                                txtCoinType.Text = dr["COIN_DESC"].ToString();
                                lbMatchQty.InnerText = dr["MATCH_QTY"].ToString();

                                hdProcessOrderValid.Value = "Y";
                            }
                        }
                        else
                        {
                            msg = "ไม่พบ ProcessOrder ที่แสกน !";
                            actionResult = false;
                        }
                    }
                    else
                    {
                        msg = "ไม่พบ ProcessOrder ที่แสกน !";
                        actionResult = false;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void txtBarcodeScan_OnTextChanged(object sender, EventArgs e)
        {
            int rowIndex = 0;
            try
            {
                if (!String.IsNullOrEmpty(txtBarcodeScan.Text) && txtBarcodeScan.Text.Length == 11 && IsDigitsOnly(txtBarcodeScan.Text))
                {
                    BLProcessOrder blPrOrder = new BLProcessOrder();
                    DataSet ds = blPrOrder.GetProcessOrderMatch(txtBarcodeScan.Text.Trim(), txtProcessOrder.Text.Trim());

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

                                //var orderQty = Convert.ToInt32(txtOrderQty.Text);
                                //var matchQty = dt.Rows.Count;
                                //var remainQty = orderQty - matchQty;

                                //lbMatchQty.InnerText = matchQty.ToString();
                                //lbRemainQty.InnerText = remainQty.ToString();

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

                                //var orderQty = Convert.ToInt32(txtOrderQty.Text);
                                //var matchQty = 1;
                                //var remainQty = orderQty - matchQty;

                                //lbMatchQty.InnerText = matchQty.ToString();
                                //lbRemainQty.InnerText = remainQty.ToString();

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
                            //var orderQty = Convert.ToInt32(txtOrderQty.Text);
                            //var matchQty = 1;
                            //var remainQty = orderQty - matchQty;

                            //lbMatchQty.InnerText = matchQty.ToString();
                            //lbRemainQty.InnerText = remainQty.ToString();
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
                        btnSaveTemp.Visible = true;
                        btnCancelScanBarcode.Visible = true;
                    }
                    else
                    {
                        btnSaveTemp.Visible = false;
                        btnCancelScanBarcode.Visible = false;
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

                    if (gridBarcodeScan.Columns[3].Visible)
                    {
                        foreach (GridViewRow item in gridBarcodeScan.Rows)
                        {
                            var status = item.Cells[3].Text;

                            if (status.Equals("Matched"))
                            {
                                item.Cells[3].Style["background-color"] = "green";
                            }
                            else
                            {
                                item.Cells[3].Style["background-color"] = "red";
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

                        //var orderQty = Convert.ToInt32(txtOrderQty.Text);
                        //var matchQty = dt.Rows.Count;
                        //var remainQty = orderQty - matchQty;
                        //lbMatchQty.InnerText = matchQty.ToString();
                        //lbRemainQty.InnerText = remainQty.ToString();

                        ViewState["gridBarcodeScan"] = dt;

                        gridBarcodeScan.DataSource = dt;
                        gridBarcodeScan.DataBind();
                    }


                    if (gridBarcodeScan.Rows.Count > 0)
                    {
                        btnSaveTemp.Visible = true;
                        btnCancelScanBarcode.Visible = true;
                    }
                    else
                    {
                        btnSaveTemp.Visible = false;
                        btnCancelScanBarcode.Visible = false;
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

        protected void btnScan_ServerClick(object sender, EventArgs e)
        {
            try
            {
                if (!String.IsNullOrEmpty(txtProcessOrder.Text))
                {
                    dvProcessOrder.Style["display"] = "none";
                    dvScanBarcode.Style["display"] = "block";
                    txtBarcodeScan.Style["display"] = "block";

                    lbPrOrder.InnerText = txtProcessOrder.Text;
                    lbBtfs.InnerText = txtBtfs.Text;
                    lbOrderQty.InnerText = txtOrderQty.Text;

                    var orderQty = Convert.ToInt32(txtOrderQty.Text);
                    var matchQty = Convert.ToInt32(lbMatchQty.InnerText);
                    var remainQty = orderQty - matchQty;

                    lbRemainQty.InnerText = remainQty.ToString();

                    btnBack.Visible = true;
                }
                else
                {
                    msg = "กรุณา Scan ProcessOrder ก่อน !";
                    actionResult = false;
                }
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
                BLProcessOrder blPrOrder = new BLProcessOrder();
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

                result = blPrOrder.InsertProcessOrderMatch(txtProcessOrder.Text, barcode, users.UserName, users.DeptName);

                if (result)
                {
                    var spBarcode = barcode.Split(',');
                    DataTable dt = (DataTable)ViewState["gridBarcodeScan"];
                    foreach (var bc in spBarcode)
                    {
                        DataSet ds = blPrOrder.GetProcessOrderMatch(bc, txtProcessOrder.Text);

                        foreach (DataRow dr in dt.Rows)
                        {
                            if (dr["Barcode"].ToString().Equals(bc))
                            {
                                dr["Status"] = ds.Tables[0].Rows[0]["STATUS"];
                            }
                        }
                    }

                    ViewState["gridBarcodeScan"] = null;
                    gridBarcodeScan.Columns[3].Visible = true;
                    gridBarcodeScan.Columns[2].Visible = false;

                    gridBarcodeScan.DataSource = dt;
                    gridBarcodeScan.DataBind();

                    gridBarcodeScan.HeaderRow.Cells[0].CssClass = "visiblecol";

                    var countMatch = 0;
                    foreach (GridViewRow item in gridBarcodeScan.Rows)
                    {
                        var status = item.Cells[3].Text;

                        if (status.Equals("Matched"))
                        {
                            item.Cells[3].Style["background-color"] = "green";
                            countMatch++;
                        }
                        else
                        {
                            item.Cells[3].Style["background-color"] = "red";
                        }
                    }

                    btnSaveTemp.Visible = false;
                    btnCancelScanBarcode.Visible = false;
                    btnBack.Visible = true;

                    txtBarcodeScan.Style["display"] = "none";
                    lbBarcodeScan.Style["display"] = "none";

                    var orderQty = Convert.ToInt32(txtOrderQty.Text);
                    var matchQty = Convert.ToInt32(lbMatchQty.InnerText) + countMatch;
                    var remainQty = orderQty - matchQty;

                    lbMatchQty.InnerText = matchQty.ToString();
                    lbRemainQty.InnerText = remainQty.ToString();

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

        protected void btnBack_OnServerClick(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("MatchBarcode.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnCancelProcessOrder_ServerClick(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("MatchBarcode.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnCancelScanBarcode_ServerClick(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("MatchBarcode.aspx");
            }
            catch (Exception ex)
            {
                throw ex;
            }
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

        protected void rdoType_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (rdoType.SelectedValue.Equals("1"))
                {
                    //Scan
                    dvRangesBarcode.Style["display"] = "none";
                    dvButton.Style["display"] = "block";
                }
                else
                {
                    //Ranges Barcode
                    //if (!String.IsNullOrEmpty(txtProcessOrder.Text) && hdProcessOrderValid.Value.Equals("Y"))
                    //{
                    dvRangesBarcode.Style["display"] = "block";
                    dvButton.Style["display"] = "none";
                    //}
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnSave2_ServerClick(object sender, EventArgs e)
        {
            try
            {
                bool result = false;
                BLProcessOrder blPrOrder = new BLProcessOrder();
                string barcode = "";

                var users = (User)Session["User"];

                var bcStart = txtBarcodeStart.Text;
                var bcEnd = txtBarcodeEnd.Text;

                var format = bcStart.Substring(0, 7);
                int stRunning = Convert.ToInt32(bcStart.Substring(bcStart.Length - 4));
                int endRunning = Convert.ToInt32(bcEnd.Substring(bcStart.Length - 4));

                for (int i = stRunning; i <= endRunning; i++)
                {
                    var running = i.ToString().PadLeft(4, '0');
                    barcode = barcode + format + running + ",";
                }

                barcode = barcode.Substring(0, barcode.Length - 1);

                result = blPrOrder.InsertProcessOrderMatch(txtProcessOrder.Text, barcode, users.UserName, users.DeptName);

                if (result)
                {
                    var spBarcode = barcode.Split(',');

                    DataTable dt = new DataTable();
                    DataRow dr = null;
                    dt.Columns.Add(new DataColumn("No", typeof(string)));
                    dt.Columns.Add(new DataColumn("Barcode", typeof(string)));
                    dt.Columns.Add(new DataColumn("Delete", typeof(string)));
                    dt.Columns.Add(new DataColumn("Status", typeof(string)));

                    var n = 1;
                    foreach (var bc in spBarcode)
                    {
                        DataSet ds = blPrOrder.GetProcessOrderMatch(bc, txtProcessOrder.Text);

                        if (ds.Tables.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                dr = dt.NewRow();
                                dr["No"] = n;
                                dr["Barcode"] = bc;
                                dr["Delete"] = string.Empty;
                                dr["Status"] = ds.Tables[0].Rows[0]["STATUS"];
                                dt.Rows.Add(dr);
                                n++;
                            }
                        }
                    }

                    ViewState["gridBarcodeScan"] = dt;
                    gridBarcodeScan.Columns[3].Visible = true;
                    gridBarcodeScan.Columns[2].Visible = false;

                    gridBarcodeScan.DataSource = dt;
                    gridBarcodeScan.DataBind();

                    gridBarcodeScan.HeaderRow.Cells[0].CssClass = "visiblecol";

                    var countMatch = 0;
                    foreach (GridViewRow item in gridBarcodeScan.Rows)
                    {
                        var status = item.Cells[3].Text;

                        if (status.Equals("Matched"))
                        {
                            item.Cells[3].Style["background-color"] = "green";
                            countMatch++;
                        }
                        else
                        {
                            item.Cells[3].Style["background-color"] = "red";
                        }
                    }

                    btnSaveTemp.Visible = false;
                    btnCancelScanBarcode.Visible = false;
                    btnBack.Visible = true;

                    txtBarcodeScan.Style["display"] = "none";

                    //Next Step

                    dvProcessOrder.Style["display"] = "none";
                    dvScanBarcode.Style["display"] = "block";
                    dvRangesBarcode.Style["display"] = "none";

                    lbPrOrder.InnerText = txtProcessOrder.Text;
                    lbBtfs.InnerText = txtBtfs.Text;
                    lbOrderQty.InnerText = txtOrderQty.Text;

                    var orderQty = Convert.ToInt32(txtOrderQty.Text);
                    var matchQty = Convert.ToInt32(lbMatchQty.InnerText) + countMatch;
                    var remainQty = orderQty - matchQty;

                    lbMatchQty.InnerText = matchQty.ToString();
                    lbRemainQty.InnerText = remainQty.ToString();

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
    }
}