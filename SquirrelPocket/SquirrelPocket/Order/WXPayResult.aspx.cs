using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket.Order
{
    public partial class WXPayResult : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AllTrustUs.SquirrelPocket.Utility.ResultNotify resultNotify = 
                new AllTrustUs.SquirrelPocket.Utility.ResultNotify(this);

            resultNotify.ProcessNotify();
        }
    }
}