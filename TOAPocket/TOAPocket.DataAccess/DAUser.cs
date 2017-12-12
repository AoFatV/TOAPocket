using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using TOAPocket.DataAccess.BaseClasses;
//using TOAPocket.DataAccess.Models;

namespace TOAPocket.DataAccess
{
    public class DAUser : DBHelper
    {
        public DataSet ValidateUser(string userName)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetInformationUser";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(userName))
                {
                    Command.Parameters.Add(new SqlParameter("UserName", SqlDbType.VarChar));
                    Command.Parameters["UserName"].Value = userName;
                }

                Command.CommandTimeout = 0;
                if (Transaction != null)
                {
                    Command.Transaction = Transaction;
                }

                da = new SqlDataAdapter((SqlCommand)Command);
                da.Fill(ds);
                ds.Dispose();
                CommitTransaction();
            }
            catch (Exception ex)
            {
                RollBackTransaction();
            }
            finally
            {
                CloseCon();
            }

            return ds;
        }

    }
}