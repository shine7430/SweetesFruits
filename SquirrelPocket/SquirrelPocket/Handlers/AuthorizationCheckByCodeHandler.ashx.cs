using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using LitJson;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for AuthorizationCheckByCodeHandler
    /// </summary>
    public class AuthorizationCheckByCodeHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string code = context.Request.QueryString["code"];
            context.Response.AddHeader("Access-Control-Allow-Origin", "*");

            //context.Response.Write("AuthorizationCheckByCodeHandler:" + code);
            string RedirectPage = "";
            string returnresult = "{\"result:\":\"{0}\",\"RedirectPage\":\"{1}\"}";
            try
            {
                //构造获取openid及access_token的url
                WxPayData data = new WxPayData();
                data.SetValue("appid", WxPayConfig.APPID);
                data.SetValue("secret", WxPayConfig.APPSECRET);
                data.SetValue("code", code);
                data.SetValue("grant_type", "authorization_code");
                string url = "https://api.weixin.qq.com/sns/oauth2/access_token?" + data.ToUrl();
                Log.Debug(this.GetType().ToString(), "GetOpenidAndAccessTokenFromCode url : " + url);
                //请求url以获取数据
                string result = HttpService.Get(url);

                Log.Debug(this.GetType().ToString(), "GetOpenidAndAccessTokenFromCode response : " + result);

                //保存access_token，用于收货地址获取
                JsonData jd = JsonMapper.ToObject(result);
                Log.Debug(this.GetType().ToString(), "GetOpenidAndAccessTokenFromCode Result : " + result);
                var access_token = (string)jd["access_token"];
                //Response.Write(result);

                //获取用户openid
                var openid = (string)jd["openid"];
                WxPayData dataUserInfo = new WxPayData();
                dataUserInfo.SetValue("access_token", access_token);
                dataUserInfo.SetValue("openid", openid);

                DataTable checkuserDT = MySqlHelp.ExecuteDataTable(@"select tu.*
,
CASE
WHEN  la.agencylevel is null THEN 'L0'
ELSE la.agencylevel
END as 'agencylevel',
CASE
WHEN  la.agencylevel is null THEN '1'
ELSE la.discount
END as 'discount'
from t_user tu
left join t_agencylevel la
on tu.id=la.userid and la.enabled='1'
where tu.openid=" + UtilityFn.formatstring(openid));

                //数据库里是否有用户信息
                if (checkuserDT.Rows.Count > 0)
                {
                    if (FormatWeXUser(checkuserDT, context))
                    {
                        var ActionPage = context.Request.QueryString["ActionPage"];
                        if (!string.IsNullOrEmpty(ActionPage))
                        {
                            //Response.Redirect(ActionPage, false);
                            RedirectPage = ActionPage;
                        }
                        else
                        {
                            //Response.Redirect("home.aspx", false);
                            RedirectPage = "home.aspx";
                        }

                    }
                    else
                    {
                        //Response.Redirect("/Order/MyInfoPage.aspx", false);
                        RedirectPage = "/Order/MyInfoPage.aspx";
                    }
                    //Log.Info("Get User End", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

                    //Response.Redirect("home.aspx", false);
                }
                else
                {
                    //Response.Redirect("login.aspx", false);
                    RedirectPage = "login.aspx";
                }


                //Response.Write(result);

                //Log.Debug(this.GetType().ToString(), "Get openid : " + openid);
                //Log.Debug(this.GetType().ToString(), "Get access_token : " + access_token);
                
                context.Response.Write("{\"result:\":\"success\",\"RedirectPage\":\"" + RedirectPage + "\"}");
            }
            catch (Exception ex)
            {
                Log.Error(this.GetType().ToString(), ex.ToString());
                //throw new WxPayException(ex.ToString());
                context.Response.Write("{\"result:\":\"failed\",\"RedirectPage\":\"\"}");
            }
        }


        private bool FormatWeXUser(DataTable UserDT, HttpContext context)
        {
            WeXUser WU = new WeXUser();
            WU.sex = UserDT.Rows[0]["sex"].ToString();
            WU.openid = UserDT.Rows[0]["openid"].ToString();
            WU.nickname = UserDT.Rows[0]["nickname"].ToString();
            WU.headimgurl = UserDT.Rows[0]["headimgurl"].ToString();
            WU.province = UserDT.Rows[0]["province"].ToString();
            WU.country = UserDT.Rows[0]["country"].ToString();
            WU.city = UserDT.Rows[0]["city"].ToString();
            WU.MP = UserDT.Rows[0]["mp"].ToString();
            WU.agencylevel = UserDT.Rows[0]["agencylevel"].ToString();
            WU.discount = UserDT.Rows[0]["discount"].ToString();
            context.Session["CurrentWeXUser"] = WU;
            if (string.IsNullOrEmpty(WU.MP))
            {
                //没有绑定手机号
                return false;
            }
            return true;
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