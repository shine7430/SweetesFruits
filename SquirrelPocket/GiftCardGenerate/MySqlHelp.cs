using System;
using System.Data;
using System.Configuration;
using System.Web;
using MySql.Data.MySqlClient;
using System.Collections.Generic;


namespace AllTrustUs.SquirrelPocket.GiftCardGenerate
{
   public class MySqlHelp
    {
        public static readonly string strConn = ConfigurationManager.AppSettings["MySqlConStr"].ToString();

        private static void PrepareCommand(MySqlCommand cmd, MySqlConnection conn, string cmdText, MySqlParameter[] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Connection = conn;
            cmd.CommandText = cmdText;
            if (cmdParms != null)
            {
                foreach (MySqlParameter parm in cmdParms)
                    cmd.Parameters.Add(parm);
            }
        }

        public static int ExecuteNonQuery(string cmdText, MySqlParameter[] cmdParms)
        {
            MySqlCommand cmd = new MySqlCommand();
            using (MySqlConnection conn = new MySqlConnection(strConn))
            {
                PrepareCommand(cmd, conn, cmdText, cmdParms);
                int val = cmd.ExecuteNonQuery();
                cmd.Parameters.Clear();
                conn.Close();
                return val;
            }
        }

        public static void ExecuteNonQuery(string cmdText)
        {
            ExecuteNonQuery(cmdText, null);
        }

        public static object ExecuteScalar(string cmdText, MySqlParameter[] cmdParms)
        {
            MySqlCommand cmd = new MySqlCommand();
            using (MySqlConnection conn = new MySqlConnection(strConn))
            {
                PrepareCommand(cmd, conn, cmdText, cmdParms);
                object obj = cmd.ExecuteScalar();
                cmd.Parameters.Clear();
                conn.Close();
                return obj;
            }
        }

        public static DataSet ExecuteDataSet(string cmdText, MySqlParameter[] cmdParms)
        {
            MySqlCommand cmd = new MySqlCommand();
            using (MySqlConnection conn = new MySqlConnection(strConn))
            {
                PrepareCommand(cmd, conn, cmdText, cmdParms);
                MySqlDataAdapter adpt = new MySqlDataAdapter();
                adpt.SelectCommand = cmd;
                DataSet ds = new DataSet();
                adpt.Fill(ds);
                cmd.Parameters.Clear();
                conn.Close();
                return ds;
            }
        }

        public static DataSet ExecuteDataSet(string cmdText)
        {
           return ExecuteDataSet(cmdText, null);
        }

        public static DataTable ExecuteDataTable(string cmdText, MySqlParameter[] cmdParms)
        {
            MySqlCommand cmd = new MySqlCommand();
            using (MySqlConnection conn = new MySqlConnection(strConn))
            {
                PrepareCommand(cmd, conn, cmdText, cmdParms);
                MySqlDataAdapter adpt = new MySqlDataAdapter();
                adpt.SelectCommand = cmd;
                DataSet ds = new DataSet();
                adpt.Fill(ds);
                cmd.Parameters.Clear();
                conn.Close();
                return ds.Tables[0];
            }
        }

        public static DataTable ExecuteDataTable(string cmdText)
        {
            return ExecuteDataTable(cmdText, null);
        }

        public static MySqlDataReader GetDataReader(string cmdText, MySqlParameter[] cmdParms)
        {
            MySqlCommand cmd = new MySqlCommand();
            MySqlConnection conn = new MySqlConnection(strConn);
            try
            {
                PrepareCommand(cmd, conn, cmdText, cmdParms);
                MySqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                cmd.Parameters.Clear();
                return reader;
            }
            catch
            {
                conn.Close();
                throw;
            }
        }
    }
}

