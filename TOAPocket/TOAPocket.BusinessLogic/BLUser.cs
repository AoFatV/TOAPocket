﻿using System;
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
        public DataSet GetUser(String userName)
        {
            return daUser.ValidateUser(userName);
        }
    }
}