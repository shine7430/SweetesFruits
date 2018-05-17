using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AllTrustUs.SquirrelPocket
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Exception sysEx = Session["LastException"] as Exception;
            if (sysEx != null)
            {

                EmailHelper eh = new EmailHelper();
                eh.SendMail("Squirel Application Exception", sysEx.Message + "</br>" + ";"
                    + sysEx.Source + "</br>" + ";"
                    + sysEx.StackTrace);
                Session["LastException"] = null;
            }

        }
    }
}