<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MyInfo.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.MyInfo" %>

<link href="/css/lanren.css" rel="stylesheet" />
<style>
    .main-body {
        margin-bottom: 20px;
    }

    .main-body {
        padding-top: 0px;
    }

    .form-control {
        height: 32px !important;
    }

    .settings .userinfo {
        height: 95px;
        padding: 20px 20px;
    }

    .settings .normal {
        height: 45px;
    }

    #main {
        background-color: inherit;
    }

    a:active {
        text-decoration: none !important;
    }

    .settings .normal span.title {
        display: block;
        margin: 6px 0 0 0;
        font-size: 16px;
        line-height: 16px;
        color: #444;
        float: left;
    }

    .settings .normal span.content {
        display: block;
        margin: inherit;
        font-size: 16px;
        line-height: 16px;
        color: #444;
        float: right;
        margin-right: 25px;
        margin-top: 6px;
        float: right;
    }

    div.content {
        background-color: #f4f4f4;
        padding-top: 30px;
    }
</style>

<script>
    var _openid = '<%=CurrentWeXUser.openid %>';
    $(document).ready(function () {
        setMeun("mMy");
        var baseHeight = $(window).height();
        $(window).resize(function () {
            var resizeHeight = $(window).height();
            if (resizeHeight < baseHeight) {
                $("#main").hide();
            }
            else {
                $("#main").show();
            }

        });
    });
    function Savevalue() {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });

        $.ajax({
            type: "POST",
            url: "../Handlers/OrderHandler.ashx",
            contentType: "application/x-www-form-urlencoded", //必须有
            data: {
                Action: "saveuserinfo", openid: _openid,
                userdata: JSON.stringify({
                    nickname: $("#txtnickname").val(),
                    country: $("#txtcountry").val(),
                    province: $("#txtprovince").val(),
                    city: $("#txtcity").val(),
                    sex: $("#txtsexCN").val(),
                    mp: $("#txtmp").val()
                })
            },
            //currentorder.toString()
            success: function (returndata) {
                var result = JSON.parse(returndata);
                if (result.result == "successed") {
                    layer.closeAll('loading');
                    //layer.msg("感谢您的预定，小伙伴会尽快联系您。", { icon: 6 }, function () {
                    //    window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
                    //    //do something
                    //});
                    layer.alert("保存成功");
                    window.location.href = "/home.aspx";

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
<form id="signupForm" runat="server">
    <div class="container midcontent">
        <div class="content">
            <div class="row order">
                <div class="col-sm-4">
                    <div class="form-group">
                        <img style="width: 80px; margin: auto; display: block; border-radius: 200px;"
                            src="<%=CurrentWeXUser.headimgurl %>" />
                    </div>
                </div>
            </div>
        </div>
        <div id="mainBody" class="wrapper">
            <div class="main-body">
                <div class="body-scroll">
                    <div class="settings-space"></div>
                    <div class="settings">
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-sns-account"></i>
                                <span class="title">平台昵称</span>
                                <input id="txtnickname" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control"  value="<%=CurrentWeXUser.nickname %>" />
                            </div>
                        </a>
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-sns-account"></i>
                                <span class="title">性别</span>
                                <input id="txtsexCN" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control"  value="<%=CurrentWeXUser.sexCN %>" />
                            </div>
                        </a>
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-sns-account"></i>
                                <span class="title">国家</span>
                                <input id="txtcountry" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control"  value="<%=CurrentWeXUser.country %>" />
                            </div>
                        </a>
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-sns-account"></i>
                                <span class="title">省</span>
                                <input id="txtprovince" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control" value="<%=CurrentWeXUser.province %>" />
                            </div>
                        </a>
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-msg-settings"></i>
                                <span class="title">地区</span>
                                <input id="txtcity" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control" value="<%=CurrentWeXUser.city %>" />
                            </div>
                        </a>
                        <a href="#">
                            <div class="item normal">
                                <i class="icon icon-msg-settings"></i>
                                <span class="title">手机号</span>
                                <input id="txtmp" name="edit" style="width: 50%; float: right; margin-right: 20px; height: 30px; text-align: right;"
                                    class="form-control" value="<%=CurrentWeXUser.MP %>" type="number"/>
                                <i class="arrow arrow-go"></i>
                            </div>
                        </a>
                    </div>
                    <div class="settings-space"></div>
                </div>
            </div>

        </div>

        <div class="row">
            <div class="col-sm-4">
                <input id="btnPay" type="button" onclick="Savevalue();" value="保存信息" class="PayButton" />
            </div>
        </div>
    </div>
</form>

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
        <a data-tab="photos" href="/Order/CartPage.aspx">
            <div class="item">
                <div class="cover ele4"></div>
                <span>我的订单</span>
            </div>
        </a>
        <a data-tab="me" class="checked" href="/Order/MyPage.aspx">
            <div class="item">
                <div class="cover ele5"></div>
                <span>我的</span>
            </div>
        </a>
    </div>
</div>--%>
