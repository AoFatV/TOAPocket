using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLDepartment
    {
        DADepartment daDepartment = new DADepartment();

        public DataSet GetDepartment(string condition)
        {
            return daDepartment.GetDepartment(condition);
        }
    }
}