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

        public DataSet GetProcessOrderUnMatch(string barcode, string processOrder)
        {
            return daProcesOrder.GetProcessOrderUnMatch(barcode, processOrder);
        }

        public bool InsertProcessOrderMatch(string processNo, string barcode, string createBy, string department)
        {
            return daProcesOrder.InsertProcessOrderMatch(processNo, barcode, createBy, department);
        }

        public bool InsertProcessOrderUnMatch(string processNo, string barcode, string createBy, string department)
        {
            return daProcesOrder.InsertProcessOrderUnMatch(processNo, barcode, createBy, department);
        }

        public DataSet GetProcessOrderGR(string processOrder, string btfs, string status, string grStart, string grEnd)
        {
            return daProcesOrder.GetProcessOrderGR(processOrder, btfs, status, grStart, grEnd);
        }

        public bool UpdProcessOrderGR(string poId)
        {
            return daProcesOrder.UpdProcessOrderGR(poId);
        }
    }
}