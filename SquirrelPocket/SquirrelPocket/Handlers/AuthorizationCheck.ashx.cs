using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for AuthorizationCheck
    /// </summary>
    public class AuthorizationCheck : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Charset = "utf-8";
            context.Response.AddHeader("Access-Control-Allow-Origin", "*");

            var ActionPage = context.Request.QueryString["ActionPage"];

            //Log.Info("Check AuthorizationCheck Begin", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

            //构造网页授权获取code的URL
            string host = context.Request.Url.Host;
            string redirect_uri = HttpUtility.UrlEncode("http://" + host + "/Handlers/AuthorizationCheckByCodeHandler.ashx?ActionPage=" + ActionPage);
            WxPayData data = new WxPayData();
            data.SetValue("appid", WxPayConfig.APPID);
            data.SetValue("redirect_uri", redirect_uri);
            data.SetValue("response_type", "code");
            data.SetValue("scope", "snsapi_base");
            data.SetValue("state", "STATE" + "#wechat_redirect");
            string url = "https://open.weixin.qq.com/connect/oauth2/authorize?" + data.ToUrl();
            //HttpService.Get(url);
            context.Response.Redirect(url);
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