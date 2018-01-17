using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace TOAPocket.DataAccess
{
    public class DAProcessOrder : DBHelper
    {
        public DataSet GetProcessOrder(string processOrder)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetProcessOrder";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("ProcessOrder", SqlDbType.VarChar));
                Command.Parameters["ProcessOrder"].Value = processOrder;

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

        public DataSet GetProcessOrderMatch(string barcode, string processOrder)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetProcessOrderMatch";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("Barcode", SqlDbType.VarChar));
                Command.Parameters["Barcode"].Value = barcode;
                Command.Parameters.Add(new SqlParameter("ProcessOrder", SqlDbType.VarChar));
                Command.Parameters["ProcessOrder"].Value = processOrder;

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

        public bool InsertProcessOrderMatch(string processNo, string barcode, string createBy, string department)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("sp_EP_InsProcessOrderMatch");

            try
            {
                db.AddInParameter(sqlCmd, "@ProcessNo", SqlDbType.NVarChar, processNo);
                db.AddInParameter(sqlCmd, "@Barcode", SqlDbType.NVarChar, barcode);
                db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);
                db.AddInParameter(sqlCmd, "@DepartmentBy", SqlDbType.NVarChar, department);

                db.ExecuteNonQuery(sqlCmd);
            }
            catch (Exception ex)
            {
                result = false;
            }
            finally
            {
                sqlCmd.Dispose();
            }

            return result;
        }
    }
}