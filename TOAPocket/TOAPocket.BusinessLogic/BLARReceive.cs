using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLArWhReceive
    {
        DAArWhReceive daArWhReceive = new DAArWhReceive();

        public DataSet GetSaleRedeem(string search)
        {
            return daArWhReceive.GetSaleRedeem(search);
        }

        public bool InsertWhRedeemQty(string saleId, string saleReturn20Qty, string whReturn20Qty, string saleReturn30Qty, string whReturn30Qty, string saleReturn60Qty, string whReturn60Qty, string totalLostReturnQty, string createBy)
        {
            return daArWhReceive.InsertWhRedeemQty(saleId, saleReturn20Qty, whReturn20Qty, saleReturn30Qty, whReturn30Qty, saleReturn60Qty, whReturn60Qty, totalLostReturnQty, createBy);
        }
    }
}