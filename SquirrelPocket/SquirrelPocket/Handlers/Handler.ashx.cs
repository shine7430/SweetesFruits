using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for Handler1
    /// </summary>
    public class Handler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Charset = "utf-8";

            string Action = context.Request["Action"].ToString();
            string info = context.Request["infor"].ToString();
            string result = string.Empty;

            if (!string.IsNullOrEmpty(Action))
            {
                switch (context.Request["Action"].ToString().ToLower())
                {
                    case "order":
                        if (info == null)
                        {
                            result = "{\"result\":\"failed\"}";
                        }
                        else
                        {
                            Dictionary<string, object> dire = JsonUtility.ToDictionary(info);
                            EmailHelper eh = new EmailHelper();
                            string body = "<table>";
                            body += "<tr><td>称呼:</td><td>" + dire["fullname"].ToString() + "</td></tr>";
                            body += "<tr><td>联系电话:</td><td>" + dire["mobile"].ToString() + "</td></tr>";
                            body += "<tr><td>邮箱:</td><td>" + dire["email"].ToString() + "</td></tr>";
                            body += "<tr><td>所在地:</td><td>" + dire["location"].ToString() + "</td></tr>";
                            body += "<tr><td>拼盘方式:</td><td>" + dire["type"].ToString() + "</td></tr>";
                            body += "<tr><td>预计人数:</td><td>" + dire["pcount"].ToString() + "</td></tr>";
                            body += "<tr><td>享用频率:</td><td>" + dire["frequency"].ToString() + "</td></tr>";
                            body += "<tr><td>享用周期:</td><td>" + dire["duration"].ToString() + "</td></tr>";
                            body += "</table>";
                            eh.SendMail("Fresh Fruit New Order Creating-" + dire["fullname"].ToString(), body);
                            result = "{\"result\":\"successed\"}";
                        }
                        break;
                    case "contact":
                        if (info == null)
                        {
                            result = "{\"result\":\"failed\"}";
                        }
                        else
                        {
                            Dictionary<string, object> dire = JsonUtility.ToDictionary(info);
                            EmailHelper eh = new EmailHelper();
                            string body = "<table>";
                            body += "<tr><td>称呼:</td><td>" + dire["fullname"].ToString() + "</td></tr>";
                            body += "<tr><td>主题:</td><td>" + dire["subject"].ToString() + "</td></tr>";
                            body += "<tr><td>电话:</td><td>" + dire["mobile"].ToString() + "</td></tr>";
                            body += "<tr><td>邮箱:</td><td>" + dire["email"].ToString() + "</td></tr>";
                            body += "<tr><td>内容:</td><td>" + dire["content"].ToString() + "</td></tr>";
                            body += "</table>";
                            eh.SendMail("Fresh Fruit Contact Created-" + dire["fullname"].ToString(), body);
                            result = "{\"result\":\"successed\"}";
                        }
                        break;
                    default:
                        break;
                }
            }
            context.Response.Write(result);
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