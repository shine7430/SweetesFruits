using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace AllTrustUs.SquirrelPocket.Utility
{
    public class TrustUsPage : Page
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
                    //Response.Redirect("~/login.aspx?flag=timeout&ActionPage=" + Server.UrlEncode(HttpContext.Current.Request.Url.PathAndQuery));
                    Response.Redirect("~/login.aspx");
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