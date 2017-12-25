using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLStatus
    {
        DAStatus daStatus = new DAStatus();

        public DataSet GetStatus(string condition)
        {
            return daStatus.GetStatus(condition);
        }
    }
}