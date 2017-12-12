using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Security;
using System.Web.SessionState;

namespace TOAPocket.UI.Web
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            BundleTable.Bundles.Add(new StyleBundle("~/content/adminlte").IncludeDirectory("~/admin-lte/css", "*.min.css"));

            BundleTable.Bundles.Add(new StyleBundle("~/content/css").IncludeDirectory("~/content", "*.min.css"));

            BundleTable.Bundles.Add(new ScriptBundle("~/scripts/adminlte").Include(
                "~/Scripts/jquery-3.1.1.min.js", "~/admin-lte/js/adminlte.min.js"
            ));

            BundleTable.EnableOptimizations = true;
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}