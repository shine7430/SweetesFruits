using AllTrustUs.WXPayAPILib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

/// <summary>
/// Summary description for EmailHelper
/// </summary>
namespace AllTrustUs.SquirrelPocket.Utility
{
    public class EmailHelper
    {
        public EmailHelper()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void SendMail(string subject, string body)
        {
            System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();
            msg.To.Add("chaohui_shen@163.com");
            //msg.To.Add("shine.shen@joowin.net");
            //msg.To.Add("569812788@qq.com");
            //msg.To.Add(b@b.com); 
            /* 
            * msg.To.Add("b@b.com"); 
            * msg.To.Add("b@b.com"); 
            * msg.To.Add("b@b.com");可以发送给多人 
            */
            //msg.CC.Add("c@c.com");
            /* 
            * msg.CC.Add("c@c.com"); 
            * msg.CC.Add("c@c.com");可以抄送给多人 
            */
            msg.From = new MailAddress("SquirrelPackage@163.com", "SquirrelPackage", System.Text.Encoding.UTF8);
            /* 上面3个参数分别是发件人地址（可以随便写），发件人姓名，编码*/
            msg.Subject = subject;//邮件标题 
            msg.SubjectEncoding = System.Text.Encoding.UTF8;//邮件标题编码 
            msg.Body = body;//邮件内容 
            msg.BodyEncoding = System.Text.Encoding.UTF8;//邮件内容编码 
            msg.IsBodyHtml = true;//是否是HTML邮件 
            msg.Priority = MailPriority.High;//邮件优先级 

            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("squirrelpackage@163.com", "1qaz2wsx");
            //在zj.com注册的邮箱和密码 
            client.Host = "smtp.163.com";
            object userState = msg;
            try
            {
                client.Send(msg);
                //简单一点儿可以client.Send(msg); 
                //MessageBox.Show("发送成功"); 
            }
            catch (System.Net.Mail.SmtpException ex)
            {
                //MessageBox.Show(ex.Message, "发送邮件出错"); 
                Log.Info(this.GetType().ToString(), ex.Message + ex.StackTrace);
            }
        }
    }
}