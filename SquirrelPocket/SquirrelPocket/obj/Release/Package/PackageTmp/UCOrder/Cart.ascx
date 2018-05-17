<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Cart.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.Cart" %>
<div class="container midcontent">
    <style>
        .panel {
            margin-bottom: 5px;
        }

        .media {
            margin-top: 15px;
            border: 1px solid #faebcc;
            background-color: beige;
        }

        .media-bottom {
            padding-top: 5px;
            padding-bottom: 5px;
            height: 35px;
        }

        .trustus-button {
            float: right;
            font-size: 14px;
            margin-left: 5px;
            margin-right: 5px;
        }

            .trustus-button:active {
                background-color: #faebcc;
            }

        .media .media-body p {
            padding-top: 5px;
        }

        .media-body {
            padding: 5px 15px 5px 15px;
        }

        .media, .media-body {
            overflow: inherit;
        }

        .media-bottom {
            padding: 5px 15px 5px 15px;
        }

        .media {
            border: 1px solid beige;
        }

        .content {
            margin-bottom: 20px;
        }

        .container {
            padding-right: inherit;
            padding-left: inherit;
        }

        .header-top {
            padding-left: 15px;
            padding-right: 15px;
        }

        body {
            -webkit-touch-callout: none;
            -webkit-user-select: none;
            -khtml-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .nav > li {
            float: left;
            width: 25%;
            text-align: center;
        }

        .navbar-nav {
            margin: 0 auto;
        }

        .navbar {
            min-height: 40px;
            margin-bottom: 5px;
            position: fixed;
            width: 100%;
        }

        .content {
            margin-top: 50px;
        }

        div.arrow.arrow-go {
            display: block;
            width: 16px;
            height: 16px;
            background: url(/images/btn-go-b.png) 0 0 no-repeat;
            background-size: 16px 16px;
            float: right;
            position: relative;
            top: -75px;
        }

        .media:active {
            background-color: #e7e7e7;
        }
    </style>
    <script>
        var _openid = '<%=CurrentWeXUser.openid %>';
        var timeout;
        $(document).ready(function () {
            setMeun("mMyOrder");
            $("ul.nav.navbar-nav li").removeClass("active");
            var CookieStatus = getCookie("CookieStatus");
            if (CookieStatus != null) {
                GetDetail(CookieStatus);
                $("ul.nav li[data-status='" + CookieStatus + "']").addClass("active");
            }
            else {
                $("ul.nav li[data-status='NotPaid']").addClass("active");
                GetDetail("NotPaid");
            }

            $("ul.nav.navbar-nav li").click(function () {
                var status = $(this).attr("data-status");
                $("ul.nav.navbar-nav li").removeClass("active");
                $(this).addClass("active");
                GetDetail(status);
                setCookie("CookieStatus", status);
            });
        })

        function GetDetail(status) {
            var index = layer.load(1, {
                shade: [0.1, '#fff'] //0.1透明度的白色背景
            });

            $.ajax({
                type: "POST",
                url: "../Handlers/OrderHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getorder", openid: _openid, status: status },
                async: true,
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {
                        layer.closeAll('loading');
                        $(".content.orderdata").html("");
                        for (var i = 0; i < result.orders.length; i++) {
                            $("#mediatemplate").html($("#mediatemplateCopy").html());

                            $("#mediatemplate h4[name='title']").text(result.orders[i].fruittype);
                            $("#mediatemplate div[name='createdate']").text(result.orders[i].createdate);
                            $("#mediatemplate p[name='fromtodate']").text(result.orders[i].startdate + " 至 " + result.orders[i].enddate + " 共 " + result.orders[i].days + " 天");
                            //$("#mediatemplate input[name='btngotopay']").attr("data-orderid", result.orders[i].orderid);
                            //$("#mediatemplate input[name='btngotopay']").attr("data-totalprice", result.orders[i].totalprice);
                            //$("#mediatemplate input[name='btnDetail']").attr("data-orderid", result.orders[i].orderid);
                            //$("#mediatemplate a[name='btncancel']").attr("data-orderid", result.orders[i].orderid);
                            $("#mediatemplate .media").attr("data-orderid", result.orders[i].orderid);
                            $("#mediatemplate .media").attr("data-status", result.orders[i].status);

                            switch (result.orders[i].status) {
                                case "NotPaid":
                                    $("#mediatemplate span[name='status']").text("未支付");
                                    $("#mediatemplate span[name='status']").css("color", "red");
                                    if (result.orders[i].otheraddr == "1") {
                                        $("#mediatemplate input[name='btngotopay']").hide();
                                        $("#mediatemplate span[name='status']").text("未支付(地址不在配送范围)");
                                    }
                                    break;
                                case "PaidSuccessed":
                                    $("#mediatemplate span[name='status']").text("已支付");
                                    $("#mediatemplate span[name='status']").css("color", "green");
                                    $("#mediatemplate input[name='btngotopay']").hide();
                                    $("#mediatemplate a[name='btncancel']").hide();

                                    break;
                                case "Completed":
                                    $("#mediatemplate span[name='status']").text("已完成");
                                    $("#mediatemplate span[name='status']").css("color", "silver");
                                    $("#mediatemplate input[name='btngotopay']").hide();
                                    $("#mediatemplate a[name='btncancel']").hide();
                                    break;
                                case "Canceled":
                                    $("#mediatemplate span[name='status']").text("已取消");
                                    $("#mediatemplate span[name='status']").css("color", "silver");
                                    $("#mediatemplate input[name='btngotopay']").hide();
                                    $("#mediatemplate a[name='btncancel']").hide();
                                    break;
                                case "Expiry":
                                    $("#mediatemplate span[name='status']").text("已过期");
                                    $("#mediatemplate span[name='status']").css("color", "silver");
                                    $("#mediatemplate input[name='btngotopay']").hide();
                                    break;
                                case "Refunded":
                                    $("#mediatemplate span[name='status']").text("已退款");
                                    $("#mediatemplate span[name='status']").css("color", "silver");
                                    $("#mediatemplate input[name='btngotopay']").hide();
                                    $("#mediatemplate a[name='btncancel']").hide();
                                    break;
                                default:
                                    break;

                            }

                            $("#mediatemplate span[name='totalprice']").text(result.orders[i].actualprice);
                            var _fruits = "";
                            for (var j = 0; j < result.orders[i].fruits.length; j++) {
                                _fruits += result.orders[i].fruits[j].Name + ";";
                            }
                            $("#mediatemplate p[name='fruits']").text(_fruits);
                            $(".content.orderdata").append($("#mediatemplate").html());

                        }
                    }
                },
                error: function (x, e) {
                    layer.alert("数据加载异常，请重新尝试！");
                },
                complete: function (x) {
                    //alert("complete");
                }
            });
        }

        function GotoDetail(btn) {
            var orderid = $(btn).attr("data-orderid");
            window.location.href = "/order/SquirrelOrderDetailPage.aspx?order_id=" + orderid;
        }

        function CancelOrder(btn) {

            var orderid = $(btn).attr("data-orderid");
            var _parent = $(btn).parent().parent();

            layer.msg('确定删除订单？', {
                shade: 0.3,
                time: 0 //不自动关闭
                          , btn: ['残忍删除', '继续保留']
                          , yes: function (index) {
                              $.ajax({
                                  type: "POST",
                                  url: "../Handlers/OrderHandler.ashx",
                                  contentType: "application/x-www-form-urlencoded", //必须有
                                  data: { Action: "deleteorder", orderid: orderid },
                                  //currentorder.toString()
                                  success: function (returndata) {
                                      var result = JSON.parse(returndata);
                                      if (result.result == "successed") {
                                          //_parent.find("span[name='status']").text("已取消");
                                          //_parent.find("span[name='status']").css("color", "silver");
                                          //_parent.find("input[name='btngotopay']").hide();
                                          _parent.hide();

                                          layer.close(index);
                                      }
                                  },
                                  error: function (x, e) {
                                      layer.alert("数据加载异常，请重新尝试！");
                                  },
                                  complete: function (x) {
                                      //alert("complete");
                                  }
                              });

                          }

            });


        }

        function GotoPay(btn) {
            var totalprice = $(btn).attr("data-totalprice");
            var orderid = $(btn).attr("data-orderid");
            window.location.href = "/Order/WXPay.aspx?openid=" + _openid + "&total_fee=" + totalprice * 100 + "&order_id=" + orderid;

        }

    </script>
    <nav class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <ul class="nav navbar-nav">
                <li data-status="NotPaid"><a href="#">未支付</a></li>
                <li data-status="PaidSuccessed"><a href="#">已支付</a></li>
                <li data-status="Refunded"><a href="#">已退款</a></li>
                <li data-status="Completed"><a href="#">已完成</a></li>
            </ul>
        </div>
    </nav>
    <div class="content orderdata">
    </div>
    <div id="mediatemplate" style="display: none">
    </div>

    <div id="mediatemplateCopy" style="display: none">
        <div class="media" data-orderid="" data-status="" onclick="GotoDetail(this)">
            <div class="media-body">
                <h4 class="media-heading" name="title" style="float: left"></h4>
                <%--                <a name="btncancel" data-orderid="" onclick="CancelOrder(this)">
                    <img src="../images/remove.png" style="float: right; margin-right: -15px; margin-left: 5px;" /></a>--%>

                <div name="createdate" style="float: right; color: #699301;"></div>

                <div style="clear: both"></div>

                <p name="fromtodate"></p>
                <p name="fruits" style="height: 45px; overflow-y: hidden;"></p>

            </div>
            <div class="media-bottom">
                <span style="float: left; color: red;">
                    <span style="font-size: 10px;">￥</span>
                    <span style="font-size: 1.5em; font-weight: bold" name="totalprice"></span>
                    <span style="font-size: 10px;" name="status"></span>
                </span>
                <%--                <input name="btngotopay" type="button" class="trustus-button" onclick="GotoPay(this);" style="background-color: #00CD00; border: 0px #FE6714 solid; cursor: pointer; color: white; font-size: 14px; font-weight: bold; box-shadow: 0 1px 3px #bebdbd; -webkit-box-shadow: 0 1px 3px #bebdbd;"
                    data-orderid="0" data-totalprice="0" value="去支付" />--%>
                <%--                <input name="btncancel" type="button" class="trustus-button" onclick="CancelOrder(this)" style="background-color: #A2A2A2; border: 0px #FE6714 solid; cursor: pointer; color: white; font-size: 14px; font-weight: bold; box-shadow: 0 1px 3px #bebdbd; -webkit-box-shadow: 0 1px 3px #bebdbd;"
                    data-orderid="0" value="取消订单" />--%>
                <%--                <input name="btnDetail" type="button" class="trustus-button" onclick="GotoDetail(this)" style="background-color: #A2A2A2; border: 0px #FE6714 solid; cursor: pointer; color: white; font-size: 14px; font-weight: bold; box-shadow: 0 1px 3px #bebdbd; -webkit-box-shadow: 0 1px 3px #bebdbd;"
                    data-orderid="0" value="详情" />--%>
            </div>
            <div class="arrow arrow-go"></div>
        </div>
    </div>
</div>

<%--<div id="main" class="wrapper">
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
                <span>马上下单</span>
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
    </div>--%>
</div>
