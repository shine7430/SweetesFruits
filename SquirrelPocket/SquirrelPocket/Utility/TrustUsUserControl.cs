using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace AllTrustUs.SquirrelPocket.Utility
{
    public class TrustUsUserControl : UserControl
    {
        public string CurrentOpenid
        {
            get
            {
                return this.CurrentWeXUser.openid;
            }
        }

        public WeXUser CurrentWeXUser
        {
            get
            {
                if (Session["CurrentWeXUser"] is WeXUser)
                {
                    return (WeXUser)Session["CurrentWeXUser"];
                }
                else
                {
                    Log.Info("Get CurrentWeXUser", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));
                    //WeXUser wu = new WeXUser();
                    //wu.openid = "okou5v6zJqXG1dSta-IjgTmxQ-dE";
                    //wu.MP = "15221336036";
                    //wu.discount = "1";
                    //Session["CurrentWeXUser"] = wu;
                    //return wu;
                    Response.Redirect("~/AuthorizationCheck.aspx?flag=timeout&ActionPage=" + Server.UrlEncode(HttpContext.Current.Request.Url.PathAndQuery));
                    return null;
                }
            }
            set
            {
                Session["CurrentWeXUser"] = value;
            }
        }
    }
}