using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace TOAPocket.DataAccess
{
    public class DANews : DBHelper
    {
        public DataSet GetNews(string newsName, string newsStartDate, string newsEndDate, string userType, string status)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetNews";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("Name", SqlDbType.VarChar));
                Command.Parameters["Name"].Value = String.IsNullOrEmpty(newsName) ? (object)DBNull.Value : newsName;
                Command.Parameters.Add(new SqlParameter("StartDate", SqlDbType.VarChar));
                Command.Parameters["StartDate"].Value = String.IsNullOrEmpty(newsStartDate) ? (object)DBNull.Value : newsStartDate;
                Command.Parameters.Add(new SqlParameter("EndDate", SqlDbType.VarChar));
                Command.Parameters["EndDate"].Value = String.IsNullOrEmpty(newsEndDate) ? (object)DBNull.Value : newsEndDate;
                Command.Parameters.Add(new SqlParameter("UserType", SqlDbType.VarChar));
                Command.Parameters["UserType"].Value = String.IsNullOrEmpty(userType) ? (object)DBNull.Value : userType;
                Command.Parameters.Add(new SqlParameter("Status", SqlDbType.VarChar));
                Command.Parameters["Status"].Value = String.IsNullOrEmpty(status) ? (object)DBNull.Value : status;

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

        public DataSet GetRefRunningNo()
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetNewsRunningNo";
                Command.Parameters.Clear();

                //if (!String.IsNullOrEmpty(condition))
                //{
                //    Command.Parameters.Add(new SqlParameter("Condition", SqlDbType.VarChar));
                //    Command.Parameters["Condition"].Value = condition;
                //}

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

        public bool InsertNews(string refNo, string newsName, string newsStartDate, string newsEndDate, string userType, string status, byte[] imagedate, string createBy, string detail)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("sp_EP_InsNews");

            try
            {
                db.AddInParameter(sqlCmd, "@RefNo", SqlDbType.NVarChar, refNo);
                db.AddInParameter(sqlCmd, "@Name", SqlDbType.NVarChar, newsName);
                db.AddInParameter(sqlCmd, "@StartDate", SqlDbType.NVarChar, newsStartDate);
                db.AddInParameter(sqlCmd, "@EndDate", SqlDbType.NVarChar, String.IsNullOrEmpty(newsEndDate) ? (object)DBNull.Value : newsEndDate);
                db.AddInParameter(sqlCmd, "@UserType", SqlDbType.NVarChar, userType);
                db.AddInParameter(sqlCmd, "@Status", SqlDbType.NVarChar, status);
                db.AddInParameter(sqlCmd, "@Detail", SqlDbType.NVarChar, detail);
                db.AddInParameter(sqlCmd, "@Thumbnail", SqlDbType.VarBinary, imagedate.Length == 0 ? (object)DBNull.Value : imagedate);
                db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);

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