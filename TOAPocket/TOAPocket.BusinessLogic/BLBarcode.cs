﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLBarcode
    {
        DABarcode daBarcode = new DABarcode();

        public bool InsertBarcodeToTemp(DataTable dt, string createBy)
        {
            return daBarcode.InsertBarcodeToTemp(dt, createBy);
        }

        public DataSet InsertBarcode(string createBy, string department)
        {
            return daBarcode.InsertBarcode(createBy, department);
        }

        public bool ClearBarcodeTemp(string createBy)
        {
            return daBarcode.ClearBarcodeTemp(createBy);
        }

        public DataSet GetBarcodeByPO(string po)
        {
            return daBarcode.GetBarcodeByPO(po);
        }

        public bool UpdateBarcodeByPO(string po, string department, string updateBy)
        {
            return daBarcode.UpdateBarcodeByPO(po, department, updateBy);
        }

        public DataSet GetBarcodeByBarcode(string po, string barcodeStart, string barcodeEnd)
        {
            return daBarcode.GetBarcodeByBarcode(po, barcodeStart, barcodeEnd);
        }

        public bool UpdateBarcodeByBarcode(string barcodeId, string department, string updateBy)
        {
            return daBarcode.UpdateBarcodeByBarcode(barcodeId, department, updateBy);
        }

        public DataSet GetTrRunningNo()
        {
            return daBarcode.GetTrRunningNo();
        }

        public bool InsertBarcodeTransfer(string trNo, string fromDept, string toDept, string startBar, string endBar, string qty, string transDate, string createBy)
        {
            return daBarcode.InsertBarcodeTransfer(trNo, fromDept, toDept, startBar, endBar, qty, transDate, createBy);
        }

        public DataSet GetBarcodeTransfer(string department)
        {
            return daBarcode.GetBarcodeTransfer(department);
        }
    }
}