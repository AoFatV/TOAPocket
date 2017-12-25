using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.HSSF.UserModel;
using NPOI.HSSF.Util;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Common;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Stock
{
    public partial class StockBarcode : System.Web.UI.Page
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

                InitialDropdown();
                SetInitialRow();
            }
        }

        protected void InitialDropdown()
        {
            try
            {
                DataSet ds = new DataSet();
                BLDepartment blDepartment = new BLDepartment();
                BLStatus blStatus = new BLStatus();

                ds = blDepartment.GetDepartment("");
                ddlDepartment.DataSource = ds;
                ddlDepartment.DataValueField = "DEPT_ID";
                ddlDepartment.DataTextField = "DEPT_NAME";
                ddlDepartment.DataBind();

                ds = blStatus.GetStatus("");
                ddlStatus.DataSource = ds;
                ddlStatus.DataValueField = "STATUS_ID";
                ddlStatus.DataTextField = "STATUS_NAME";
                ddlStatus.DataBind();

                ddlStatus.Items.Insert(0, new ListItem("ALL", ""));

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void SetInitialRow()
        {
            try
            {
                DataSet ds = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                ds = blBarcode.GetStockBarcode(txtBarcode.Text.Trim(), txtPoNo.Text.Trim(), txtEditStart.Text.Trim(),
                    txtEditEnd.Text.Trim(), ddlDepartment.SelectedItem.Text, ddlStatus.SelectedValue);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ViewState["gridStockBarcode"] = ds.Tables[0];
                        gridStockBarcode.DataSource = ds.Tables[0];
                        gridStockBarcode.DataBind();
                    }
                }

                //DataTable dt = new DataTable();
                //DataRow dr = null;
                //dt.Columns.Add(new DataColumn("No", typeof(string)));
                //dt.Columns.Add(new DataColumn("Barcode", typeof(string)));
                //dt.Columns.Add(new DataColumn("PONo", typeof(string)));
                //dt.Columns.Add(new DataColumn("Department", typeof(string)));
                //dt.Columns.Add(new DataColumn("CreateDate", typeof(string)));
                //dt.Columns.Add(new DataColumn("LastEditDate", typeof(string)));
                //dt.Columns.Add(new DataColumn("LastEditBy", typeof(string)));
                //dt.Columns.Add(new DataColumn("Status", typeof(string)));
                //dr = dt.NewRow();
                //dr["No"] = 1;
                //dr["Barcode"] = string.Empty;
                //dr["PONo"] = string.Empty;
                //dr["Department"] = string.Empty;
                //dr["CreateDate"] = string.Empty;
                //dr["LastEditDate"] = string.Empty;
                //dr["LastEditBy"] = string.Empty;
                //dr["Status"] = string.Empty;
                //dt.Rows.Add(dr);

                //ViewState["gridStockBarcode"] = dt;
                //gridStockBarcode.DataSource = dt;
                //gridStockBarcode.DataBind();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [WebMethod]
        public static string GetStockBarcode(string barcode, string poNo, string lastEditStart, string lastEditEnd, string department, string status)
        {
            BLBarcode blBarcode = new BLBarcode();
            DataSet ds = new DataSet();
            Utility utility = new Utility();
            string result = "";
            try
            {
                ds = blBarcode.GetStockBarcode(barcode, poNo, lastEditStart, lastEditEnd, department, status);
                result = utility.DataTableToJSONWithJavaScriptSerializer(ds.Tables[0]);
            }
            catch (Exception ex)
            {

            }
            return result;
        }

        protected void btnSearch_OnServerClick(object sender, EventArgs e)
        {
            try
            {
                DataSet ds = new DataSet();
                BLBarcode blBarcode = new BLBarcode();
                ds = blBarcode.GetStockBarcode(txtBarcode.Text.Trim(), txtPoNo.Text.Trim(), txtEditStart.Text.Trim(),
                    txtEditEnd.Text.Trim(), ddlDepartment.SelectedItem.Text, ddlStatus.SelectedValue);
                //if (ds.Tables.Count > 0)
                //{
                //    if (ds.Tables[0].Rows.Count > 0)
                //    {
                ViewState["gridStockBarcode"] = ds.Tables[0];
                gridStockBarcode.DataSource = ds.Tables[0];
                gridStockBarcode.DataBind();
                //    }
                //}
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridStockBarcode_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                if (ViewState["gridStockBarcode"] != null)
                {
                    DataTable dt = (DataTable)ViewState["gridStockBarcode"];
                    gridStockBarcode.PageIndex = e.NewPageIndex;
                    gridStockBarcode.DataSource = dt;
                    gridStockBarcode.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //protected void ExportToExcel()
        //{
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.AddHeader("content-disposition", "attachment;filename=รายงานคลัง Barcode.xls");
        //    Response.Charset = "";
        //    Response.ContentType = "application/vnd.ms-excel";
        //    using (StringWriter sw = new StringWriter())
        //    {
        //        HtmlTextWriter hw = new HtmlTextWriter(sw);

        //        //To Export all pages
        //        gridStockBarcode.AllowPaging = false;
        //        gridStockBarcode.DataBind();

        //        gridStockBarcode.HeaderRow.BackColor = Color.White;
        //        foreach (TableCell cell in gridStockBarcode.HeaderRow.Cells)
        //        {
        //            cell.BackColor = gridStockBarcode.HeaderStyle.BackColor;
        //        }
        //        foreach (GridViewRow row in gridStockBarcode.Rows)
        //        {
        //            row.BackColor = Color.White;
        //            foreach (TableCell cell in row.Cells)
        //            {
        //                if (row.RowIndex % 2 == 0)
        //                {
        //                    cell.BackColor = gridStockBarcode.AlternatingRowStyle.BackColor;
        //                }
        //                else
        //                {
        //                    cell.BackColor = gridStockBarcode.RowStyle.BackColor;
        //                }
        //                cell.CssClass = "textmode";
        //            }
        //        }

        //        gridStockBarcode.RenderControl(hw);

        //        //style to format numbers to string
        //        string style = @"<style> .textmode { } </style>";
        //        Response.Write(style);
        //        Response.Output.Write(sw.ToString());
        //        Response.Flush();
        //        Response.End();
        //    }
        //}

        public void ExportToExcel(String extension, DataTable dt)
        {
            // dll refered NPOI.dll and NPOI.OOXML  

            IWorkbook workbook;

            if (extension == "xlsx")
            {
                workbook = new XSSFWorkbook();
            }
            else if (extension == "xls")
            {
                workbook = new HSSFWorkbook();
            }
            else
            {
                throw new Exception("This format is not supported");
            }

            ISheet sheet1 = workbook.CreateSheet("StockBarcode");

            var headerCellStyle = workbook.CreateCellStyle();
            headerCellStyle.FillForegroundColor = HSSFColor.LightOrange.Index;
            headerCellStyle.FillPattern = FillPattern.SolidForeground;

            var firstRow = 0;
            IRow rowTitle = sheet1.CreateRow(firstRow);
            ICell cellTitle = rowTitle.CreateCell(0);
            firstRow++;

            var fontTitle = workbook.CreateFont();
            fontTitle.FontName = "Calibri";
            fontTitle.Boldweight = (short)FontBoldWeight.Bold;
            fontTitle.FontHeightInPoints = 16;


            var cellStyleTitle = workbook.CreateCellStyle();
            cellStyleTitle.Alignment = HorizontalAlignment.Center;
            cellTitle.CellStyle = cellStyleTitle;
            cellTitle.CellStyle.SetFont(fontTitle);
            cellTitle.SetCellValue("รายงานคลัง Barcode");

            IRow rowDate = sheet1.CreateRow(firstRow);
            ICell cellDate = rowDate.CreateCell(0);
            firstRow++;

            var fontDate = workbook.CreateFont();
            fontDate.FontName = "Calibri";
            fontDate.Boldweight = (short)FontBoldWeight.Bold;
            fontDate.FontHeightInPoints = 12;

            var cellStyleDate = workbook.CreateCellStyle();
            cellStyleDate.Alignment = HorizontalAlignment.Center;
            cellDate.CellStyle = cellStyleDate;
            cellDate.CellStyle.SetFont(fontDate);

            var strDate = "ระหว่างวันที่ " + txtEditStart.Text.Trim() + " ถึง " + txtEditEnd.Text.Trim();
            cellDate.SetCellValue(strDate);


            IRow rowPrintDate = sheet1.CreateRow(firstRow);
            ICell cellPrintDate = rowPrintDate.CreateCell(0);
            firstRow++;

            var cellStylePrintDate = workbook.CreateCellStyle();
            cellStylePrintDate.Alignment = HorizontalAlignment.Right;
            cellPrintDate.CellStyle = cellStylePrintDate;
            cellPrintDate.CellStyle.SetFont(fontDate);

            cellPrintDate.SetCellValue("PrintDate " + DateTime.Now.ToString("dd-MM-yyyy"));

            var range1 = new CellRangeAddress(0, 0, 0, 6);
            sheet1.AddMergedRegion(range1);
            var range2 = new CellRangeAddress(1, 1, 0, 6);
            sheet1.AddMergedRegion(range2);
            var range3 = new CellRangeAddress(2, 2, 0, 6);
            sheet1.AddMergedRegion(range3);

            var listHeader = new[] { "Barcode", "PO No,", "แผนก/คลัง", "วันที่เริ่มต้น", "วันที่แก้ไขล่าสุด", "ผู้แก้ไขล่าสุด", "สถานะ" };
            //make a header row  
            IRow row1 = sheet1.CreateRow(firstRow);

            for (int j = 0; j < listHeader.Length; j++)
            {
                ICell cell = row1.CreateCell(j);

                String columnName = listHeader[j];
                cell.SetCellValue(columnName);
                cell.CellStyle = headerCellStyle;
            }


            //loops through data  
            // j = 1 ไม่เอา no
            firstRow++;
            int r = 0;
            for (int i = firstRow; r < dt.Rows.Count; i++)
            {
                IRow row = sheet1.CreateRow(i);

                DataRow dr = dt.Rows[r];
                ICell cell1 = row.CreateCell(0);
                cell1.SetCellValue(dr["Barcode"].ToString());

                ICell cell2 = row.CreateCell(1);
                cell2.SetCellValue(dr["PONo"].ToString());

                ICell cell3 = row.CreateCell(2);
                cell3.SetCellValue(dr["Department"].ToString());

                ICell cell4 = row.CreateCell(3);
                cell4.SetCellValue(dr["CreateDate"].ToString());

                ICell cell5 = row.CreateCell(4);
                cell5.SetCellValue(dr["LastEditDate"].ToString());

                ICell cell6 = row.CreateCell(5);
                cell6.SetCellValue(dr["LastEditBy"].ToString());

                ICell cell7 = row.CreateCell(6);
                cell7.SetCellValue(dr["Status"].ToString());


                //for (int j = 1; j < dt.Columns.Count; j++)
                //{

                //    ICell cell = row.CreateCell(j);
                //    String columnName = dt.Columns[j].ToString();
                //    cell.SetCellValue(dt.Rows[i][columnName].ToString());

                //    sheet1.AutoSizeColumn(j);
                //}
                r++;
            }

            for (int j = 0; j <= 6; j++)
            {
                sheet1.AutoSizeColumn(j);
            }

            using (var exportData = new MemoryStream())
            {
                Response.Clear();
                workbook.Write(exportData);
                if (extension == "xlsx") //xlsx file format  
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "รายงานคลัง StockBarcode.xlsx"));
                    Response.BinaryWrite(exportData.ToArray());
                }
                else if (extension == "xls")  //xls file format  
                {
                    Response.ContentType = "application/vnd.ms-excel";
                    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "รายงานคลัง StockBarcode.xls"));
                    Response.BinaryWrite(exportData.GetBuffer());
                }
                Response.End();
            }
        }

        protected void btnExport_OnServerClick(object sender, EventArgs e)
        {
            if (ViewState["gridStockBarcode"] != null)
            {
                DataTable dt = (DataTable)ViewState["gridStockBarcode"];
                ExportToExcel("xlsx", dt);
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
               server control at run time. */
        }
    }
}