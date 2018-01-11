using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace TOAPocket.UI.Web.Common
{
    public class Utility
    {
        public string DataTableToJSONWithJavaScriptSerializer(DataTable table)
        {
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
            Dictionary<string, object> childRow;
            foreach (DataRow row in table.Rows)
            {
                childRow = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    childRow.Add(col.ColumnName, row[col]);
                }
                parentRow.Add(childRow);
            }
            return jsSerializer.Serialize(parentRow);
        }

        public byte[] GetImageDate(string Path, string FileName)
        {
            byte[] data = null;
            try
            {

            }
            catch (Exception ex)
            {

            }

            return data;
        }

        public string MatchPageMenu(string page, string[] menu)
        {
            bool match = false;

            foreach (var m in menu)
            {
                if (page.ToLower().Equals(m.ToLower()))
                {
                    match = true;
                }
            }

            if (match) return "active";
            return "";

        }
    }
}