<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="My.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.My" %>
<link href="/css/lanren.css" rel="stylesheet" />
<style>
    .main-body {
        margin-bottom: 59px;
    }

    .main-body {
        padding-top: 0px;
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
</style>
<script>
    $(document).ready(function () {
        setMeun("mMy");
    })
</script>
<div class="container midcontent">
    <div id="main" class="wrapper">
        <div class="main-body">
            <div class="body-scroll">
                <div style="padding: 0; height: 0;">&nbsp;</div>
                <div class="settings-space"></div>
                <div class="settings">
                    <a href="/order/MyInfoPage.aspx">
                        <div class="item userinfo">
                            <img class="face" src="<%=CurrentWeXUser.headimgurl %>" />
                            <div class="info">
                                <p class="nick"><%=CurrentWeXUser.nickname %></p>
                                <p class="location">进入我的主页</p>
                            </div>
                            <i class="arrow arrow-go"></i>
                        </div>
                    </a>
                </div>

                <div class="settings-space"></div>
                <div class="settings">
                    <a href="/order/CartPage.aspx">
                        <div class="item normal">
                            <i class="icon icon-sns-account"></i>
                            <span class="title">我的订单</span>
                            <i class="arrow arrow-go"></i>
                        </div>
                    </a>
                    <a href="/order/CommunityOrderPage.aspx">
                        <div class="item normal">
                            <i class="icon icon-sns-account"></i>
                            <span class="title">社区预定</span>
                            <i class="arrow arrow-go"></i>
                        </div>
                    </a>
                    <a href="/contact.html">
                        <div class="item normal">
                            <i class="icon icon-sns-account"></i>
                            <span class="title">联系我们</span>
                            <i class="arrow arrow-go"></i>
                        </div>
                    </a>
                    <a href="/Home.aspx">
                        <div class="item normal">
                            <i class="icon icon-msg-settings"></i>
                            <span class="title">返回首页</span>
                            <i class="arrow arrow-go"></i>
                        </div>
                    </a>
                </div>
                <div class="settings-space"></div>
            </div>
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
