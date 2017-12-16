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
            BundleTable.Bundles.Add(new ScriptBundle("~/scripts/jquery").Include(
                "~/Scripts/jquery-3.1.1.min.js"));

            BundleTable.Bundles.Add(new ScriptBundle("~/scripts/adminlte").Include(
                "~/admin-lte/js/adminlte.min.js",
                "~/admin-lte/js/demo.js",
                "~/Scripts/bower_components/datatables.net/js/jquery.dataTables.min.js",
                "~/Scripts/bower_components/datatables.net-bs/js/dataTables.bootstrap.min.js",
                "~/Scripts/bower_components/fastclick/lib/fastclick.js",
                "~/Scripts/bower_components/bootstrap/dist/js/bootstrap.min.js",
                "~/Scripts/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"
            ));

            BundleTable.Bundles.Add(new StyleBundle("~/content/adminlte").IncludeDirectory("~/admin-lte/css", "*.min.css"));

            BundleTable.Bundles.Add(new StyleBundle("~/content/css").IncludeDirectory("~/content", "*.min.css"));

            BundleTable.Bundles.Add(new StyleBundle("~/content/datatable").
                IncludeDirectory("~/Scripts/bower_components/datatables.net-bs/css", "*.min.css"));

            BundleTable.Bundles.Add(new StyleBundle("~/content/datepicker").
                IncludeDirectory("~/Scripts/bower_components/bootstrap-datepicker/dist/css", "*.min.css"));

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