using AllTrustUs.SquirrelPocket.Utility;
using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket.Order
{
    public partial class WXPay : TrustUsPage
    {
        public static string wxJsApiParam { get; set; } //H5调起JS API参数
        public AllTrustUs.SquirrelPocket.Entity.Order OrderPay
        {
            get;
            set; 
        }

        public string Fruitslist
        {
            get;
            set;
        }

        public string order_id
        {
            get;
            set;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                string openid = Request.QueryString["openid"];
                string total_fee = Request.QueryString["total_fee"];
                order_id = Request.QueryString["order_id"];
                string ActualPay = ConfigurationManager.AppSettings["ActualPay"].ToString();
                OrderPay = new Entity.Order();
                DataSet orderDS = MySqlHelp.ExecuteDataSet(string.Format("select * from t_order where orderid={0};select * from t_orderfruts where orderid={0};", order_id));
                if (orderDS.Tables.Count == 2)
                {
                    if (orderDS.Tables[0].Rows[0]["status"].ToString() != "NotPaid")
                    {
                        return;
                    }
                    OrderPay.fruittype = orderDS.Tables[0].Rows[0]["fruittype"].ToString();
                    OrderPay.startdate = orderDS.Tables[0].Rows[0]["startdate"].ToString();
                    OrderPay.enddate = orderDS.Tables[0].Rows[0]["enddate"].ToString();
                    OrderPay.days = orderDS.Tables[0].Rows[0]["days"].ToString();
                    OrderPay.count = orderDS.Tables[0].Rows[0]["count"].ToString();
                    OrderPay.deliveryaddr = orderDS.Tables[0].Rows[0]["deliveryaddr"].ToString();
                    OrderPay.user = orderDS.Tables[0].Rows[0]["user"].ToString();
                    OrderPay.mp = orderDS.Tables[0].Rows[0]["mp"].ToString();
                    OrderPay.totalprice = orderDS.Tables[0].Rows[0]["totalprice"].ToString();
                    OrderPay.outtradeno = orderDS.Tables[0].Rows[0]["outtradeno"].ToString();
                    OrderPay.createdate = orderDS.Tables[0].Rows[0]["createdate"].ToString();
                    OrderPay.unitprice = orderDS.Tables[0].Rows[0]["unitprice"].ToString();
                    OrderPay.deduction = orderDS.Tables[0].Rows[0]["deduction"].ToString();
                    OrderPay.actualprice = orderDS.Tables[0].Rows[0]["actualprice"].ToString();

                    for (int i = 0; i < orderDS.Tables[1].Rows.Count; i++)
                    {
                        if (OrderPay.fruittype.Contains("社区预定"))
                        //{
                        //    Fruitslist += orderDS.Tables[1].Rows[i]["name"].ToString() + ";";
                        //}
                        //else
                        {
                            Fruitslist += orderDS.Tables[1].Rows[i]["name"].ToString()
                                + (Convert.ToInt32(orderDS.Tables[1].Rows[i]["fruitNum"]) * Convert.ToInt32(orderDS.Tables[1].Rows[i]["count"])).ToString()
                                + orderDS.Tables[1].Rows[i]["unit"] + ";";
                            divunit.Visible = false;
                            divdelivery.Visible = false;
                        }
                    }
                }
                else
                {
                    return;
                }
                //return;
                //检测是否给当前页面传递了相关参数
                if (string.IsNullOrEmpty(openid) || string.IsNullOrEmpty(total_fee) || string.IsNullOrEmpty(order_id))
                {
                    Response.Write("<span style='color:#FF0000;font-size:20px'>" + "页面传参出错,请返回重试" + "</span>");
                    Log.Error(this.GetType().ToString(), "This page have not get params, cannot be inited, exit...");
                    //submit.Visible = false;
                    return;
                }

                //若传递了相关参数，则调统一下单接口，获得后续相关接口的入口参数
                JsApiPay jsApiPay = new JsApiPay(this);
                jsApiPay.openid = openid;
                try
                {
                    if (Convert.ToBoolean(ActualPay))
                    {
                        jsApiPay.total_fee = int.Parse(total_fee);
                    }
                    else
                    {
                        jsApiPay.total_fee = 1;
                    }
                }
                catch (Exception ex)
                {
                    Response.Write(ex.Message + ex.StackTrace);
                }

                //jsApiPay.total_fee = 1;
                //JSAPI支付预处理
                WxPayData unifiedOrderResult = new WxPayData();
                try
                {
                    unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(OrderPay.outtradeno);
                    wxJsApiParam = jsApiPay.GetJsApiParameters();//获取H5调起JS API参数                    
                    Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                    //在页面上显示订单信息
                    //Response.Write("<span style='color:#00CD00;font-size:20px'>订单详情：</span><br/>");
                    //Response.Write("<span style='color:#00CD00;font-size:20px'>" + unifiedOrderResult.ToPrintStr() + "</span>");

                }
                catch (Exception ex)
                {
                    Response.Write("<span style='color:#FF0000;font-size:20px;margin-left:10px'>" + "初始化失败，无法支付，请返回重试。" + "</span>");
                    //Response.Write("<span style='color:#00CD00;font-size:20px'>" + unifiedOrderResult.ToPrintStr() + "</span>");
                    //Response.Write("wxJsApiParam : " + wxJsApiParam);
                    divbutton.Visible = false;
                }
            }
        }
    }
}