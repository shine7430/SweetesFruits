using AllTrustUs.SquirrelPocket.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace AllTrustUs.SquirrelPocket.Entity
{
    public class Delivery
    {
        private string _id;
        public string ID
        {
            get
            {
                return _id;
            }
            set
            {
                _id = value;
                List<Entity.Delivery> deli = new List<Entity.Delivery>();
                string Deligetsql = "select * from t_deliveryfruits where deliveryid=" + UtilityFn.formatstring(_id);
                DataTable DeliDT = MySqlHelp.ExecuteDataTable(Deligetsql);
                List<Deliveryfruits> dfs = new List<Deliveryfruits>();
                for (int i = 0; i < DeliDT.Rows.Count; i++)
                {
                    Entity.Deliveryfruits def = new Deliveryfruits();
                    def.FruitID = DeliDT.Rows[i]["FruitID"].ToString();
                    def.Name = DeliDT.Rows[i]["Name"].ToString();
                    dfs.Add(def);
                }
                this.Deliveryfruits = dfs;
            }

        }
        public string OrderID
        {
            get;
            set;
        }
        public string Date { get; set; }
        public string Status { get; set; }
        public string Count { get; set; }

        public string deliverystatus { get; set; }

        public List<Deliveryfruits> Deliveryfruits
        {
            get;
            set;
        }

    }
}