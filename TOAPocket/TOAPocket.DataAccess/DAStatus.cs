using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace TOAPocket.DataAccess
{
    public class DAStatus : DBHelper
    {
        public DataSet GetStatus(string condition)
        {
            DataSet ds = new DataSet();
            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = "sp_EP_GetStatus";
                Command.Parameters.Clear();
                
                Command.Parameters.Add(new SqlParameter("Condition", SqlDbType.VarChar));
                Command.Parameters["Condition"].Value = String.IsNullOrEmpty(condition) ? (object)DBNull.Value : condition;
                
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