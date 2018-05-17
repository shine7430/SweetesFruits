using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using LitJson;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket
{
    public partial class AuthorizationCheck : TrustUsPage
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
                    var ActionPage = Request.QueryString["ActionPage"];

                    Log.Info("Check AuthorizationCheck Begin", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

                    //构造网页授权获取code的URL
                    string host = Request.Url.Host;
                    string path = Request.Path;
                    string redirect_uri = HttpUtility.UrlEncode("http://" + host + path + "?ActionPage=" + ActionPage);
                    WxPayData data = new WxPayData();
                    data.SetValue("appid", WxPayConfig.APPID);
                    data.SetValue("redirect_uri", redirect_uri);
                    data.SetValue("response_type", "code");
                    data.SetValue("scope", "snsapi_base");
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
                Response.Redirect("GifCardTake.aspx?Openid='" + openid + "'", false);

//                DataTable checkuserDT = MySqlHelp.ExecuteDataTable(@"select tu.*
//,
//CASE
//WHEN  la.agencylevel is null THEN 'L-1'
//ELSE la.agencylevel
//END as 'agencylevel',
//CASE
//WHEN  la.agencylevel is null THEN '1'
//ELSE la.discount
//END as 'discount'
//from t_user tu
//left join t_agencylevel la
//on tu.id=la.userid and la.enabled='1'
//where tu.openid=" + UtilityFn.formatstring(openid));

//                //数据库里是否有用户信息
//                if (checkuserDT.Rows.Count > 0)
//                {
//                    if (FormatWeXUser(checkuserDT))
//                    {
//                        var ActionPage = Request.QueryString["ActionPage"];
//                        if (!string.IsNullOrEmpty(ActionPage))
//                        {
//                            Response.Redirect(ActionPage, false);
//                        }
//                        else
//                        {
//                            Response.Redirect("home.aspx", false);
//                        }
                        
//                    }
//                    else
//                    {
//                        Response.Redirect("/Order/MyInfoPage.aspx", false);
//                    }
//                    Log.Info("Get User End", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

//                    //Response.Redirect("home.aspx", false);
//                }
//                else
//                {
//                    Log.Info("First login", "=========" + DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"));

//                    Response.Redirect("login.aspx", false);
//                }


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

        private bool FormatWeXUser(DataTable UserDT)
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
            this.CurrentWeXUser = WU;
            if (string.IsNullOrEmpty(WU.MP))
            {
                //没有绑定手机号
                return false;
            }
            return true;
        }

    }
}