<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>松鼠兜兜果切</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <style>
        .errormsg {
            line-height: 150px;
            font-size: 30px;
        }

        .errorbody {
            padding: 30px;
            margin-top: 50px;
        }
       .PayButton {
            height: 30px;
            background-color: #00CD00;
            border: 0px #FE6714 solid;
            cursor: pointer;
            color: white;
            font-size: 16px;
        }
    </style>
    <script>
        function getArgs() {
            var args = new Object();
            var query = location.search.substring(1);      // Get query string
            var pairs = query.split("&");                  // Break at ampersand
            for (var i = 0; i < pairs.length; i++) {
                var pos = pairs[i].indexOf('=');           // Look for "name=value"
                if (pos == -1) continue;                   // If not found, skip
                var argname = pairs[i].substring(0, pos); // Extract the name
                var value = pairs[i].substring(pos + 1);     // Extract the value
                value = decodeURIComponent(value);         // Decode it, if needed
                args[argname] = value;                     // Store as a property
            }
            return args;                                   // Return the object
        }

        function retury() {
            var actionurl = getArgs()["ActionPage"]
            window.location.href = actionurl;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="errorbody">
            <div style="float: left;">
                <span class="errormsg">出现错误</span>
            </div>
            <div style="float: right;">
                <img height="200" src="/images/300/logo/598590637301884028.png" />
            </div>
            <div style="float: left;">
                <input id="btnGoHome" type="button" onclick="window.location.href='/Home.aspx'" value="返回首页" class="PayButton" />
            </div>

        </div>
    </form>
</body>
</html>
