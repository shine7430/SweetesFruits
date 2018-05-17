using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Handlers
{
    /// <summary>
    /// Summary description for ManagementHandler
    /// </summary>
    public class ManagementHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Charset = "utf-8";

            string Action = context.Request["Action"].ToString();
            var conditions = context.Request["conditions"];
            var deliveryid = context.Request["deliveryid"];
            var orderid = context.Request["orderid"];
            string result = string.Empty;
            var querySQL = string.Empty;
            List<Entity.DeliveryReport> _DeliveryReport = new List<Entity.DeliveryReport>();
            DataTable odDT = new DataTable();
            if (!string.IsNullOrEmpty(Action))
            {
                switch (Action.ToLower())
                {
                    case "getdeliverys":
                        querySQL = @"select 
tor.outtradeno as 'orderid',
td.id as 'deliveryid',
td.status as 'deliverystatus',
tor.openid,
tu.nickname,
tor.fruittype,
tor.count,
tor.deliveryaddr,
tor.user,
tor.mp,
td.date,
GROUP_CONCAT(tdf.name) as 'fruits'
from t_order tor
inner join t_delivery td
on tor.orderid=td.orderid and tor.status='PaidSuccessed'
inner join t_deliveryfruits tdf
on tdf.deliveryid=td.id
inner join t_user tu
on tu.openid=tor.openid
group by 
tor.outtradeno,
tor.openid,
tu.nickname,
tor.fruittype,
tor.count,
tor.deliveryaddr,
tor.user,
tor.mp,
td.date
order by td.date
";
                        odDT = MySqlHelp.ExecuteDataTable(querySQL);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.DeliveryReport orderentity = new Entity.DeliveryReport();
                            orderentity.orderid = odDT.Rows[i]["orderid"].ToString();
                            orderentity.openid = odDT.Rows[i]["openid"].ToString();
                            orderentity.nickname = odDT.Rows[i]["nickname"].ToString();
                            orderentity.fruittype = odDT.Rows[i]["fruittype"].ToString();
                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.deliveryaddr = odDT.Rows[i]["deliveryaddr"].ToString();
                            orderentity.user = odDT.Rows[i]["user"].ToString();
                            orderentity.date = odDT.Rows[i]["date"].ToString();
                            orderentity.mp = odDT.Rows[i]["mp"].ToString();
                            orderentity.fruits = odDT.Rows[i]["fruits"].ToString();
                            orderentity.deliveryid = odDT.Rows[i]["deliveryid"].ToString();
                            orderentity.deliverystatus = odDT.Rows[i]["deliverystatus"].ToString();
                            _DeliveryReport.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_DeliveryReport) + "}";

                        break;
                    case "getgiftboxdelivery":

                        querySQL = @"select 
tor.outtradeno as 'orderid',
tor.openid,
tu.nickname,
tor.fruittype,
tor.startdate,
tor.count,
tor.deliveryaddr,
tor.user,
tor.mp,
tor.deliverystatus,
GROUP_CONCAT(CONCAT(tof.name,tof.fruitNum * tof.count ,tof.unit,' (',CAST(tof.count AS char),'份)' ) )as 'fruits',
tor.GiftCardCode,
tor.ExpressNumber
from t_order tor
inner join t_orderfruts tof
on tof.orderid=tor.orderid and  tor.status in('PaidSuccessed','Completed') and fruittype like '%礼盒%' 
inner join t_user tu
on tu.openid=tor.openid
group by
tor.outtradeno
order by startdate
";
                        odDT = MySqlHelp.ExecuteDataTable(querySQL);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.DeliveryReport orderentity = new Entity.DeliveryReport();
                            orderentity.orderid = odDT.Rows[i]["orderid"].ToString();
                            orderentity.openid = odDT.Rows[i]["openid"].ToString();
                            orderentity.nickname = odDT.Rows[i]["nickname"].ToString();
                            orderentity.fruittype = odDT.Rows[i]["fruittype"].ToString();
                            orderentity.date = odDT.Rows[i]["startdate"].ToString();

                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.deliveryaddr = odDT.Rows[i]["deliveryaddr"].ToString();
                            orderentity.user = odDT.Rows[i]["user"].ToString();
                            orderentity.mp = odDT.Rows[i]["mp"].ToString();
                            orderentity.fruits = odDT.Rows[i]["fruits"].ToString();
                            orderentity.deliverystatus = odDT.Rows[i]["deliverystatus"].ToString();
                            orderentity.ExpressNumber = odDT.Rows[i]["ExpressNumber"].ToString();
                            orderentity.GiftCardCode = odDT.Rows[i]["GiftCardCode"].ToString();
                            _DeliveryReport.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_DeliveryReport) + "}";
                        break;
                    case "getcommunitydelivery":
                        querySQL = @"select 
tor.outtradeno as 'orderid',
tor.openid,
tu.nickname,
tor.fruittype,
tor.startdate,
tor.count,
tor.deliveryaddr,
tor.user,
tor.mp,
tor.deliverystatus,
GROUP_CONCAT(CONCAT(tof.name,tof.fruitNum * tof.count ,tof.unit ) ) as 'fruits',
tor.GiftCardCode,
tor.ExpressNumber,
tor.actualprice,
tor.status,
tor.agencylevel,
tor.discount,
tor.rebate
from t_order tor
inner join t_orderfruts tof
on tof.orderid=tor.orderid and  tor.status in('PaidSuccessed','Completed','NotPaid') and fruittype like '%社区%'
inner join t_user tu
on tu.openid=tor.openid
group by
tor.outtradeno
order by startdate
";
                        odDT = MySqlHelp.ExecuteDataTable(querySQL);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.DeliveryReport orderentity = new Entity.DeliveryReport();
                            orderentity.orderid = odDT.Rows[i]["orderid"].ToString();
                            orderentity.openid = odDT.Rows[i]["openid"].ToString();
                            orderentity.nickname = odDT.Rows[i]["nickname"].ToString();
                            orderentity.fruittype = odDT.Rows[i]["fruittype"].ToString();
                            orderentity.date = odDT.Rows[i]["startdate"].ToString();

                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.deliveryaddr = odDT.Rows[i]["deliveryaddr"].ToString();
                            orderentity.user = odDT.Rows[i]["user"].ToString();
                            orderentity.mp = odDT.Rows[i]["mp"].ToString();
                            orderentity.fruits = odDT.Rows[i]["fruits"].ToString();
                            orderentity.deliverystatus = odDT.Rows[i]["deliverystatus"].ToString();
                            orderentity.ExpressNumber = odDT.Rows[i]["ExpressNumber"].ToString();
                            orderentity.GiftCardCode = odDT.Rows[i]["GiftCardCode"].ToString();
                            orderentity.actualprice = odDT.Rows[i]["actualprice"].ToString();
                            orderentity.status = odDT.Rows[i]["status"].ToString();
                            orderentity.agencylevel = odDT.Rows[i]["agencylevel"].ToString();
                            orderentity.discount = odDT.Rows[i]["discount"].ToString();
                            orderentity.rebate = odDT.Rows[i]["rebate"].ToString();
                            _DeliveryReport.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_DeliveryReport) + "}";
                        break;
                    case "getfruitsestimate":
                        querySQL = @"
select * from
(
select 
td.date,
tdf.name as fruits,
sum(tor.count*150) as count,
'g' as unit
 from t_order tor
inner join t_delivery td
on tor.orderid=td.orderid and tor.status='PaidSuccessed' and tor.fruittype<>'精品礼盒DIY'
inner join t_deliveryfruits tdf
on td.id=tdf.deliveryid
group by
td.date,
tdf.name 
union
select 
tor.startdate as 'date',
tof.name as fruits,
sum(tof.fruitNum * tof.count* tor.count) as 'count',
tof.unit
from t_order tor
inner join t_orderfruts tof
on tof.orderid=tor.orderid and  tor.status='PaidSuccessed' and fruittype='精品礼盒DIY'
inner join t_user tu
on tu.openid=tor.openid
group by
tor.startdate,
tof.name,
tof.unit
)T
order by date";
                        odDT = MySqlHelp.ExecuteDataTable(querySQL);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.DeliveryReport orderentity = new Entity.DeliveryReport();
                            orderentity.date = odDT.Rows[i]["date"].ToString();
                            orderentity.fruits = odDT.Rows[i]["fruits"].ToString();
                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.unit = odDT.Rows[i]["unit"].ToString();
                            _DeliveryReport.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_DeliveryReport) + "}";
                        break;
                    case "getcommunityfruitsestimate":
                        querySQL = @"select * from
(
select 
tor.status,
tor.deliveryaddr,
tor.startdate as 'date',
tof.name as fruits,
sum(tof.fruitNum * tof.count* tor.count) as 'count',
tof.unit
from t_order tor
inner join t_orderfruts tof
on tof.orderid=tor.orderid and fruittype like '%社区%'
inner join t_user tu
on tu.openid=tor.openid
group by
tor.status,
tor.startdate,
tof.name,
tof.unit,
deliveryaddr
)T
order by date";
                        odDT = MySqlHelp.ExecuteDataTable(querySQL);
                        for (int i = 0; i < odDT.Rows.Count; i++)
                        {
                            Entity.DeliveryReport orderentity = new Entity.DeliveryReport();
                            orderentity.date = odDT.Rows[i]["date"].ToString();
                            orderentity.fruits = odDT.Rows[i]["fruits"].ToString();
                            orderentity.count = odDT.Rows[i]["count"].ToString();
                            orderentity.unit = odDT.Rows[i]["unit"].ToString();
                            orderentity.deliveryaddr = odDT.Rows[i]["deliveryaddr"].ToString();
                            orderentity.status = odDT.Rows[i]["status"].ToString();
                            
                            _DeliveryReport.Add(orderentity);

                        }
                        result = "{\"result\":\"successed\",\"orders\":" + JsonUtility.ToJSONString(_DeliveryReport) + "}";
                        break;
                    case "singledelivery":

                        DataTable checkdt = MySqlHelp.ExecuteDataTable(string.Format(@"update t_delivery set status='已配送' 
where id={0};
select 1 from t_order tor
inner join t_delivery td
on td.orderid=tor.orderid
where td.status='未配送' and tor.outtradeno='{1}'", deliveryid, orderid));
                        if (checkdt.Rows.Count <= 0)
                        {
                            MySqlHelp.ExecuteNonQuery("update t_order set status='Completed',statusid='3' where outtradeno=" + UtilityFn.formatstring(orderid));
                        }
                        result = "{\"result\":\"successed\"}";
                        break;
                    case "bodelivery":
                        MySqlHelp.ExecuteNonQuery("update t_order set deliverystatus='已配送',status='Completed',statusid='3' where outtradeno=" + UtilityFn.formatstring(deliveryid));
                        result = "{\"result\":\"successed\"}";
                        break;
                    case "changeexpressnumber":
                        var ExpressNumber = context.Request["ExpressNumber"];
                        MySqlHelp.ExecuteNonQuery("update t_order set ExpressNumber=" + UtilityFn.formatstring(ExpressNumber) + " where outtradeno=" + UtilityFn.formatstring(orderid));
                        result = "{\"result\":\"successed\"}";

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