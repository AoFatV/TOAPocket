using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Common;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace TOAPocket.DataAccess
{
    public class DARoles : DBHelper
    {
        public DataSet GetRoles(String Condition)
        {
            DataSet ds = executeDataTable(Condition, "spLSTRoles");

            return ds;
        }
    }
}