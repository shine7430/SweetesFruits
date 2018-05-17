using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    public enum OrderStatus
    {
        NotPaid,//未支付
        PaidSuccessed,//已支付
        Completed,//已完成
        Canceled,//已取消
        Expiry,//已过期
        Refunded//已退款
    }
    public class Order
    {
        public string orderid { get; set; }
        public string openid { get; set; }
        public string fruittype { get; set; }
        public string unitprice { get; set; }
        public string startdate { get; set; }
        public string enddate { get; set; }
        public string days { get; set; }
        public string count { get; set; }
        public string deliveryaddr { get; set; }
        public string user { get; set; }
        public string mp { get; set; }
        public string totalprice { get; set; }

        public string status { get; set; }
        public string outtradeno { get; set; }

        public string createdate { get; set; }

        public string deliverystatus { get; set; }
        public string otheraddr { get; set; }
        public string GiftCardCode { get; set; }
        public string deduction { get; set; }
        public string actualprice { get; set; }
        public string ExpressNumber { get; set; }
        public string agencylevel { get; set; }
        public string discount { get; set; }

        public List<OrderFruit> fruits
        {
            get;
            set;
        }

        public List<Delivery> deliverys
        {
            get;
            set;
        }
    }
}