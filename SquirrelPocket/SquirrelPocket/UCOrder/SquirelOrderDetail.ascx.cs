using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket.UCOrder
{
    public partial class SquirelOrderDetail : TrustUsUserControl
    {
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

        public bool canRefund
        {
            get;
            set;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                canRefund = false;
                order_id = Request.QueryString["order_id"];

                OrderPay = new Entity.Order();
                DataSet orderDS = MySqlHelp.ExecuteDataSet(string.Format("select * from t_order where orderid={0};select * from t_orderfruts where orderid={0};", order_id));
                if (orderDS.Tables.Count == 2)
                {
                    OrderPay.openid = orderDS.Tables[0].Rows[0]["openid"].ToString();
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
                    OrderPay.deliverystatus = orderDS.Tables[0].Rows[0]["deliverystatus"].ToString();
                    OrderPay.otheraddr = orderDS.Tables[0].Rows[0]["otheraddr"].ToString();
                    OrderPay.deduction = orderDS.Tables[0].Rows[0]["deduction"].ToString();
                    OrderPay.actualprice = orderDS.Tables[0].Rows[0]["actualprice"].ToString();
                    OrderPay.ExpressNumber = orderDS.Tables[0].Rows[0]["ExpressNumber"].ToString();

                    switch (orderDS.Tables[0].Rows[0]["status"].ToString())
                    {
                        case "NotPaid":
                            OrderPay.status = "未支付";
                            break;
                        case "PaidSuccessed":
                            OrderPay.status = "已支付";
                            if (DateTime.Compare(DateTime.Now, Convert.ToDateTime(OrderPay.startdate)) < 0)
                            {
                                canRefund = true;
                            }
                            break;
                        case "Completed":
                            OrderPay.status = "已完成";
                            break;
                        case "Canceled":
                            OrderPay.status = "已取消";
                            break;
                        case "Expiry":
                            OrderPay.status = "已过期";
                            break;
                        case "Refunded":
                            OrderPay.status = "已退款";
                            break;
                        default:
                            break;
                    }

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
                            divdeliverystatus.Visible = true;
                        }
                    }
                }

            }
        }
    }
}