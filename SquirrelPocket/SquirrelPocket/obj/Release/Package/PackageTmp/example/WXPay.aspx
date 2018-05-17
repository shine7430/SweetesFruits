<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WXPay.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.WXPay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>松鼠兜兜-支付</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
               <script type="text/javascript">

                   //调用微信JS api 支付
                   function jsApiCall()
                   {
                       WeixinJSBridge.invoke(
                       'getBrandWCPayRequest',
                       <%=wxJsApiParam%>,//josn串
                    function (res)
                    {
                        WeixinJSBridge.log(res.err_msg);
                        alert(res.err_code + res.err_desc + res.err_msg);
                    }
                    );
               }

               function callpay()
               {
                   if (typeof WeixinJSBridge == "undefined")
                   {
                       alert("WeixinJSBridge undefined");
                       if (document.addEventListener)
                       {
                           document.addEventListener('WeixinJSBridgeReady', jsApiCall, false);
                       }
                       else if (document.attachEvent)
                       {
                           document.attachEvent('WeixinJSBridgeReady', jsApiCall);
                           document.attachEvent('onWeixinJSBridgeReady', jsApiCall);
                       }
                   }
                   else
                   {
                       jsApiCall();
                   }
               }
               
     </script>
<body>
    <form id="form1" runat="server">
            <input type="button" onclick="callpay();" value="立即支付2" style="width:210px; height:50px; border-radius: 15px;background-color:#00CD00; border:0px #FE6714 solid; cursor: pointer;  color:white;  font-size:16px;" >
    </form>
</body>
</html>
