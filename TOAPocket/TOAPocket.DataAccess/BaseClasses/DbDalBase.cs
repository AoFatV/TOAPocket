using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;

namespace TOAPocket.DataAccess.BaseClasses
{
    public class DbDalBase
    {
        public enum ConnStrProperties
        {
            DataSource,
            InitialCatalog,
            UserID,
            Password,
            Dsn,
            Uid,
            CatalogLibraryList
        }

        public string GetPropertyInConnectionString(string connstr, ConnStrProperties PropertyName)
        {
            //Hashtable ht = new Hashtable();
            Dictionary<string, string> dict = new Dictionary<string, string>();
            string[] arrProperty;
            string retValue;
            arrProperty = connstr.Split(';');
            foreach (string aProperty in arrProperty)
            {
                string[] arrPart;
                arrPart = aProperty.Split('=');
                if ((arrPart.Length > 0))
                {
                    //ht.Add(arrPart[0].ToString().Replace(" ", "").ToUpper(), arrPart[1]);
                    dict.Add(arrPart[0].ToString().Replace(" ", "").ToUpper(), arrPart[1]);
                }

            }

            if ((dict.Count > 0))
            {
                //retValue = ht.Item[Enum.GetName(typeof(ConnStrProperties), PropertyName).ToUpper()];
                retValue = dict[Enum.GetName(typeof(ConnStrProperties), PropertyName).ToUpper()];
            }
            else
            {
                retValue = "";
            }

            return retValue;
        }


        public string GetDecryptedConnectionString(string ConnectionStringName)
        {
            string EncryptedConnStr = "";
            try
            {
                // Get from web.config
                EncryptedConnStr = ConfigurationManager.ConnectionStrings[ConnectionStringName].ToString();
            }
            catch (Exception ex1)
            {
                try
                {
                    // Get from app.config
                    EncryptedConnStr = ConfigurationManager.AppSettings[ConnectionStringName];
                }
                catch (Exception ex2)
                {
                }

            }

            BaseClasses.Encryption encryto = new BaseClasses.Encryption();
            return encryto.DecryptConnectionString(EncryptedConnStr);
        }
    }
}