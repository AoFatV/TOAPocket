﻿using System;
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
    public class DABarcode : DBHelper
    {
        public bool InsertBarcodeToTemp(DataTable dt, string createBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            foreach (DataRow dr in dt.Rows)
            {
                SqlDatabase db = new SqlDatabase(_ConnString);
                DbCommand sqlCmd = db.GetStoredProcCommand("spINSBarcodeTmp");

                try
                {

                    db.AddInParameter(sqlCmd, "@PONo", SqlDbType.NVarChar, dr[0]);
                    db.AddInParameter(sqlCmd, "@QrCode", SqlDbType.NVarChar, dr[1]);
                    db.AddInParameter(sqlCmd, "@Barcode", SqlDbType.NVarChar, dr[2]);
                    db.AddInParameter(sqlCmd, "@Remark", SqlDbType.NVarChar, DBNull.Value);
                    db.AddInParameter(sqlCmd, "@Status", SqlDbType.NVarChar, DBNull.Value);
                    db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);
                    //db.AddOutParameter(sqlCmd, "@ID", SqlDbType.Int, 10);

                    db.ExecuteNonQuery(sqlCmd);
                    sqlCmd.Dispose();

                    //id = sqlCmd.Parameters("@ID").Value.ToString()

                }
                catch (Exception ex)
                {
                    result = false;
                }
                finally
                {
                    sqlCmd.Dispose();
                }
            }

            return result;
        }

        public DataSet GetBarcodeTmp(string condition)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcode";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(condition))
                {
                    Command.Parameters.Add(new SqlParameter("Condition", SqlDbType.VarChar));
                    Command.Parameters["Condition"].Value = condition;
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

        public DataSet InsertBarcode(string createBy, string department)
        {
            bool result = true;
            DataSet ds = new DataSet();

            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spINSBarcode";
                Command.Parameters.Clear();

                //if (!String.IsNullOrEmpty(createBy) && !String.IsNullOrEmpty(department))
                //{
                Command.Parameters.Add(new SqlParameter("CreateBy", SqlDbType.VarChar));
                Command.Parameters["CreateBy"].Value = createBy;
                Command.Parameters.Add(new SqlParameter("Department", SqlDbType.VarChar));
                Command.Parameters["Department"].Value = department;
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

        public bool ClearBarcodeTemp(string createBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spDELBarcodeTmp");

            try
            {
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