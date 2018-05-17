using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using YZOpenSDK;

namespace AllTrustUs.SquirrelPocket
{
    public partial class GifCardTake : TrustUsPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            //Auth auth = new Token("xxx");
            //Auth auth = new Sign("2e6259a7d6e91d6875", "7dc62b1091aff300d4bf6153e7e84b84");
            //YZClient yzClient = new DefaultYZClient(auth);
            //Dictionary<string, object> dict = new System.Collections.Generic.Dictionary<string, object>();
            //dict.Add("title", "aaaaa");
            //dict.Add("price", 1.0);
            //dict.Add("post_fee", 1.0);

            //List<KeyValuePair<string, string>> files = new List<KeyValuePair<string, string>>();
            //files.Add(new KeyValuePair<string, string>("images[]", "/xx/xx/1.jpg"));

            ////var result = yzClient.Invoke("youzan.item.create", "3.0.0", "post", dict, files);
            //var result = yzClient.Invoke("youzan.items.onsale.get", "3.0.0", "get", dict, null);
        }
    }
}