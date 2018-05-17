using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Transactions;
using System.Web;
using System.Web.SessionState;
using YZOpenSDK;

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for OrderHandler
    /// </summary>
    public class GiftCardHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Charset = "utf-8";

            string Action = context.Request["Action"].ToString();

            string result = "{\"result\":\"failed\"}";

            if (!string.IsNullOrEmpty(Action))
            {
                Auth auth = new Token(CurToken); // Auth auth = new Sign("app_id", "app_secret");
                YZClient yzClient = new DefaultYZClient(auth);
                Dictionary<string, object> dict;
                switch (Action)
                {

                    case "getgiftcard":
                        dict = new System.Collections.Generic.Dictionary<string, object>();
                        dict.Add("page_no", 1);
                        dict.Add("page_size", 100);
                        //dict.Add("status", "ON");
                        dict.Add("group_type", "PROMOCODE");
                        result = yzClient.Invoke("youzan.ump.coupon.search", "3.0.0", "POST", dict, null);
                        break;
                    case "giftcardtake":
                        string _openid = context.Request["openid"].ToString();
                        string _mobile = context.Request["mobile"].ToString();
                        string _name = context.Request["name"].ToString();
                        string _cardcode = context.Request["cardcode"].ToString();
                        int _PROMOCODEid;
                        string getsql = "select * from giftcard where giftcardcode = '" + _cardcode + "'";
                        DataTable odDT = MySqlHelp.ExecuteDataTable(getsql);

                        if (odDT.Rows.Count > 0)
                        {
                            if (odDT.Rows[0]["enabled"].ToString() == "0")
                            {
                                result = "{\"response\": {\"issuccess\": 0,\"msg\": \"该礼品卡暂不可用，请联系公司负责人!\"}}";
                            }
                            else if (odDT.Rows[0]["isused"].ToString() == "1")
                            {
                                result = "{\"response\": {\"issuccess\": 0,\"msg\": \"该礼品卡已被领用，不能重复注册!\"}}";
                            }
                            else
                            {
                                try
                                {
                                    _PROMOCODEid = Convert.ToInt32(odDT.Rows[0]["PromoId"]);

                                    dict = new System.Collections.Generic.Dictionary<string, object>();
                                    dict.Add("mobile", _mobile);
                                    dict.Add("coupon_group_id", _PROMOCODEid);

                                    result = yzClient.Invoke("youzan.ump.coupon.take", "3.0.0", "POST", dict, null);

                                    InvokeResponse Response = JsonUtility.Deserialize<InvokeResponse>(result);
                                    if (Response.error_response == null && Response.response != null && Response.response.coupon_type == "PROMOCODE")
                                    {


                                        var updatecard = "update giftcard set isused='1',useddate='" + DateTime.Now.ToString("yyyy-MM-dd") + "',usedmobile='" + _mobile + "',usedopenid='" + _openid + "',usedname='" + _name + "' where giftcardcode='" + _cardcode.Replace("-", "") + "'";
                                        MySqlHelp.ExecuteNonQuery(updatecard);
                                        DataTable dt = MySqlHelp.ExecuteDataTable("select jumpurl from giftcard where giftcardcode='" + _cardcode.Replace("-", "") + "'");
                                        result = "{\"response\": {\"issuccess\": \"1\",\"msg\": \"验证成功!\",\"jumpurl\":\"" + dt.Rows[0]["jumpurl"].ToString() + "\"}}";
                                    }
                                    else
                                    {
                                        result = "{\"response\": {\"issuccess\": \"0\",\"msg\": \"" + Response.error_response.msg + "\"}}";
                                    }

                                }
                                catch (Exception ex)
                                {
                                    result = "{\"response\": {\"issuccess\": 0,\"msg\": \"" + ex.Message + "!\"}}";
                                }
                            }



                        }
                        else
                        {
                            result = "{\"response\": {\"issuccess\": 0,\"msg\": \"礼品卷不存在，请验证礼品卷码是否填写正确!\"}}";
                        }
                        break;
                    case "giftcardtakelist":
                        DataTable dttakelist = MySqlHelp.ExecuteDataTable("select * from giftcard");
                        result = "{\"response\": {\"issuccess\": \"1\",\"msg\": \"验证成功!\",\"giftcardlist\":" + formatgiftcard(dttakelist) + "}}";

                        break;
                    case "cardactive":
                        string _ids1 = context.Request["ids"].ToString();
                        MySqlHelp.ExecuteNonQuery("update giftcard set enabled=1 where id in (" + _ids1 + ")and isused = 0");
                        result = "{\"response\": {\"issuccess\": \"1\",\"msg\": \"验证成功!\"}}";

                        break;
                    case "cardinactive":
                        string _ids2 = context.Request["ids"].ToString();
                        MySqlHelp.ExecuteNonQuery("update giftcard set enabled=0 where id in (" + _ids2 + ") and isused = 0");
                        result = "{\"response\": {\"issuccess\": \"1\",\"msg\": \"验证成功!\"}}";

                        break;
                    default:
                        break;

                }
            }
            context.Response.Write(result);

        }

        string formatgiftcard(DataTable dt)
        {
            string str="";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (str != "")
                {
                    str += ",";
                }
                str += "{";
                str += "\"id\":\"" + dt.Rows[i]["id"].ToString() + "\"";
                str += ",\"giftcardcode\":\"" + dt.Rows[i]["giftcardcode"].ToString() + "\"";
                str += ",\"PromoId\":\"" + dt.Rows[i]["PromoId"].ToString() + "\"";
                str += ",\"generatedate\":\"" + dt.Rows[i]["generatedate"].ToString() + "\"";
                str += ",\"isused\":\"" + dt.Rows[i]["isused"].ToString() + "\"";
                str += ",\"useddate\":\"" + dt.Rows[i]["useddate"].ToString() + "\"";
                str += ",\"forcompany\":\"" + dt.Rows[i]["forcompany"].ToString() + "\"";
                str += ",\"expireddate\":\"" + dt.Rows[i]["expireddate"].ToString() + "\"";
                str += ",\"usedopenid\":\"" + dt.Rows[i]["usedopenid"].ToString() + "\"";
                str += ",\"usedmobile\":\"" + dt.Rows[i]["usedmobile"].ToString() + "\"";
                str += ",\"usedname\":\"" + dt.Rows[i]["usedname"].ToString() + "\"";
                str += ",\"amount\":\"" + dt.Rows[i]["amount"].ToString() + "\"";
                str += ",\"enabled\":\"" + dt.Rows[i]["enabled"].ToString() + "\"";
                str += ",\"jumpurl\":\"" + dt.Rows[i]["jumpurl"].ToString() + "\"";
                str += "}";
            }
            str = "[" + str + "]";
            return str;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public string CurToken
        {
            get
            {
                if (HttpContext.Current.Cache["AccessToken_40161714"] != null)
                {
                    return (string)HttpContext.Current.Cache["AccessToken_40161714"];
                }
                else
                {
                    string url = string.Format("https://open.youzan.com/oauth/token?client_id=2e6259a7d6e91d6875&client_secret=7dc62b1091aff300d4bf6153e7e84b84&grant_type=silent&kdt_id=40161714");
                    AccessToken curToken = AccessTokenRequest(url);
                    var ms = Convert.ToDouble(curToken.expires_in) - 1000;
                    HttpContext.Current.Cache.Insert("AccessToken_40161714", curToken.access_token, null,
                                                     DateTime.Now.Add(System.TimeSpan.FromSeconds(ms)),
                                                     System.TimeSpan.Zero);

                    return curToken.access_token;
                }
            }
        }

        private AccessToken AccessTokenRequest(string queryString)
        {
            var jsonResult = string.Empty;
            try
            {
                jsonResult = HttpService.Get(queryString);
                return JsonUtility.Deserialize<AccessToken>(jsonResult);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message + "\n" + jsonResult + "\n" + queryString);
            }
        }
    }
}