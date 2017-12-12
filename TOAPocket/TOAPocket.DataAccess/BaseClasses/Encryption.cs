using System;

namespace TOAPocket.DataAccess.BaseClasses
{
    public class Encryption
    {
        public string EncryptConnectionString(string connectionString)
        {
            byte[] b = System.Text.ASCIIEncoding.ASCII.GetBytes(connectionString);
            string encryptedConnectionString = Convert.ToBase64String(b);
            return encryptedConnectionString;
        }

        public string DecryptConnectionString(string connectionString)
        {
            byte[] b = Convert.FromBase64String(connectionString);
            string decryptedConnectionString = System.Text.ASCIIEncoding.ASCII.GetString(b);
            return decryptedConnectionString;
        }

        public static string EncryptString(string InputString)
        {
            byte[] b = System.Text.ASCIIEncoding.ASCII.GetBytes(InputString);
            string OutputString = Convert.ToBase64String(b);
            return OutputString;
        }

        public static string DecryptString(string InputString)
        {
            byte[] b = Convert.FromBase64String(InputString);
            string OutputString = System.Text.ASCIIEncoding.ASCII.GetString(b);
            return OutputString;
        }
    }
}