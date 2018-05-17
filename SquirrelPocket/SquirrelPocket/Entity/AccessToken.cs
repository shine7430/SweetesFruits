using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    public class AccessToken
    {
        public string access_token { set; get; }
        public int expires_in { set; get; }
        public string scope { set; get; }
            
     
    }
}