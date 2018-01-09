using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLNews
    {
        DANews daNews = new DANews();

        public DataSet GetNews(string newsName, string newsStartDate, string newsEndDate, string userType, string status)
        {
            return daNews.GetNews(newsName, newsStartDate, newsEndDate, userType, status);
        }
        
        public DataSet GetRefRunningNo()
        {
            return daNews.GetRefRunningNo();
        }
    }
}