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

        public DataSet GetBarcodeByPO(string po)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeByPO";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(po))
                {
                    Command.Parameters.Add(new SqlParameter("PONo", SqlDbType.VarChar));
                    Command.Parameters["PONo"].Value = String.IsNullOrEmpty(po.Trim()) ? (object)DBNull.Value : po;
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

        public bool UpdateBarcodeByPO(string po, string department, string updateBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spUPDBarcodeByPO");

            try
            {
                db.AddInParameter(sqlCmd, "@PONo", SqlDbType.NVarChar, po);
                db.AddInParameter(sqlCmd, "@Department", SqlDbType.NVarChar, department);
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

        public DataSet GetBarcodeByBarcode(string po, string barcodeStart, string barcodeEnd)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeByBarcode";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("PONo", SqlDbType.VarChar));
                Command.Parameters["PONo"].Value = String.IsNullOrEmpty(po.Trim()) ? (object)DBNull.Value : po;
                Command.Parameters.Add(new SqlParameter("BCStart", SqlDbType.VarChar));
                Command.Parameters["BCStart"].Value = String.IsNullOrEmpty(barcodeStart.Trim()) ? (object)DBNull.Value : barcodeStart;
                Command.Parameters.Add(new SqlParameter("BCEnd", SqlDbType.VarChar));
                Command.Parameters["BCEnd"].Value = String.IsNullOrEmpty(barcodeEnd.Trim()) ? (object)DBNull.Value : barcodeEnd;

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

        public bool UpdateBarcodeByBarcode(string barcodeId, string department, string updateBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spUPDBarcodeByBarcode");

            try
            {
                db.AddInParameter(sqlCmd, "@BarcodeId", SqlDbType.NVarChar, barcodeId);
                db.AddInParameter(sqlCmd, "@Department", SqlDbType.NVarChar, department);
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

        public DataSet GetTrRunningNo()
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeTransferRunningNo";
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

        public bool InsertBarcodeTransfer(string trNo, string fromDept, string toDept, string startBar, string endBar, string qty, string transDate, string createBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spInsBarcodeTransfer");

            try
            {
                db.AddInParameter(sqlCmd, "@trNo", SqlDbType.NVarChar, trNo);
                db.AddInParameter(sqlCmd, "@fromDept", SqlDbType.NVarChar, fromDept);
                db.AddInParameter(sqlCmd, "@toDept", SqlDbType.NVarChar, toDept);
                db.AddInParameter(sqlCmd, "@startBar", SqlDbType.NVarChar, startBar);
                db.AddInParameter(sqlCmd, "@endBar", SqlDbType.NVarChar, endBar);
                db.AddInParameter(sqlCmd, "@qty", SqlDbType.NVarChar, qty);
                db.AddInParameter(sqlCmd, "@transDate", SqlDbType.NVarChar, transDate);
                db.AddInParameter(sqlCmd, "@createBy", SqlDbType.NVarChar, createBy);

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

        public DataSet GetBarcodeTransfer(string department, string trNo, string fromDept, string toDept, string barcodeStart, string barcodeEnd, string dateStart, string dateEnd, string status)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeTransfer";
                Command.Parameters.Clear();

                Command.Parameters.Add(new SqlParameter("Department", SqlDbType.VarChar));
                Command.Parameters["Department"].Value = String.IsNullOrEmpty(department) ? (object)DBNull.Value : department;
                Command.Parameters.Add(new SqlParameter("TrNO", SqlDbType.VarChar));
                Command.Parameters["TrNO"].Value = String.IsNullOrEmpty(trNo) ? (object)DBNull.Value : trNo;
                Command.Parameters.Add(new SqlParameter("FromDept", SqlDbType.VarChar));
                Command.Parameters["FromDept"].Value = String.IsNullOrEmpty(fromDept) ? (object)DBNull.Value : fromDept;
                Command.Parameters.Add(new SqlParameter("ToDept", SqlDbType.VarChar));
                Command.Parameters["ToDept"].Value = String.IsNullOrEmpty(toDept) ? (object)DBNull.Value : toDept;
                Command.Parameters.Add(new SqlParameter("BarcodeStart", SqlDbType.VarChar));
                Command.Parameters["BarcodeStart"].Value = String.IsNullOrEmpty(barcodeStart) ? (object)DBNull.Value : barcodeStart;
                Command.Parameters.Add(new SqlParameter("BarcodeEnd", SqlDbType.VarChar));
                Command.Parameters["BarcodeEnd"].Value = String.IsNullOrEmpty(barcodeEnd) ? (object)DBNull.Value : barcodeEnd;
                Command.Parameters.Add(new SqlParameter("DateStart", SqlDbType.VarChar));
                Command.Parameters["DateStart"].Value = String.IsNullOrEmpty(dateStart) ? (object)DBNull.Value : dateStart;
                Command.Parameters.Add(new SqlParameter("DateEnd", SqlDbType.VarChar));
                Command.Parameters["DateEnd"].Value = String.IsNullOrEmpty(dateEnd) ? (object)DBNull.Value : dateEnd;
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

        public bool UpdateBarcodeTransfer(string trNo, string updateBy, string status, string remark)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spUpdBarcodeTransfer");

            try
            {
                db.AddInParameter(sqlCmd, "@trNo", SqlDbType.NVarChar, trNo);
                db.AddInParameter(sqlCmd, "@updateBy", SqlDbType.NVarChar, updateBy);
                db.AddInParameter(sqlCmd, "@status", SqlDbType.NVarChar, status);
                db.AddInParameter(sqlCmd, "@remark", SqlDbType.NVarChar, remark);

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

        public bool InsertBarcodeVoidDamage(string barcode, string createBy, string department)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spInsBarcodeVoidDamage");

            try
            {
                db.AddInParameter(sqlCmd, "@Barcode", SqlDbType.NVarChar, barcode);
                db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);
                db.AddInParameter(sqlCmd, "@Department", SqlDbType.NVarChar, department);

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

        public DataSet GetBarcodeVoidDamage(string barcode)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeVoidDamage";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(barcode))
                {
                    Command.Parameters.Add(new SqlParameter("Barcode", SqlDbType.VarChar));
                    Command.Parameters["Barcode"].Value = barcode;
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

        public bool InsertBarcodeVoidReturn(string barcode, string createBy, string department)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spInsBarcodeVoidReturn");

            try
            {
                db.AddInParameter(sqlCmd, "@Barcode", SqlDbType.NVarChar, barcode);
                db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);
                db.AddInParameter(sqlCmd, "@Department", SqlDbType.NVarChar, department);

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

        public DataSet GetBarcodeVoidReturn(string barcode)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeVoidReturn";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(barcode))
                {
                    Command.Parameters.Add(new SqlParameter("Barcode", SqlDbType.VarChar));
                    Command.Parameters["Barcode"].Value = barcode;
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

        public bool InsertBarcodeVoidTintOneShot(string barcode, string createBy, string department)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("spInsBarcodeVoidTintOneShot");

            try
            {
                db.AddInParameter(sqlCmd, "@Barcode", SqlDbType.NVarChar, barcode);
                db.AddInParameter(sqlCmd, "@CreateBy", SqlDbType.NVarChar, createBy);
                db.AddInParameter(sqlCmd, "@Department", SqlDbType.NVarChar, department);

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

        public DataSet GetBarcodeVoidTintOneShot(string barcode)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "spGetBarcodeVoidTintOneShot";
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(barcode))
                {
                    Command.Parameters.Add(new SqlParameter("Barcode", SqlDbType.VarChar));
                    Command.Parameters["Barcode"].Value = barcode;
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