using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace TOAPocket.DataAccess
{
    public class DBHelper : BaseClasses.DbDAL
    {
        public string _ConnString;
        public DbConnection Connection;
        public DbCommand Command;
        public DbTransaction Transaction;
        public SqlDataAdapter da;
        public SqlDatabase db;
        public int timeOut = 3600;

        public DBHelper()
        {
            _ConnString = DB_QRCODE().ConnectionString();
            OpenCon();
        }

        //public void New()
        //{

        //}

        public void OpenCon()
        {
            try
            {
                Connection = new SqlConnection(_ConnString);
                if ((Connection.State == ConnectionState.Open))
                {
                    Connection.Close();
                }

                Connection.Open();
                if (Command == null)
                {
                    Command = Connection.CreateCommand();
                }

                Command.Connection = Connection;
                Command.CommandType = CommandType.Text;
                Command.CommandTimeout = timeOut;
            }
            catch (Exception ex)
            {

            }
        }

        public void BeginTransaction()
        {
            if (Connection == null)
            {
                OpenCon();
            }
            else
            {
                if ((Connection.State == ConnectionState.Closed))
                {
                    OpenCon();
                }

                Transaction = Connection.BeginTransaction();
                Command.Transaction = Transaction;
            }
        }

        public void RollBackTransaction()
        {
            if (Transaction != null)
            {
                Transaction.Rollback();
                Transaction.Dispose();
            }

            CloseCon();
        }

        public void CommitTransaction()
        {
            if (Transaction != null)
            {
                Transaction.Commit();
                Transaction.Dispose();
            }

            CloseCon();
        }

        public void CloseCon()
        {
            if (Connection != null)
            {
                Connection.Close();
                Connection.Dispose();
            }

            if (Command != null)
            {
                Command.Dispose();
            }
        }

        public DataSet executeDataTable(String Condition, String StoredProcedure)
        {
            DataSet ds = new DataSet();

            try
            {
                BeginTransaction();
                Command = new SqlCommand();
                Command.Connection = Connection;
                Command.CommandType = CommandType.StoredProcedure;
                Command.CommandText = StoredProcedure;
                Command.Parameters.Clear();

                if (!String.IsNullOrEmpty(Condition))
                {
                    Command.Parameters.Add(new SqlParameter("Condition", SqlDbType.VarChar));
                    Command.Parameters["Condition"].Value = Condition;
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