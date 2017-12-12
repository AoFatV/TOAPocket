using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLRoles
    {
        DARoles daRoles = new DARoles();
        public DataSet GetRoles(String Condition)
        {
            return daRoles.GetRoles(Condition);
        }
    }
}