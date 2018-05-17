using System;
using System.Collections.Generic;
using System.Web;

namespace AllTrustUs.WXPayAPILib
{
    public class WxPayException : Exception 
    {
        public WxPayException(string msg) : base(msg) 
        {

        }
     }
}