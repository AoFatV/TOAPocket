﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TOAPocket.BusinessLogic;
using TOAPocket.UI.Web.Model;

namespace TOAPocket.UI.Web.Barcode
{
    public partial class ImportBarcode : System.Web.UI.Page
    {
        public DataTable dtUpload = new DataTable();
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
                BLBarcode blBarcode = new BLBarcode();
                var users = (User)Session["User"];
                bool result = blBarcode.ClearBarcodeTemp(users.UserName);
            }
        }

        protected void btnUpload_OnClick(object sender, EventArgs e)
        {
            try
            {
                if (fileUpload.HasFile)
                {
                    string fileName = Path.GetFileName(fileUpload.PostedFile.FileName);
                    string extension = Path.GetExtension(fileUpload.PostedFile.FileName);
                    string tmpFolderPath = ConfigurationManager.AppSettings["TmpFolderPath"];

                    if (extension == ".xls" || extension == ".xlsx")
                    {
                        string FilePath = Server.MapPath(tmpFolderPath + fileName);
                        fileUpload.SaveAs(FilePath);
                        ImportToTable(FilePath, extension, true);
                    }
                    else
                    {
                        msg = "ไฟล์ Excel ที่อัพโหลดไม่ถูกต้อง";
                        actionResult = false;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ImportToTable(string FilePath, string Extension, bool isHDR)
        {
            BLBarcode blBarcode = new BLBarcode();
            try
            {
                string conStr = "";
                switch (Extension)
                {
                    case ".xls":
                        conStr = ConfigurationManager.ConnectionStrings["Excel03ConString"]
                            .ConnectionString;
                        break;
                    case ".xlsx":
                        conStr = ConfigurationManager.ConnectionStrings["Excel07ConString"]
                            .ConnectionString;
                        break;
                }
                conStr = String.Format(conStr, FilePath, isHDR);
                OleDbConnection connExcel = new OleDbConnection(conStr);
                OleDbCommand cmdExcel = new OleDbCommand();
                OleDbDataAdapter oda = new OleDbDataAdapter();
                DataTable dt = new DataTable();
                cmdExcel.Connection = connExcel;

                //Get the name of First Sheet
                connExcel.Open();
                DataTable dtExcelSchema;
                dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                connExcel.Close();

                //Read Data from First Sheet
                connExcel.Open();
                cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
                oda.SelectCommand = cmdExcel;
                oda.Fill(dt);
                connExcel.Close();

                var users = (User)Session["User"];
                bool resultClear = blBarcode.ClearBarcodeTemp(users.UserName);
                bool rsTmp = blBarcode.InsertBarcodeToTemp(dt, users.UserName);

                if (rsTmp && resultClear)
                {
                    dtUpload = dt;
                    dtUpload.Columns.Add("STATUS", typeof(String));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnImport_OnClick(object sender, EventArgs e)
        {
            BLBarcode blBarcode = new BLBarcode();
            DataSet ds = new DataSet();
            bool result = false;
            try
            {
                var users = (User)Session["User"];
                ds = blBarcode.InsertBarcode(users.UserName, "");
                //result = blBarcode.ClearBarcodeTemp(HttpContext.Current.User.Identity.Name);

                actionResult = false;
                msg = "เกิดข้อผิดพลาด!";

                if (ds.Tables.Count > 0)
                {
                    dtUpload = ds.Tables[0];

                    actionResult = true;
                    msg = "บันทึกข้อมูลสำเร็จ";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            BLBarcode blBarcode = new BLBarcode();
            bool result = false;
            try
            {
                var users = (User)Session["User"];
                result = blBarcode.ClearBarcodeTemp(users.UserName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}