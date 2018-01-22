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
    public class DAPainter : DBHelper
    {
        public DataSet GetPainter(string search)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetPainterBySearch";
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

        public DataSet GetPainterById(string painterNo)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetPainterById";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("PainterNo", SqlDbType.VarChar));
                Command.Parameters["PainterNo"].Value = String.IsNullOrEmpty(painterNo) ? (object)DBNull.Value : painterNo;

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

        public bool UpdatePainter(string painterId, string painterNo, string name, string surname, string mobile,
            string areaCode, string areaDesc, string address, string job, string income, string updateBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("sp_EP_UpdPainter");

            try
            {
                db.AddInParameter(sqlCmd, "@PainterId", SqlDbType.NVarChar, painterId);
                db.AddInParameter(sqlCmd, "@PainterNo", SqlDbType.NVarChar, painterNo);
                db.AddInParameter(sqlCmd, "@Name", SqlDbType.NVarChar, String.IsNullOrEmpty(name) ? (object)DBNull.Value : name);
                db.AddInParameter(sqlCmd, "@Surname", SqlDbType.NVarChar, String.IsNullOrEmpty(surname) ? (object)DBNull.Value : surname);
                db.AddInParameter(sqlCmd, "@Mobile", SqlDbType.NVarChar, String.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                db.AddInParameter(sqlCmd, "@AreaCode", SqlDbType.NVarChar, String.IsNullOrEmpty(areaCode) ? (object)DBNull.Value : areaCode);
                db.AddInParameter(sqlCmd, "@AreaDesc", SqlDbType.NVarChar, String.IsNullOrEmpty(areaDesc) ? (object)DBNull.Value : areaDesc);
                db.AddInParameter(sqlCmd, "@Address", SqlDbType.NVarChar, String.IsNullOrEmpty(address) ? (object)DBNull.Value : address);
                db.AddInParameter(sqlCmd, "@Job", SqlDbType.NVarChar, String.IsNullOrEmpty(job) ? (object)DBNull.Value : job);
                db.AddInParameter(sqlCmd, "@Income", SqlDbType.NVarChar, String.IsNullOrEmpty(income) ? (object)DBNull.Value : income);
                db.AddInParameter(sqlCmd, "@UpdateBy", SqlDbType.NVarChar, String.IsNullOrEmpty(updateBy) ? (object)DBNull.Value : updateBy);
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

        public DataSet GetCustomerArea()
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetCustomerArea";
                Command.Parameters.Clear();

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

        public DataSet GetOccupation()
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetOccupation";
                Command.Parameters.Clear();

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

        public DataSet GetIncome()
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetIncome";
                Command.Parameters.Clear();

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