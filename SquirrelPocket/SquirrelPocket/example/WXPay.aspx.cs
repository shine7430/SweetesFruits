﻿using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket
{
    public partial class WXPay : System.Web.UI.Page
    {
        public static string wxJsApiParam { get; set; } //H5调起JS API参数

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string openid = Request.QueryString["openid"];
                string total_fee = Request.QueryString["total_fee"];
                //检测是否给当前页面传递了相关参数
                if (string.IsNullOrEmpty(openid) || string.IsNullOrEmpty(total_fee))
                {
                    Response.Write("<span style='color:#FF0000;font-size:20px'>" + "页面传参出错,请返回重试" + "</span>");
                    Log.Error(this.GetType().ToString(), "This page have not get params, cannot be inited, exit...");
                    //submit.Visible = false;
                    return;
                }

                //若传递了相关参数，则调统一下单接口，获得后续相关接口的入口参数
                JsApiPay jsApiPay = new JsApiPay(this);
                jsApiPay.openid = openid;
                jsApiPay.total_fee = int.Parse(total_fee);

                //JSAPI支付预处理
                WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(UtilityFn.GenerateOutTradeNo());
                try
                {

                    wxJsApiParam = jsApiPay.GetJsApiParameters();//获取H5调起JS API参数                    
                    Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                    //在页面上显示订单信息
                    Response.Write("<span style='color:#00CD00;font-size:20px'>订单详情：</span><br/>");
                    Response.Write("<span style='color:#00CD00;font-size:20px'>" + unifiedOrderResult.ToPrintStr() + "</span>");

                }
                catch (Exception ex)
                {
                    Response.Write("<span style='color:#FF0000;font-size:20px'>" + "下单失败，请返回重试" + "</span>");
                    Response.Write("<span style='color:#00CD00;font-size:20px'>" + unifiedOrderResult.ToPrintStr() + "</span>");
                    Response.Write("wxJsApiParam : " + wxJsApiParam);
                    //submit.Visible = false;
                }
            }
        }
    }
}