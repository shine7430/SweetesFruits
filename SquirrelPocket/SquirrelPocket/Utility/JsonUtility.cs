using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Collections;
using System.Data;

/// <summary>
///JsonUtility 的摘要说明
/// </summary>
namespace AllTrustUs.SquirrelPocket.Utility
{
    public static class JsonUtility
    {
        public static string ToJSONString(this object obj)
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            return Serializer.Serialize(obj);
        }

        public static T Deserialize<T>(string data)
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            return Serializer.Deserialize<T>(data);
        }

        public static List<T> JSONStringToList<T>(this string JsonStr)
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();

            List<T> objs = Serializer.Deserialize<List<T>>(JsonStr);

            return objs;
        }

        /// <summary>  
        /// Json 字符串 转换为Jsonp 字符串  
        /// </summary>  
        public static string Json2Jsonp(string jsonpCallBack, string jsonString)
        {
            return jsonpCallBack + "(" + jsonString + ")";
        }

        /// <summary>  
        /// DataTable 对象 转换为Json 字符串  
        /// </summary>  
        public static string ToJson(this DataTable dt)
        {
            JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();

            ArrayList arrayList = new ArrayList();

            foreach (DataRow dataRow in dt.Rows)
            {
                Dictionary<string, object> dictionary = new Dictionary<string, object>();  //实例化一个参数集合  

                foreach (DataColumn dataColumn in dt.Columns)
                {
                    dictionary.Add(dataColumn.ColumnName, dataRow[dataColumn.ColumnName].ToString());
                }
                arrayList.Add(dictionary); //ArrayList集合中添加键值  
            }
            return javaScriptSerializer.Serialize(arrayList);  //返回一个json字符串  
        }

        /// <summary>  
        /// Json 字符串 转换为 DataTable数据集合 
        /// </summary>  
        public static DataTable ToDataTable(this string json)
        {
            DataTable dataTable = new DataTable();  //实例化  
            DataTable result;

            try
            {
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();

                ArrayList arrayList = javaScriptSerializer.Deserialize<ArrayList>(json);

                if (arrayList.Count > 0)
                {
                    foreach (Dictionary<string, object> dictionary in arrayList)
                    {
                        if (dictionary.Keys.Count<string>() == 0)
                        {
                            result = dataTable;
                            return result;
                        }

                        if (dataTable.Columns.Count == 0)
                        {
                            foreach (string current in dictionary.Keys)
                            {
                                dataTable.Columns.Add(current, dictionary[current].GetType());
                            }
                        }

                        DataRow dataRow = dataTable.NewRow();
                        foreach (string current in dictionary.Keys)
                        {
                            dataRow[current] = dictionary[current];
                        }

                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中  
                    }
                }
            }
            catch
            {
            }

            result = dataTable;

            return result;
        }

        public static Dictionary<string, object> ToDictionary(this string str)
        {

            Dictionary<string, object> json = new Dictionary<string, object>();
            if (!string.IsNullOrEmpty(str))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();

                json = (Dictionary<string, object>)serializer.DeserializeObject(str);
            }
            return json;
        }

        public static List<Dictionary<string, object>> ToDictionaryList(this string str)
        {
            var tmp = new List<Dictionary<string, object>>();
            if (!string.IsNullOrEmpty(str))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();

                var temp = (object[])serializer.DeserializeObject(str);

                foreach (var j in temp)
                {
                    tmp.Add(j as Dictionary<string, object>);
                }
            }
            return tmp;
        }

    }

}