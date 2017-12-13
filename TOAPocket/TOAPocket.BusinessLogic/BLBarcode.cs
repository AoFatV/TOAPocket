using System;
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
    }
}