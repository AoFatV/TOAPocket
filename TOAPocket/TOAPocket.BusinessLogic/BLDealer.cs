using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLDealer
    {
        DADealer daDealer = new DADealer();

        public DataSet GetDealer(string search)
        {
            return daDealer.GetDealer(search);
        }

    }
}