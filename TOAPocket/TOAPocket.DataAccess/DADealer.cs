using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

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

    }
}