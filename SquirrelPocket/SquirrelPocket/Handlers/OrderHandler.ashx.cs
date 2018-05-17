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

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for OrderHandler
    /// </summary>
    public class OrderHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Charset = "utf-8";

            string Action = context.Request["Action"].ToString();

            string result = "{\"result\":\"failed\"}";
            string openid = "";

            if (!string.IsNullOrEmpty(Action))
            {
                switch (Action)
                {
                    case "order":
                        var orderdata = context.Request["orderdata"].ToString();
                        string _statusid = "1";
                        string _statusStr = "NotPaid";
                        AllTrustUs.SquirrelPocket.Entity.Order _o = JsonUtility.Deserialize<AllTrustUs.SquirrelPocket.Entity.Order>(orderdata);
                        if (Convert.ToDecimal(_o.actualprice) == 0)
                        {
                            _statusid = "2";
                            _statusStr = "PaidSuccessed";
                        }

                        string insjson = @"insert into t_order(openid,outtradeno,fruittype,unitprice,startdate,enddate,days,
                            count,deliveryaddr,user,mp,totalprice,status,createdate,statusid,deliverystatus,otheraddr,GiftCardCode,deduction,actualprice,agencylevel,discount) values({0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21});select @@IDENTITY;";
                        insjson = string.Format(insjson,
                            UtilityFn.formatstring(_o.openid),
                            UtilityFn.formatstring(UtilityFn.GenerateOutTradeNo()),
                             UtilityFn.formatstring(_o.fruittype),
                             UtilityFn.formatstring(_o.unitprice),
                             UtilityFn.formatstring(_o.startdate),
                             UtilityFn.formatstring(_o.enddate),
                             UtilityFn.formatstring(_o.days),
                             UtilityFn.formatstring(_o.count),
                             UtilityFn.formatstring(_o.deliveryaddr),
                             UtilityFn.formatstring(_o.user),
                             UtilityFn.formatstring(_o.mp),
                             UtilityFn.formatstring(_o.totalprice),
                             UtilityFn.formatstring(_statusStr),
                             UtilityFn.formatstring(DateTime.Now.ToString("yyyy/MM/dd HH:mm")),
                             UtilityFn.formatstring(_statusid),
                             UtilityFn.formatstring("未配送"),
                             UtilityFn.formatstring(_o.otheraddr),
                             UtilityFn.formatstring(_o.GiftCardCode),
                             UtilityFn.formatstring(_o.deduction),
                             UtilityFn.formatstring(_o.actualprice),
                             UtilityFn.formatstring(_o.agencylevel),
                             UtilityFn.formatstring(_o.discount)
                             );
                        DataTable order = MySqlHelp.ExecuteDataTable(insjson);

                        if (order.Rows.Count > 0 && int.Parse(order.Rows[0][0].ToString()) > 0)
                        {
                            var orderid = order.Rows[0][0].ToString();
                            if (!string.IsNullOrEmpty(_o.GiftCardCode))
                            {
                                var updatecard = "update giftcard set isused='1',usedorderid='" + orderid + "',useddate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' where giftcardcode='" + _o.GiftCardCode.Replace("-", "") + "'";
                                MySqlHelp.ExecuteNonQuery(updatecard);
                            }

                            foreach (AllTrustUs.SquirrelPocket.Entity.OrderFruit of in _o.fruits)
                            {
                                string insof = @"insert into t_orderfruts(orderid,fruitid,name,unit,unitprice,count,price,fruitNum,cost) 
                                    values({0},{1},{2},{3},{4},{5},{6},{7},{8});";
                                insof = string.Format(insof,
                                UtilityFn.formatstring(orderid),
                                UtilityFn.formatstring(of.FruitID),
                                UtilityFn.formatstring(of.Name),
                                UtilityFn.formatstring(string.IsNullOrEmpty(of.unit) ? "个" : of.unit),
                                UtilityFn.formatstring(of.unitprice),
                                UtilityFn.formatstring(string.IsNullOrEmpty(of.count) ? "1" : of.count),
                                UtilityFn.formatstring(of.price),
                                UtilityFn.formatstring(of.fruitNum),
                                UtilityFn.formatstring(of.cost)
                                );

                                MySqlHelp.ExecuteNonQuery(insof);
                            }

                            foreach (Entity.Delivery de in _o.deliverys)
                            {
                                string insdeli = @"insert into t_delivery(orderid,date,count,status) 
                                    values({0},{1},{2},{3});select @@IDENTITY;";
                                insdeli = string.Format(insdeli,
                                UtilityFn.formatstring(orderid),
                                UtilityFn.formatstring(de.Date),
                                UtilityFn.formatstring(de.Count),
                                UtilityFn.formatstring("未配送"));
                                DataTable deliDT = MySqlHelp.ExecuteDataTable(insdeli);
                                if (deliDT.Rows.Count > 0 && int.Parse(deliDT.Rows[0][0].ToString()) > 0)
                                {
                                    var deliID = deliDT.Rows[0][0].ToString();
                                    foreach (Entity.Deliveryfruits def in de.Deliveryfruits)
                                    {
                                        string insdelif = @"insert into t_deliveryfruits(deliveryid,fruitid,name) 
                                    values({0},{1},{2});";
                                        insdelif = string.Format(insdelif,
                                        UtilityFn.formatstring(deliID),
                                        UtilityFn.formatstring(def.FruitID),
                                        UtilityFn.formatstring(def.Name));
                                        MySqlHelp.ExecuteNonQuery(insdelif);

                                    }
                                }

                            }
                            EmailHelper eh = new EmailHelper();
                            eh.SendMail("Squirel New Order Create", UtilityFn.JsonToHTMLTable(_o.ToJSONString()));

                            result = "{\"result\":\"successed\",\"orderid\":\"" + orderid + "\"}";
                        }
                        break;
                    case "getorder":
                        openid = context.Request["openid"].ToString();
                        var status = context.Request["status"].ToString();
                        List<Entity.Order> _Orders = new List<Entity.Order>();
                        string getsql = "select * from t_order where openid=" + UtilityFn.formatstring(openid) + " and status=" + UtilityFn.formatstring(status) + " and status<>'deleted' order by statusid asc, createdate desc";
                        DataTable odDT = MySqlHelp.ExecuteDataTable(getsql);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.Order orderentity = new Entity.Order();

                            orderentity.openid = odDT.Rows[i]["openid"].ToString();
                            orderentity.fruittype = odDT.Rows[i]["fruittype"].ToString();
                            orderentity.startdate = odDT.Rows[i]["startdate"].ToString();
                            orderentity.enddate = odDT.Rows[i]["enddate"].ToString();
                            orderentity.days = odDT.Rows[i]["days"].ToString();
                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.deliveryaddr = odDT.Rows[i]["deliveryaddr"].ToString();
                            orderentity.user = odDT.Rows[i]["user"].ToString();
                            orderentity.mp = odDT.Rows[i]["mp"].ToString();
                            orderentity.totalprice = odDT.Rows[i]["totalprice"].ToString();
                            orderentity.outtradeno = odDT.Rows[i]["outtradeno"].ToString();
                            orderentity.status = odDT.Rows[i]["status"].ToString();
                            orderentity.orderid = odDT.Rows[i]["orderid"].ToString();
                            orderentity.createdate = odDT.Rows[i]["createdate"].ToString();
                            orderentity.unitprice = odDT.Rows[i]["unitprice"].ToString();
                            orderentity.otheraddr = odDT.Rows[i]["otheraddr"].ToString();
                            orderentity.deduction = odDT.Rows[i]["deduction"].ToString();
                            orderentity.actualprice = odDT.Rows[i]["actualprice"].ToString();

                            string getfruitssql = "select * from t_orderfruts where orderid=" + UtilityFn.formatstring(orderentity.orderid);
                            DataTable frDT = MySqlHelp.ExecuteDataTable(getfruitssql);
                            orderentity.fruits = new List<Entity.OrderFruit>();
                            for (int j = 0; j < frDT.Rows.Count; j++)
                            {

                                Entity.OrderFruit ordereFruitntity = new Entity.OrderFruit();
                                ordereFruitntity.FruitID = frDT.Rows[j]["fruitid"].ToString();
                                ordereFruitntity.Name = frDT.Rows[j]["name"].ToString();
                                orderentity.fruits.Add(ordereFruitntity);
                            }

                            _Orders.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_Orders) + "}";



                        break;
                    case "cancelorder":
                        string cancelorderid = context.Request["orderid"].ToString();
                        MySqlHelp.ExecuteNonQuery("update t_order set status='Canceled',statusid='5' where orderid=" + UtilityFn.formatstring(cancelorderid));
                        result = "{\"result\":\"successed\"}";
                        break;
                    case "deleteorder":
                        string deleteorderorderid = context.Request["orderid"].ToString();
                        MySqlHelp.ExecuteNonQuery("update t_order set status='Deleted',statusid='4' where orderid=" + UtilityFn.formatstring(deleteorderorderid));
                        result = "{\"result\":\"successed\"}";
                        break;
                    case "saveuserinfo":
                        string userdata = context.Request["userdata"].ToString();
                        openid = context.Request["openid"].ToString();

                        Dictionary<string, object> Dic = JsonUtility.ToDictionary(userdata);
                        var nickname = Dic["nickname"].ToString();
                        var country = Dic["country"].ToString();
                        var province = Dic["province"].ToString();
                        var city = Dic["city"].ToString();
                        var sex = "";
                        if (!string.IsNullOrEmpty(Dic["sex"].ToString()))
                        {
                            if (Dic["sex"].ToString().Contains("男"))
                            {
                                sex = "1";
                            }
                            else
                            {
                                sex = "2";
                            }
                        }
                        else
                        {
                            sex = "1";
                        }

                        var mp = Dic["mp"].ToString();

                        ((WeXUser)context.Session["CurrentWeXUser"]).MP = mp;
                        ((WeXUser)context.Session["CurrentWeXUser"]).city = city;
                        ((WeXUser)context.Session["CurrentWeXUser"]).country = country;
                        ((WeXUser)context.Session["CurrentWeXUser"]).nickname = nickname;
                        ((WeXUser)context.Session["CurrentWeXUser"]).sex = sex;
                        ((WeXUser)context.Session["CurrentWeXUser"]).province = province;
                        MySqlHelp.ExecuteNonQuery("update t_user set mp=" + UtilityFn.formatstring(mp)
                            + ",nickname=" + UtilityFn.formatstring(nickname)
                            + ",country=" + UtilityFn.formatstring(country)
                            + ",province=" + UtilityFn.formatstring(province)
                            + ",city=" + UtilityFn.formatstring(city)
                            + ",sex=" + UtilityFn.formatstring(sex)
                            + " where openid=" + UtilityFn.formatstring(openid));

                        //((WeXUser)context.Session["CurrentWeXUser"]).MP = mp;

                        result = "{\"result\":\"successed\"}";

                        break;
                    case "getDeliveryDetail":
                        var Deliveryorderid = context.Request["orderid"].ToString();
                        List<Entity.Delivery> deli = new List<Entity.Delivery>();
                        string Deligetsql = "select * from t_delivery where orderid=" + UtilityFn.formatstring(Deliveryorderid);
                        DataTable DeliDT = MySqlHelp.ExecuteDataTable(Deligetsql);

                        for (int i = 0; i < DeliDT.Rows.Count; i++)
                        {
                            Entity.Delivery ent = new Entity.Delivery();
                            ent.ID = DeliDT.Rows[i]["ID"].ToString();
                            ent.OrderID = Deliveryorderid;
                            ent.Date = DeliDT.Rows[i]["Date"].ToString();
                            ent.Count = DeliDT.Rows[i]["Count"].ToString();
                            ent.deliverystatus = DeliDT.Rows[i]["status"].ToString();
                            deli.Add(ent);
                        }

                        result = "{\"result\":\"successed\",\"deliverys\":" + JsonUtility.ToJSONString(deli) + "}";
                        break;
                    case "orderRefund":
                        string orderRefundorderid = context.Request["orderid"].ToString();
                        DataTable orderDT = MySqlHelp.ExecuteDataTable(string.Format("select * from t_order where orderid={0}", orderRefundorderid));
                        var outtradeno = orderDT.Rows[0]["outtradeno"].ToString();
                        var transaction_id = orderDT.Rows[0]["transaction_id"].ToString();
                        var totalprice = orderDT.Rows[0]["totalprice"].ToString();
                        var actualprice = orderDT.Rows[0]["actualprice"].ToString();
                        try
                        {
                            string Refundresult = Refund.Run(transaction_id, outtradeno, (int.Parse(actualprice) * 100).ToString(), (int.Parse(actualprice) * 100).ToString());

                            Dictionary<string, object> di = JsonUtility.ToDictionary(Refundresult);
                            EmailHelper eh = new EmailHelper();
                            if (di["result_code"].ToString().ToUpper() == "FAIL")
                            {
                                result = "{\"result\":\"failed\"}";
                                eh.SendMail("Squirel Refunded Order failed[" + orderRefundorderid + "]", UtilityFn.JsonToHTMLTable(Refundresult));

                            }
                            else
                            {
                                result = "{\"result\":\"successed\"}";
                                MySqlHelp.ExecuteNonQuery(string.Format("update t_order set status='Refunded',statusid='100' where  orderid={0}", orderRefundorderid));
                                eh.SendMail("Squirel Refunded Order Successed[" + orderRefundorderid + "]", UtilityFn.JsonToHTMLTable(Refundresult));
                            }
                            Log.Info(this.GetType().ToString(), Refundresult);

                            //Response.Write("<span style='color:#00CD00;font-size:20px'>" + result + "</span>");
                        }
                        catch (WxPayException ex)
                        {
                            result = "{\"result\":\"failed\"}";
                            //Response.Write("<span style='color:#FF0000;font-size:20px'>" + ex.ToString() + "</span>");
                        }
                        catch (Exception ex)
                        {
                            result = "{\"result\":\"failed\"}";
                            //Response.Write("<span style='color:#FF0000;font-size:20px'>" + ex.ToString() + "</span>");
                        }


                        break;
                    case "getgiftcode":
                        string giftcode = context.Request["giftcode"].ToString().Replace("-", "");
                        DataTable giftcodeDT = MySqlHelp.ExecuteDataTable(string.Format("select * from giftcard where isused='0' and giftcardcode='{0}'", giftcode));
                        if (giftcodeDT.Rows.Count > 0)
                        {
                            Giftcard gc = new Giftcard();
                            gc.id = Convert.ToInt32(giftcodeDT.Rows[0]["id"]);
                            gc.giftcardcode = giftcodeDT.Rows[0]["giftcardcode"].ToString();
                            gc.amount = giftcodeDT.Rows[0]["amount"].ToString();
                            gc.generatedate = giftcodeDT.Rows[0]["generatedate"].ToString();
                            gc.isused = giftcodeDT.Rows[0]["isused"].ToString();
                            gc.usedorderid = giftcodeDT.Rows[0]["usedorderid"].ToString();
                            gc.useddate = giftcodeDT.Rows[0]["useddate"].ToString();
                            gc.forcompany = giftcodeDT.Rows[0]["forcompany"].ToString();
                            gc.expireddate = giftcodeDT.Rows[0]["expireddate"].ToString();

                            result = "{\"result\":\"successed\",\"giftcard\":" + JsonUtility.ToJSONString(gc) + "}";
                        }
                        else
                        {
                            result = "{\"result\":\"failed\"}";
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