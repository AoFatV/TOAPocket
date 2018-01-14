using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;

namespace TOAPocket.DataAccess
{
    public class DADealer : DBHelper
    {
        public DataSet GetDealer(string search)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetDealer";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("Search", SqlDbType.VarChar));
                Command.Parameters["Search"].Value = String.IsNullOrEmpty(search) ? (object)DBNull.Value : search;

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

        public DataSet GetDealerById(string dealerId)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetDealerById";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("DealerId", SqlDbType.VarChar));
                Command.Parameters["DealerId"].Value = String.IsNullOrEmpty(dealerId) ? (object)DBNull.Value : dealerId;

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

        public bool UpdateDealer(string dealerId, string maxReceive,string updateBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("sp_EP_UpdDealer");

            try
            {
                db.AddInParameter(sqlCmd, "@DealerId", SqlDbType.NVarChar, dealerId);
                db.AddInParameter(sqlCmd, "@MaxReceive", SqlDbType.NVarChar, maxReceive);
                db.AddInParameter(sqlCmd, "@UpdateBy", SqlDbType.NVarChar, updateBy);
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