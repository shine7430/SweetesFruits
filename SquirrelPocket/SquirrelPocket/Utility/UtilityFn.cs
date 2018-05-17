using AllTrustUs.SquirrelPocket.Entity;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Utility
{
    public static class UtilityFn
    {

        public static string formatstring(string str)
        {
            return string.IsNullOrEmpty(str) ? "null" : "'" + str.Replace("'", "''").Replace("\\", "\\\\") + "'";
        }
        public static string formatJson(string s)
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < s.Length; i++)
            {
                char c = s.ToCharArray()[i];
                switch (c)
                {
                    case '\"': sb.Append("\\\""); break;
                    case '\\': sb.Append("\\\\"); break;
                    case '/': sb.Append("\\/"); break;
                    case '\b': sb.Append("\\b"); break;
                    case '\f': sb.Append("\\f"); break;
                    case '\n': sb.Append("\\n"); break;
                    case '\r': sb.Append("\\r"); break;
                    case '\t': sb.Append("\\t"); break;
                    default: sb.Append(c); break;
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// 获取微信支付商家订单号
        /// </summary>
        /// <returns></returns>
        public static string GenerateOutTradeNo()
        {
            var ran = new Random();
            return string.Format("{0}{1}{2}", WxPayConfig.MCHID, DateTime.Now.ToString("yyyyMMddHHmmss"), ran.Next(999));
        }

        /// <summary>
        /// unicode转中文（符合js规则的）
        /// </summary>
        /// <returns></returns>
        public static string UnicodeToString(string str)
        {
            string outStr = "";
            Regex reg = new Regex(@"(?i)\\u([0-9a-f]{4})");
            outStr = reg.Replace(str, delegate(Match m1)
            {
                return ((char)Convert.ToInt32(m1.Groups[1].Value, 16)).ToString();
            });
            return outStr;
        }


        public static string JsonToHTMLTable(string JsonStr)
        {
            Dictionary<string, object> Dic = UnicodeToString(JsonStr).ToDictionary();
            var _html = "<table>";

            foreach (var key in Dic)
            {
                _html += "<tr><td>" + key.Key + ":</td><td>" + key.Value + "</td></tr>";           
            }
            _html += "</table>";

            return _html;
        }


        
    }
}