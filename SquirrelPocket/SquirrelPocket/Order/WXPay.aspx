<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WXPay.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.WXPay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>松鼠兜兜-支付</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <!--theme-style-->
    <link href="../css/style.css?v=1.0.0" rel="stylesheet" type="text/css" media="all" />
    <link href="../css/bootstrap-overwrite.css?v=1.0.0" rel="stylesheet" />
    <style>
        .header-top {
            border-bottom: inherit !important;
        }

        div.picker ul.image_picker_selector li {
            width: 25%;
        }

        .container {
            margin-bottom: 60px;
        }

        .thumbnail {
            margin-bottom: 10px;
        }

            .thumbnail > img, .thumbnail a > img {
                border-radius: 20px;
            }

        ul.thumbnails.image_picker_selector li {
            margin: inherit !important;
        }

            ul.thumbnails.image_picker_selector li .thumbnail.selected {
                font-size: 8px;
                color: #FFFFFF;
            }

            ul.thumbnails.image_picker_selector li .thumbnail {
                font-size: 8px;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }

                ul.thumbnails.image_picker_selector li .thumbnail.selected {
                    background: #65a032 !important;
                }

        #signupForm label.error {
            margin-left: 10px;
            width: auto;
            display: inline;
        }


        #signupForm .form-control.error,
        #signupForm .form-control.error:active {
            border: 1px solid #f39800;
        }

        .PayButton {
            width: 50%;
            height: 40px;
            background-color: #00CD00;
            border: 0px #FE6714 solid;
            cursor: pointer;
            color: white;
            font-size: 16px;
            margin: 0 auto;
            display: block;
        }

        .form-control-static {
            padding-top: 0px;
            padding-bottom: 0px;
        }

        .list-group {
            float: left;
            width: 100%;
            border-bottom: 1px solid #faebcc;
        }

        .list-laber {
            float: left;
            width: 30%;
        }

        .list-content {
            float: left;
            width: 70%;
        }
    </style>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/layer/layer.js"></script>

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
                        //alert("err_code:"+res.err_code + "err_desc:"+res.err_desc + "err_msg:"+res.err_msg);
                        if(res.err_msg=='get_brand_wcpay_request:ok'){
                            alert('恭喜您，支付成功!');
                            $("#btnBackHome").show();
                            $("#btnPay").hide();
                        }else{
                            alert('支付失败,请重新尝试！');//这里一直返回getBrandWCPayRequest提示fail_invalid appid
                        }
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
    
    function showDeliveryDetail() {
        var order_id = '<%=order_id %>';
        $.ajax({
            type: "POST",
            url: "../Handlers/OrderHandler.ashx",
            contentType: "application/x-www-form-urlencoded", //必须有
            data: { Action: "getDeliveryDetail", orderid: order_id },
            //currentorder.toString()
            success: function (returndata) {
                var result = JSON.parse(returndata);
                if (result.result == "successed") {
                    $("#DeliContent .delitable").html("");
                    $("#DeliContent .delitable").append('<tr class="deli-head"><td>日期</td><td style="text-align:left">水果</td><td>份数</td></tr>');
                    $.each(result.deliverys, function () {
                        var _tr = '<tr>'
                        _tr += '<td>' + this.Date + '</>';
                        _tr += '<td style="text-align:left">'
                        $.each(this.Deliveryfruits, function (name, obj) {
                            _tr += obj.Name + ';</br>';
                        })
                        _tr += '</td>'
                        _tr += '<td style="text-align:center">' + this.Count + '</td>';

                        _tr += '</tr>';
                        $("#DeliContent .delitable").append(_tr);
                    });
                    layer.open({
                        type: 1,
                        title: false,
                        closeBtn: 0,
                        shadeClose: true,
                        skin: 'yourclass',
                        content: $("#DeliContent").html()
                    });

                }

            },
            error: function (x, e) {
                layer.alert("消息发送异常，请重试。");
            },
            complete: function (x) {
                //alert("complete");
            }
        });

    }
</script>
<body>
    <form id="form1" runat="server">
        <div id="header">
            <div class="container">
                <div class="content">
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="panel panel-warning">
                                <div class="panel-heading">
                                    <h3 class="panel-title">订单详情：</h3>
                                </div>
                                <div class="panel-body">
                                    <div class="form-group">

                                        <div class="list-group">
                                            <label class="list-laber">订单号:</label>
                                            <span class="list-content">
                                                <p><%=OrderPay.outtradeno %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">

                                        <div class="list-group">
                                            <label class="list-laber">提交时间:</label>
                                            <span class="list-content">
                                                <p><%=OrderPay.createdate %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">

                                        <div class="list-group">
                                            <label class="list-laber">拼盘方式:</label>
                                            <span class="list-content">
                                                <p><%=OrderPay.fruittype %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">享用时间:</label>
                                            <span class="list-content">
                                                <p><%=OrderPay.startdate %> 至 <%=OrderPay.enddate %> 共<%=OrderPay.days %>天</p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">水果清单:</label>
                                            <span class="list-content">
                                                <p><%=Fruitslist %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">总份数:</label>
                                            <span class="list-content">
                                                <p><%= Int32.Parse( OrderPay.days)*Int32.Parse(OrderPay.count) %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" id="divdelivery">

                                        <div class="list-group">
                                            <label class="list-laber">配送详情:</label>
                                            <span class="list-content">
                                                <p><a onclick="showDeliveryDetail()">点击查看详情</a></p>
                                            </span>
                                        </div>

                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">配送信息:</label>
                                            <span class="list-content">
                                                <p class="form-control-static"><%=OrderPay.deliveryaddr %></p>
                                                <p class="form-control-static"><%=OrderPay.user %> <%=OrderPay.mp %></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group" runat="server" id="divunit">
                                        <div class="list-group">
                                            <label class="list-laber">单价:</label>
                                            <span class="list-content">
                                                <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.unitprice %> 元</span></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">总费用:</label>
                                            <span class="list-content">
                                                <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.totalprice %> 元</span></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">折扣:</label>
                                            <span class="list-content">
                                                <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.deduction %> 元</span></p>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="list-group">
                                            <label class="list-laber">应付:</label>
                                            <span class="list-content">
                                                <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.actualprice %> 元</span></p>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4">
                        <div runat="server" id="divbutton">
                            <input id="btnPay" type="button" onclick="callpay();" value="立即支付" class="PayButton" />
                            <input id="btnBackHome" type="button" onclick="window.location.href='../home.aspx'" value="返回首页" class="PayButton" style="display: none;" />
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <div id="main" class="wrapper">
            <div id="__bottombar" class="bottombar">
                <a data-tab="index" href="/Home.aspx">
                    <div class="item">
                        <div class="cover ele1"></div>
                        <span>首页</span>
                    </div>
                </a>
                <a data-tab="feeds" href="/Order/SquirrelOrderPage.aspx">
                    <div class="item">
                        <div class="cover ele2"></div>
                        <span>社区预定</span>
                    </div>
                </a>
                <a data-tab="photos" class="checked" href="/Order/CartPage.aspx">
                    <div class="item">
                        <div class="cover ele4"></div>
                        <span>我的订单</span>
                    </div>
                </a>
                <a data-tab="me" href="/Order/MyPage.aspx">
                    <div class="item">
                        <div class="cover ele5"></div>
                        <span>我的</span>
                    </div>
                </a>
            </div>
        </div>
    </form>
    <style>
        .Dele-container {
            width: 300px;
            height: 400px;
            overflow-y: scroll;
        }

        .delitable {
            width: 90%;
            margin: auto;
        }

        table.delitable tr {
            border-bottom: 1px solid #faebcc;
            text-align: center;
        }

        table.delitable .deli-head {
            font-weight: bold;
            border-bottom: 2px solid #faebcc;
            text-align: center;
        }
    </style>
    <div style="display: none;" id="DeliContent">
        <div class="Dele-container">
            <table class="delitable">
            </table>
        </div>

    </div>
</body>
</html>

