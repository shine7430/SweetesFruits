using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AllTrustUs.SquirrelPocket.GiftCardGenerate
{
    class Program
    {
        static void Main(string[] args)
        {
            var count = args[0];
            var amount = args[1];
            var expireddate = args[2];
            var forcompany = args[3];
            var PromoId = args[4];
            var jumpurl = args[5];
            for (int i = 0; i < Convert.ToInt32(count); i++)
            {
                try
                {
                    string code = GetRandomString(12, true, false, false, false, "");
                    string insof = @"insert into giftcard(giftcardcode,amount,expireddate,forcompany,generatedate,PromoId,jumpurl) 
                                    values({0},{1},{2},{3},{4},{5},{6});";
                    
                    insof = string.Format(insof,
                    UtilityFn.formatstring(code),
                    UtilityFn.formatstring(amount),
                    UtilityFn.formatstring(expireddate),
                    UtilityFn.formatstring(forcompany),
                    UtilityFn.formatstring(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")),
                    UtilityFn.formatstring(PromoId),
                    UtilityFn.formatstring(jumpurl)

                    );
                    Console.WriteLine(insof);
                    MySqlHelp.ExecuteNonQuery(insof);
                    Console.WriteLine(code);
                }
                catch
                {

                }
            }
            Console.ReadKey();
        }

        public static string GetRandomString(int length, bool useNum, bool useLow, bool useUpp, bool useSpe, string custom)
        {
            byte[] b = new byte[4];
            new System.Security.Cryptography.RNGCryptoServiceProvider().GetBytes(b);
            Random r = new Random(BitConverter.ToInt32(b, 0));
            string s = null, str = custom;
            if (useNum == true) { str += "0123456789"; }
            if (useLow == true) { str += "abcdefghijklmnopqrstuvwxyz"; }
            if (useUpp == true) { str += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
            if (useSpe == true) { str += "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"; }
            for (int i = 0; i < length; i++)
            {
                s += str.Substring(r.Next(0, str.Length - 1), 1);
            }
            return s;
        }

    }


}
