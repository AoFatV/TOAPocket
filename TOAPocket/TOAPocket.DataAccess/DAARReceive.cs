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
    public class DAArWhReceive : DBHelper
    {
        public DataSet GetSaleRedeem(string search)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetSaleRedeem";
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

        public bool InsertWhRedeemQty(string saleId, string saleReturn20Qty, string whReturn20Qty, string saleReturn30Qty, string whReturn30Qty, string saleReturn60Qty, string whReturn60Qty, string totalLostReturnQty, string createBy)
        {
            bool result = true;
            DataSet ds = new DataSet();

            SqlDatabase db = new SqlDatabase(_ConnString);
            DbCommand sqlCmd = db.GetStoredProcCommand("sp_EP_InsWHRedeemQty");

            try
            {
                db.AddInParameter(sqlCmd, "@SaleId", SqlDbType.NVarChar, saleId);
                db.AddInParameter(sqlCmd, "@SaleReturn20Qty", SqlDbType.Int, saleReturn20Qty);
                db.AddInParameter(sqlCmd, "@WhReturn20Qty", SqlDbType.Int, whReturn20Qty);
                db.AddInParameter(sqlCmd, "@SaleReturn30Qty", SqlDbType.Int, saleReturn30Qty);
                db.AddInParameter(sqlCmd, "@WhReturn30Qty", SqlDbType.Int, whReturn30Qty);
                db.AddInParameter(sqlCmd, "@SaleReturn60Qty", SqlDbType.Int, saleReturn60Qty);
                db.AddInParameter(sqlCmd, "@WhReturn60Qty", SqlDbType.Int, whReturn60Qty);
                db.AddInParameter(sqlCmd, "@LostReturnTotalQty", SqlDbType.Int, totalLostReturnQty);
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