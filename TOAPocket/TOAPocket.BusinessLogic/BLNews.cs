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

        public DataSet GetNews(string newsName, string newsStartDate, string newsEndDate, string userType, string status, string news)
        {
            return daNews.GetNews(newsName, newsStartDate, newsEndDate, userType, status, news);
        }

        public DataSet GetRefRunningNo()
        {
            return daNews.GetRefRunningNo();
        }

        public bool InsertNews(string refNo, string newsName, string newsStartDate, string newsEndDate, string userType, string status, byte[] imagedate, string createBy, string detail)
        {
            return daNews.InsertNews(refNo, newsName, newsStartDate, newsEndDate, userType, status, imagedate, createBy, detail);
        }

        public bool UpdateNews(string refNo, string newsName, string newsStartDate, string newsEndDate, string userType, string status, byte[] imagedate, string updateBy, string detail)
        {
            return daNews.UpdateNews(refNo, newsName, newsStartDate, newsEndDate, userType, status, imagedate, updateBy, detail);
        }
    }
}