using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket.Utility
{
    /// <summary>
    /// 支付结果通知回调处理类
    /// 负责接收微信支付后台发送的支付结果并对订单有效性进行验证，将验证结果反馈给微信支付后台
    /// </summary>
    public class ResultNotify : Notify
    {
        public ResultNotify(Page page)
            : base(page)
        {
        }

        public override void ProcessNotify()
        {
            WxPayData notifyData = GetNotifyData();

            //检查支付结果中transaction_id是否存在
            if (!notifyData.IsSet("transaction_id"))
            {
                //若transaction_id不存在，则立即返回结果给微信支付后台
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "支付结果中微信订单号不存在");
                Log.Error(this.GetType().ToString(), "The Pay result is error : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }

            string transaction_id = notifyData.GetValue("transaction_id").ToString();
            string out_trade_no = notifyData.GetValue("out_trade_no").ToString();
            MySqlHelp.ExecuteNonQuery("update t_order set transaction_id=" + UtilityFn.formatstring(transaction_id)
                + " where outtradeno=" + UtilityFn.formatstring(out_trade_no));
            Log.Info(this.GetType().ToString(), "update transaction_id success  : " + transaction_id + "/" + out_trade_no);
            //查询订单，判断订单真实性
            if (!QueryOrder(transaction_id))
            {
                //若订单查询失败，则立即返回结果给微信支付后台
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "订单查询失败");
                Log.Error(this.GetType().ToString(), "Order query failure : " + res.ToXml());
                try
                {
                    MySqlHelp.ExecuteNonQuery(@"update t_order set status='PaidQueryFailed',statusid='6'"
                    + " where outtradeno=" + UtilityFn.formatstring(out_trade_no)
                    + " and transaction_id=" + UtilityFn.formatstring(transaction_id));
                }
                catch (Exception ex)
                {
                    Log.Error(this.GetType().ToString(), "status update failure:" + ex.Message);
                }
                page.Response.Write(res.ToXml());
                page.Response.End();
            }
            //查询订单成功
            else
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "SUCCESS");
                res.SetValue("return_msg", "OK");
                Log.Info(this.GetType().ToString(), "order query success : " + res.ToXml());
                try
                {
                    MySqlHelp.ExecuteNonQuery(@"update t_order set status='PaidSuccessed',statusid='2'"
                        + " where outtradeno=" + UtilityFn.formatstring(out_trade_no)
                        + " and transaction_id=" + UtilityFn.formatstring(transaction_id));

                    DataTable dt = MySqlHelp.ExecuteDataTable(@"select * from  t_order"
                        + " where outtradeno=" + UtilityFn.formatstring(out_trade_no)
                        + " and transaction_id=" + UtilityFn.formatstring(transaction_id));
                    EmailHelper eh = new EmailHelper();
                    eh.SendMail("Squirel New Order Payment", UtilityFn.JsonToHTMLTable(JsonUtility.ToJson(dt)));
                    Log.Info(this.GetType().ToString(), "update status success  : " + transaction_id + "/" + out_trade_no);
                }
                catch (Exception ex)
                {
                    Log.Error(this.GetType().ToString(), "status update failure:" + ex.Message);
                }
                page.Response.Write(res.ToXml());
                page.Response.End();
            }
        }

        //查询订单
        private bool QueryOrder(string transaction_id)
        {
            WxPayData req = new WxPayData();
            req.SetValue("transaction_id", transaction_id);
            WxPayData res = WxPayApi.OrderQuery(req);
            if (res.GetValue("return_code").ToString() == "SUCCESS" &&
                res.GetValue("result_code").ToString() == "SUCCESS")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}