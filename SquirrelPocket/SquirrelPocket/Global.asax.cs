using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace AllTrustUs.SquirrelPocket
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

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
            //Exception ex = this.Context.Server.GetLastError();
            //if (ex != null)
            //{
            //    Log.Error(this.GetType().ToString(), "Application_Error:" + HttpContext.Current.Request.Url.PathAndQuery+"</br>" + ex.Message + ";" + ex.Source + ";" + ex.StackTrace);
            //    EmailHelper eh = new EmailHelper();
            //    eh.SendMail("Squirel Application Exception", HttpContext.Current.Request.Url.PathAndQuery + "</br>" 
            //        + ex.Message + "</br>" + ";"
            //        + ex.Source + "</br>" + ";" 
            //        + ex.StackTrace);
            //    this.Context.Server.ClearError();
            //    this.Context.Response.Redirect("~/Error.aspx?ActionPage=" + Server.UrlEncode(HttpContext.Current.Request.Url.PathAndQuery), true);
            //}

            Exception ex = this.Context.Server.GetLastError();
            if (ex != null)
            {
                Log.Error(this.GetType().ToString(), "Application_Error:" + HttpContext.Current.Request.Url.PathAndQuery+"</br>" + ex.Message + ";" + ex.Source + ";" + ex.StackTrace);
                Session["LastException"] = ex;
                this.Context.Server.ClearError();
                //this.Context.Response.Redirect("~/Error.aspx", true);
            }

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}