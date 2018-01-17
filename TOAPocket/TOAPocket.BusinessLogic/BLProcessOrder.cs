using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;
using System.Data;

namespace TOAPocket.BusinessLogic
{
    public class BLProcessOrder
    {
        DAProcessOrder daProcesOrder = new DAProcessOrder();
        public DataSet GetProcessOrder(string processOrder)
        {
            return daProcesOrder.GetProcessOrder(processOrder);
        }

        public DataSet GetProcessOrderMatch(string barcode, string processOrder)
        {
            return daProcesOrder.GetProcessOrderMatch(barcode, processOrder);
        }

        public bool InsertProcessOrderMatch(string processNo, string barcode, string createBy, string department)
        {
            return daProcesOrder.InsertProcessOrderMatch(processNo, barcode, createBy, department);
        }
    }
}