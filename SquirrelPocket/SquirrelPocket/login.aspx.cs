using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using LitJson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket
{
    public partial class login : TrustUsPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["code"]))
                {
                    //获取code码，以获取openid和access_token
                    string code = Request.QueryString["code"];
                    Log.Debug(this.GetType().ToString(), "Get code : " + code);
                    GetOpenidAndAccessTokenFromCode(code);
                }
                else
                {
                    //构造网页授权获取code的URL
                    string host = Request.Url.Host;
                    string path = Request.Path;
                    string redirect_uri = HttpUtility.UrlEncode("http://" + host + path);
                    WxPayData data = new WxPayData();
                    data.SetValue("appid", WxPayConfig.APPID);
                    data.SetValue("redirect_uri", redirect_uri);
                    data.SetValue("response_type", "code");
                    data.SetValue("scope", "snsapi_userinfo");
                    data.SetValue("state", "STATE" + "#wechat_redirect");
                    string url = "https://open.weixin.qq.com/connect/oauth2/authorize?" + data.ToUrl();
                    Log.Debug(this.GetType().ToString(), "Will Redirect to URL : " + url);
                    try
                    {
                        //触发微信返回code码         
                        Response.Redirect(url);//Redirect函数会抛出ThreadAbortException异常，不用处理这个异常
                    }
                    catch (System.Threading.ThreadAbortException ex)
                    {
                    }
                }



            }
        }

        public void GetOpenidAndAccessTokenFromCode(string code)
        {
            try
            {
                //构造获取openid及access_token的url
                WxPayData data = new WxPayData();
                data.SetValue("appid", WxPayConfig.APPID);
                data.SetValue("secret", WxPayConfig.APPSECRET);
                data.SetValue("code", code);
                data.SetValue("grant_type", "authorization_code");
                string url = "https://api.weixin.qq.com/sns/oauth2/access_token?" + data.ToUrl();
                //string url = "https://api.weixin.qq.com/sns/oauth2/userinfo?" + data.ToUrl();
                Log.Debug(this.GetType().ToString(), "GetOpenidAndAccessTokenFromCode url : " + url);
                //请求url以获取数据
                string result = HttpService.Get(url);

                Log.Debug(this.GetType().ToString(), "GetOpenidAndAccessTokenFromCode response : " + result);

                //保存access_token，用于收货地址获取
                JsonData jd = JsonMapper.ToObject(result);
                var access_token = (string)jd["access_token"];
                //Response.Write(result);

                //获取用户openid
                var openid = (string)jd["openid"];
                WxPayData dataUserInfo = new WxPayData();
                dataUserInfo.SetValue("access_token", access_token);
                dataUserInfo.SetValue("openid", openid);
                dataUserInfo.SetValue("lang", "zh_CN");

                url = "https://api.weixin.qq.com/sns/userinfo?" + dataUserInfo.ToUrl();
                result = HttpService.Get(url);
                FormatWeXUser(result);
                Log.Info("Successful login", "=========" + result);

                Log.Info("Successful login", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

                Response.Redirect("GifCardTake.aspx?Openid='" + openid + "'", false);                
                //Response.Write(result);

                //Log.Debug(this.GetType().ToString(), "Get openid : " + openid);
                //Log.Debug(this.GetType().ToString(), "Get access_token : " + access_token);
            }
            catch (Exception ex)
            {
                Log.Error(this.GetType().ToString(), ex.ToString());
                throw new WxPayException(ex.ToString());
            }
        }

        private void FormatWeXUser(string JsonData)
        {
            var WeXUserDic = JsonUtility.ToDictionary(JsonData);

//            string insjson = @"insert into t_user(openid,nickname,headimgurl,country,province,city,sex,createddate,lastlogindate) 
//                            values({0},{1},{2},{3},{4},{5},{6},{7},{8});";
//            insjson = string.Format(insjson,
//                UtilityFn.formatstring(WeXUserDic["openid"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["nickname"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["headimgurl"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["country"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["province"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["city"].ToString()),
//                UtilityFn.formatstring(WeXUserDic["sex"].ToString()),
//                UtilityFn.formatstring(DateTime.Now.ToString("yyyy/MM/dd HH:mm")),
//                UtilityFn.formatstring(DateTime.Now.ToString("yyyy/MM/dd HH:mm"))
//                 );
//            MySqlHelp.ExecuteNonQuery(insjson);

            WeXUser WU = new WeXUser();
            WU.sex = WeXUserDic["sex"].ToString();
            WU.openid = WeXUserDic["openid"].ToString();
            WU.nickname = WeXUserDic["nickname"].ToString();
            WU.headimgurl = WeXUserDic["headimgurl"].ToString();
            WU.country = WeXUserDic["country"].ToString();
            WU.province = WeXUserDic["province"].ToString();
            WU.city = WeXUserDic["city"].ToString();
            WU.agencylevel = "L-1";
            WU.discount = "1";
            this.CurrentWeXUser = WU;
        }
    }
}