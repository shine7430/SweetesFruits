using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    public class Giftcard
    {
        public int id { get; set; }
        public string giftcardcode { get; set; }
        public string amount { get; set; }
        public string generatedate { get; set; }
        public string isused { get; set; }
        public string usedorderid { get; set; }
        public string useddate { get; set; }
        public string forcompany { get; set; }
        public string expireddate { get; set; }
        
    }
}