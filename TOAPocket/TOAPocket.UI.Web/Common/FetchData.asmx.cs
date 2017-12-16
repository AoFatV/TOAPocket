using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using TOAPocket.BusinessLogic;

namespace TOAPocket.UI.Web.Common
{
    /// <summary>
    /// Summary description for FetchData
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class FetchData : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public DataSet GetDepartment(string condition)
        {
            DataSet ds = new DataSet();
            BLDepartment blDepartment = new BLDepartment();
            try
            {
                ds = blDepartment.GetDepartment(condition == "1" ? "DEPT_STATUS = 'T'" : "");
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return ds;
        }
    }
}
