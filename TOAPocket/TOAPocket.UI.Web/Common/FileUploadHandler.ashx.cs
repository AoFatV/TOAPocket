using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TOAPocket.UI.Web.Common
{
    /// <summary>
    /// Summary description for FileUploadHandler
    /// </summary>
    public class FileUploadHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                if (context.Request.Files.Count > 0)
                {
                    HttpFileCollection files = context.Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                        HttpPostedFile file = files[i];
                        string extension = System.IO.Path.GetExtension(file.FileName);
                        //string fname = context.Server.MapPath("~/Uploads/Thumbnail/" + "TmpThumbnail" + extension);
                        string fname = context.Server.MapPath("~/Uploads/Thumbnail/" + file.FileName);
                        file.SaveAs(fname);
                    }
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("File Uploaded Successfully!");
                }
            }
            catch (Exception ex)
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write(ex.Message);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}