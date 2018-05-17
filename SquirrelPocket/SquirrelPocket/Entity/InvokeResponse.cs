using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    public class InvokeResponse
    {
        public Response response
        {
            get;
            set;
        }
        public error_response error_response
        {
            get;
            set;
        }
    }


    public class Response
    {
        public string coupon_type
        {
            get;
            set;
        }

        public List<promocard> promocard
        {
            get;
            set;

        }
    }
    public class promocard
    {
        public string promocard_id
        {
            get;
            set;
        }
        public string title
        {
            get;
            set;
        }
        public string value
        {
            get;
            set;
        }
        //  "promocard_id": "10422654",
        //"title": "华宇测试0722",
        //"value": "1.00",
        //"condition": "无限制",
        //"start_at": "2016-07-22 17:35:03",
        //"end_at": "2016-07-30 17:34:23",
        //"is_used": "0",
        //"is_invalid": "0",
        //"is_expired": 0,
        //"background_color": "#55bd47",
        //"detail_url": "https://wap.koudaitong.com/v2/showcase/coupon/detail?alias=1359928&id=10422654",
        //"verify_code": "792873936041"
    }

    public class error_response
    {
        public string code
        {
            get;
            set;
        }

        public string msg
        {
            get;
            set;

        }

    }
}