using System.Configuration;

namespace TOAPocket.DataAccess.BaseClasses
{
    public class DbQRCodeInfo : DbDalBase
    {
        string _DB_QRCODE = "db_dealer_connect";
        string _ConnStr;
        public DbQRCodeInfo()
        {
            _ConnStr = ConfigurationManager.ConnectionStrings[_DB_QRCODE].ConnectionString;
        }

        public string ConnectionString()
        {
            return _ConnStr;
        }

        public string ServerName()
        {
            return GetPropertyInConnectionString(_ConnStr, ConnStrProperties.DataSource);

        }

        public string DatabaseName()
        {

            return GetPropertyInConnectionString(_ConnStr, ConnStrProperties.InitialCatalog);

        }

        public string UserID()
        {

            return GetPropertyInConnectionString(_ConnStr, ConnStrProperties.UserID);

        }

        public string Password()
        {

            return GetPropertyInConnectionString(_ConnStr, ConnStrProperties.Password);

        }

        public string CatalogLibraryList()
        {

            return GetPropertyInConnectionString(_ConnStr, ConnStrProperties.CatalogLibraryList);

        }
    }
}
