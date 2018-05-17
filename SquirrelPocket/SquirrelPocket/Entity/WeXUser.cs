using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    //{
    //    "openid": "oERB-uKnfV2TFNFoPa1JtkwPzogY",
    //    "nickname": "沈朝晖",
    //    "sex": 1,
    //    "language": "zh_CN",
    //    "city": "Pudong New District",
    //    "province": "Shanghai",
    //    "country": "CN",
    //    "headimgurl": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLBkTPicNQg8Xx9feYN7icWfsKb5pTMkwev86IEqic70HMibeIS9Yt1GBaiammBa49qnBYuWo57aibcw6Jfg/0",
    //    "privilege": []
    //}   
    [Serializable]

    public class WeXUser
    {
       public string openid { get; set; }
       public string nickname { get; set; }

        private string _sex;
        public string sex
        {
            get
            {
                return this._sex == "1" ? "Male" : "famale";
            }
            set
            {
                this._sex = value;
            }
        }
        public string sexCN
        {
            get
            {
                return this._sex == "1" ? "男" : "女";
            }
        }
        public string language { get; set; }
        public string city { get; set; }
        public string province { get; set; }
        public string country { get; set; }
        public string headimgurl { get; set; }
        public string MP { get; set; }
        public string createdate { get; set; }
        public string agencylevel { get; set; }
        public string discount { get; set; }
    }
}