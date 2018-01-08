using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLUser
    {
        DAUser daUser = new DAUser();
        public DataSet GetUser(String userName, string password)
        {
            return daUser.ValidateUser(userName, password);
        }

        public DataSet GetUserType()
        {
            return daUser.GetUserType();
        }
    }
}