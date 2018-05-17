<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Home.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.Home" %>
<script>
    $(function () {

        if (navigator.userAgent.match(/MicroMessenger/i)) {
            var weixinShareLogo = 'http://www.trustus.cn/images/300/logo/446994937272846516.png';

            $('body').prepend('<div style=" overflow:hidden; width:0px; height:0; margin:0 auto; position:absolute; top:-800px;"><img src="' + weixinShareLogo + '"></div>')

        };
        setMeun("mHome");
    })
</script>
<!--header-->
<div class="container midcontent">
    <%--    <div class="header">
        <div class="top-nav">
            <span class="menu">
                <img src="images/menu.png" alt="">
            </span>
            <ul>
                <li class="active"><a href="/order/home.aspx">首页 </a></li>
                <li><a href="/order/SquirrelOrderPage.aspx">下订单 </a></li>

                <!--<li><a href="about.html"> About </a></li>-->
                <!--<li><a href="page.html" > Typo</a></li>-->
                <!--<li><a href="gallery.html">Gallery</a></li>-->
                <li><a href="contact.html">联系我们</a></li>
                <div class="clearfix"></div>
            </ul>
            <script>
                $("span.menu").click(function () {
                    $(".top-nav ul").slideToggle(500, function () {
                    });
                });
            </script>
        </div>

    </div>--%>
    <!--//header-->
    <!--banner-->
    <div class="banner">

        <div class="col-md-4 banner-top">
            <img src="images/1-banner_AU_Org.jpg" class="img-responsive">
            <div class="top-banner">
                <h3>南半球馈赠 <span>澳洲橙</span></h3>
            </div>
        </div>
        <div class="col-md-4 banner-top">
            <img src="images/1-banner_US_Grape.jpg" class="img-responsive">
            <div class="top-banner1">
                <h3>美国进口  <span>无籽黑提</span></h3>
            </div>
        </div>
        <div class="col-md-4 banner-top">
            <img src="images/1-banner_NZ_GF.jpg" class="img-responsive">
            <div class="top-banner2">
                <h3>新西兰 <span>金果 </span></h3>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>
    <!--//banner-->
    <!--content-->
    <div class="content">
        <div class="welcome">
            <h1 style="font-size: 25px">一次预定，进口水果天天吃</h1>
            <p>健康生活每一天</p>
            <div class="welcome-top">
                <div class="col-md-3 bottom-products">
                    <ul>
                        <li><a href="#"><i></i>每天新鲜组合</a></li>
                        <li><a href="#"><i></i>固定时间配送</a></li>
                    </ul>
                </div>
                <div class="col-md-3 bottom-products">
                    <ul>
                        <li><a href="#"><i></i>私人定制搭配</a></li>
                        <li><a href="#"><i></i>企业长期合作</a></li>
                    </ul>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
        <!--//welcome-->
        <!--products-->
        <div class="products">
<%--            <div class="products-top">
                <h2>服务</h2>
            </div>
            <div style="text-align: center">
                <span class="menu">
                    <img src="images/market.png" style="width: 100px;" alt="">
                </span>
            </div>--%>

            <div class="products-bottom">
                <div class="col-md-3 bottom-products">
                    <a href="../Order/CommunityOrderPage.aspx">
                        <img class="img-responsive" src="images/300/shimaoyuntu.png" style="border-radius: 0px;" />
                    </a>
                    <p>世茂云图社区</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <a href="#">
                        <img src="images/300/shxxdl.png" class="img-responsive" style="border-radius: 0px;" />
                    </a>
                    <p>上海信息大楼</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <a href="#">
                        <img src="images/300/defalut.png" class="img-responsive" style="border-radius: 0px;" />
                    </a>
                    <p>敬请期待</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <a href="#">
                        <img class="img-responsive" src="images/300/defalut.png" style="border-radius: 0px;" />
                    </a>
                    <p>敬请期待</p>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>

        <div class="products">
            <div class="products-top">
                <h2>果品</h2>
                <p>澳大利亚、美国、新西兰、台湾、缅甸、泰国、越南、突尼斯</p>
            </div>
            <div class="products-bottom">
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/Org-1-300.jpg" />
                    <p>澳洲橙</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/Orgblood-2-300.jpg" />
                    <p>澳洲血橙</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/Prune-1-300.jpg" />
                    <p>美国西梅</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/Cherries-1-300.jpg" />
                    <p>美国车厘子</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/Blackgrape-1.300.jpg" />
                    <p>美国黑提</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/huolongdan-1-300.jpg" />
                    <p>美国红宝石恐龙蛋</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/hamigua-1-300.jpg" />
                    <p>缅甸哈密瓜</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/wendan-1-300.jpg" />
                    <p>台湾麻豆文旦</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/cuitianshi-1-300.jpg" />
                    <p>台湾脆甜柿</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/mangguo-1-300.jpg" />
                    <p>台湾芒果</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/fengli-1-300.jpg" />
                    <p>台湾金钻凤梨</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/jinyou-1-300.jpg" />
                    <p>泰国金柚</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/shanzhu-1-300.jpg" />
                    <p>泰国山竹</p>
                </div>

                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/hongmaodan-1-300.jpg" />
                    <p>泰国红毛丹</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/shiliu-1-300.jpg" />
                    <p>突尼斯软籽石榴</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/jinguo-1-300.jpg" />
                    <p>新西兰金果</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/huolongguobaixin-1-300.jpg" />
                    <p>越南白心火龙果</p>
                </div>
                <div class="col-md-3 bottom-products">
                    <img class="img-responsive" src="images/300/huolongguohongxin-1-300.jpg" />
                    <p>越南红心火龙果</p>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
        <!--//products-->
        <!--events-->
        <div class="content-mid">
            <div class="products-top">
                <h2>关注松鼠兜兜</h2>
            </div>
            <div class="news">
                <div class="col-md-6 new-more">
                    <img class="img-responsive" src="images/ewm.png" style=" margin: auto;" />
                    <div style=" margin: auto;display: table;" >长按识别图中二维码</div>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
        <!--//events-->


    </div>
    <!--//content-->
    <!--footer-->
    <div class="footer">
        <!--newsletter-->
        <!--<div class="newsletter">
                <h3>Newsletter</h3>
                <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard</p>
                <form>
                        <input type="text" value="" onfocus="this.value='';" onblur="if (this.value == '') {this.value ='';}">
                        <input type="submit" value="SUBSCRIBE">
                    </form>
            </div>-->
        <!--//newsletter-->
        <div class="footer-top-top">
            <div class="col-md-4 footer-top">
                <p>上海市浦东新区三林路88弄明通文化创意产业园1号楼1B307室</p>
                <p>TEL:+86 0 13636567107</p>
            </div>
            <div class="col-md-4 footer-top">
                <p class="footer-class">
                    Copyright &copy; 2016.上海醒信信息科技有限公司<br />
                    All rights reserved.
                </p>
            </div>
            <div class="col-md-4 footer-top" style="height: 30px; width: 100%">
            </div>
            <div class="clearfix"></div>
        </div>
    </div>
</div>
<!--//footer-->
<script>
    function shareTimeline() {
        WeixinJSBridge.invoke('shareTimeline', {
            "img_url": "http://www.alltrustus.com/images/300/logo/446994937272846516.png",
            "link": "http://www.alltrustus.com",
            "desc": "进口水果天天享用",
            "title": "松鼠兜兜果果"
        }, function (res) {
            alert("分享成功");
            //_report('timeline', res.err_msg);
        });
    }


    function shareFriend() {
        WeixinJSBridge.invoke('sendAppMessage', {
            //"appid":window.shareData.appid,
            "img_url": "http://www.alltrustus.com/images/300/logo/446994937272846516.png",
            "link": "http://www.alltrustus.com",
            "desc": '进口水果天天享用',
            "title": '松鼠兜兜果果'
        }, function (res) {
            alert("分享成功");
            //_report('send_msg', res.err_msg);
        })
    }

</script>
