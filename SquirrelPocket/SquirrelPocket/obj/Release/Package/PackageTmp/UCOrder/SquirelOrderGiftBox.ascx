<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SquirelOrderGiftBox.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.SquirelOrderGiftBox" %>
<style>
    .radio label, .checkbox label {
        padding-left: 10px;
    }

    .row.group, .form-group.group {
        display: none;
    }

    ul.thumbnails.image_picker_selector li .thumbnail {
        border: inherit;
    }

    .ValidateSussess {
        color: #65a032;
        font-weight: bolder;
        border: 1px solid #65a032;
    }

    .ValidateFailed {
        background-color: #FAEBD7 !important;
        color: #FF4500;
        font-weight: bolder;
        border: 1px solid #FF4500;
    }
</style>
<script src="/js/boxfruitsJson.js?v=1.4"></script>
<script src="/js/LArea/LArea.js"></script>
<script src="/js/LArea/LAreaDataGroupArea.js"></script>
<link href="/css/LArea.css?v=1.0.0" rel="stylesheet" />
<script src="../js/jquery-format/cleave.min.js"></script>
<script>
    var _openid = '<%=CurrentWeXUser.openid %>';
    var currentorder = orderbase;
    currentorder.unitprice = "298";
    var _ordertype = "single";
    var _otheraddr = false;
    $(document).ready(function () {
        setMeun("mMyOrder");
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

        var unitprice = getQueryString("unitprice");
        var cleave = new Cleave('#txtGiftCardCode', {
            delimiter: '-',
            blocks: [4, 4, 4, 4],
            uppercase: true
        });
        setSingleOrdervalidate();
        $(".TrustRadio").checkboxradio();
        $(".TrustRadio.group").checkboxradio({ mini: true });
        $(".TrustRadioUseGiftCard").checkboxradio({ mini: true });
        generateDescription(boxfruitMA298);
        $("label.ui-checkboxradio-label").click(function () {
            var _id = $(this).attr("for");
            var _unitp = $("#" + _id).attr("data-price");
            switch (_unitp) {
                case "298":
                    $(".row.order").show();
                    $(".row.group").hide();
                    generateDescription(boxfruitMA298);
                    $("#typeimg img").attr("src", "../images/MidAutumn2017/MD298.png");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    caculateDaysAndCost();
                    break;
                case "398":
                    $(".row.order").show();
                    $(".row.group").hide();
                    generateDescription(boxfruitMA398);
                    $("#typeimg img").attr("src", "../images/MidAutumn2017/MD398.png");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    caculateDaysAndCost();
                    break;
                case "498":
                    $(".row.order").show();
                    $(".row.group").hide();
                    generateDescription(boxfruitMA498);
                    $("#typeimg img").attr("src", "../images/MidAutumn2017/MD498.png");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    caculateDaysAndCost();
                    break;

            }
        });
       
        caculateDaysAndCost();
        switch (unitprice) {
            case "298":
                $("label[for='radio-Type298']").click();
                break;
            case "398":
                $("label[for='radio-Type398']").click();
                break;
            case "498":
                $("label[for='radio-Type498']").click();
                break;
            default:
                break;
        }
        //加的效果
        $(".gw_num.single .add").click(function () {
            var n = $(this).prev().val();
            var num = parseInt(n) + 1;
            if (num == 0) { return; }
            $(this).prev().val(num);
            currentorder.count = num;
            caculateDaysAndCost();
        });
        //减的效果
        $(".gw_num.single .jian").click(function () {
            var n = $(this).next().val();
            var num = parseInt(n) - 1;
            if (num == 0) { return }
            $(this).next().val(num);
            currentorder.count = num;
            caculateDaysAndCost();
        });

        var isall = false;
        $("#laberradio-UseGiftCard").click(function () {
            if (!isall) {
                $("#divgiftcard").show();
                isall = true;
            }
            else {
                $("#divgiftcard").hide();
                resetGiftCard();
                isall = false;
            }
        });
    });


    function setSingleOrdervalidate() {
        $("#signupForm").validate({
            rules: {
                Address: "required",
                Contacter: "required",
                ContacterMP: {
                    required: true,
                    minlength: 11
                    // 自定义方法：校验手机号在数据库中是否存在
                    // checkPhoneExist : true,
                    //isMobile: true
                }
                //email: {
                //    required: true,
                //    email: true
                //},
                //mobile: "required"

            },
            messages: {
                Address: "* 请填写详细地址",
                Contacter: "* 请填写联系人",
                ContacterMP: {
                    required: "* 请填写联系人手机",
                    minlength: "* 确认手机不能小于11个字符"
                }
            }
        });
    }

    $.validator.setDefaults({
        submitHandler: function () {

            debugger;
            //layer.load(0, { shade: 0.1 });
            if (_ordertype == "single") {
                getvalue();
                generaldailyfruit();
            }
            else {
                getGroupvalue();
            }
            //return;
            //window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
            //if (currentorder.fruits.length <= 0) {
            //    layer.alert("请选择水果。");
            //    return;
            //}
            var index = layer.load(1, {
                shade: [0.5, '#fff'] //0.1透明度的白色背景
            });

            //return;
            $.ajax({
                type: "POST",
                url: "../Handlers/OrderHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "order", orderdata: JSON.stringify(currentorder) },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {
                        layer.closeAll('loading');

                        if (currentorder.actualprice == 0) {
                            window.location.href = "/Order/SquirrelOrderDetailPage.aspx?order_id=" + result.orderid;
                        }
                        else {
                            window.location.href = "/Order/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.actualprice * 100 + "&order_id=" + result.orderid;
                        }
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
    });

    function getvalue() {

        //debugger;
        var currentsfruit = [];

        currentorder.openid = _openid;
        var _today = new Date();
        currentorder.fruittype = $(".radio input[name='radio-Type']:checked").val();
        currentorder.startdate = _today.Format("yyyy-MM-dd");
        currentorder.enddate = _today.Format("yyyy-MM-dd");
        currentorder.count = $(".gw_num.single input").val();
        currentorder.otheraddr = "0";
        currentorder.deliveryaddr = $("#txtAddr").val();
        currentorder.user = $("#txtContacter").val();
        currentorder.mp = $("#txtContacterMP").val();

    }

    function caculateDaysAndCost() {

        currentorder.days = 1;
        currentorder.totalprice = currentorder.unitprice * currentorder.count * currentorder.days;
        var _actrulprice = currentorder.totalprice - currentorder.deduction;
        if (_actrulprice <= 0) {
            _actrulprice = 0;
        }
        currentorder.actualprice = _actrulprice;
        $("span[name='spanportion']").text(currentorder.count * currentorder.days);
        $("span[name='spandeduction']").text("-" + currentorder.deduction);
        $("span[name='spanTotalPrice']").text(currentorder.totalprice);
        $("span[name='spanActualPrice']").text(_actrulprice);
    }

    function generateDescription(boxfruits) {
        $("#typeDes").html("");
        for (var i = 0; i < boxfruits.length; i++) {
            $("#typeDes").append("-" + boxfruits[i].name + "<br/>");
        }
    }

    function generaldailyfruit() {

        currentorder.deliverys = [];

        var typecount = 2;
        switch (currentorder.unitprice) {
            case "298":
                currentorder.fruits = boxfruitMA298;
                break
            case "398":
                currentorder.fruits = boxfruitMA398;
                break;
            case "498":
                currentorder.fruits = boxfruitMA498;
                break;
            default:
                break;
        }

        var deliverys = [];

        var _fruit = [];
        for (var j = 0; j < currentorder.fruits.length; j++) {
            _fruit.push({ fruitid: currentorder.fruits[j].fruitid, name: currentorder.fruits[j].name, fruitNum: currentorder.fruits[j].fruitNum });
        }
        deliverys.push({ orderid: "", count: currentorder.count, date: (new Date()).Format("yyyy-MM-dd"), deliveryfruits: _fruit });

        currentorder.deliverys = deliverys;

    }


    function checkday(dt) {
        return dt.getDay() == 0 || dt.getDay() == 6 ? false : true;
    }

    function CheckCardCode() {
        if ($("#txtGiftCardCode").val().length == 19) {
            var index = layer.load(1, {
                shade: [0.5, '#fff'] //0.1透明度的白色背景
            });
            var giftCardCode = $("#txtGiftCardCode").val();
            $.ajax({
                type: "POST",
                url: "../Handlers/OrderHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getgiftcode", giftcode: giftCardCode },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);

                    if (result.result == "successed") {

                        if (new Date(result.giftcard.expireddate) < new Date()) {
                            $("#txtGiftCardCode").removeClass("ValidateSussess");
                            $("#txtGiftCardCode").addClass("ValidateFailed");
                            $("#cardValtext").text("礼品卷" + (new Date(result.giftcard.expireddate)).Format("yyyy/MM/dd") + "已过期！");
                            $("#cardValtext").css("color", "#FF4500");
                        }
                        else {
                            currentorder.deduction = result.giftcard.amount;
                            currentorder.GiftCardCode = $("#txtGiftCardCode").val();
                            caculateDaysAndCost();
                            $("#txtGiftCardCode").attr("readonly", "readonly");
                            $("#txtGiftCardCode").removeClass("ValidateFailed");
                            $("#txtGiftCardCode").addClass("ValidateSussess");
                            $("#cardValtext").text("验证成功！");
                            $("#cardValtext").css("color", "#65a032");
                        }
                    }
                    else {
                        $("#txtGiftCardCode").removeClass("ValidateSussess");
                        $("#txtGiftCardCode").addClass("ValidateFailed");
                        $("#cardValtext").text("验证失败！");
                        $("#cardValtext").css("color", "#FF4500");
                    }
                },
                error: function (x, e) {
                    layer.alert("消息发送异常，请重试。");
                },
                complete: function (x) {
                    //alert("complete");
                    layer.closeAll('loading');
                }
            });



        }
        else {
            //resetGiftCard();   
        }
    }

    function resetGiftCard() {
        currentorder.GiftCardCode = "";
        currentorder.deduction = 0;
        $("#txtGiftCardCode").removeClass("ValidateSussess");
        $("#txtGiftCardCode").removeClass("ValidateFailed");
        $("#cardValtext").text("");
        $("#txtGiftCardCode").val("");
        $("#txtGiftCardCode").removeAttr("readonly");
        caculateDaysAndCost();
    }
</script>

<form id="signupForm" runat="server">
    <div class="container midcontent">
        <div class="content">
            <div class="welcome" style="padding-top: 0px; padding-bottom: 0px;">
                <div class="welcome-top">
                    <div class="col-md-3 bottom-products">
                        <ul>
                            <li><a href="#"><i></i>进口高档水果</a></li>
                            <li><a href="#"><i></i>每天随意组合</a></li>
                        </ul>
                    </div>
                    <div class="col-md-3 bottom-products">
                        <ul>
                            <li><a href="#"><i></i>固定时间享用</a></li>
                            <li><a href="#"><i></i>每天切盘配送</a></li>
                        </ul>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">中秋礼盒</h3>
                        </div>
                        <div class="panel-body">
                            <div style="width: 60%; float: left">
                                <div class="radio m-b-15">
                                    <label for="radio-Type298">中秋礼盒 ￥298</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-Type298" data-price="298" value="中秋礼盒298" checked="checked" />
                                </div>
                                <div class="radio m-b-15">
                                    <label for="radio-Type398">中秋礼盒 ￥398</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-Type398" data-price="398" value="中秋礼盒398" />
                                </div>

                                <div class="radio m-b-15">
                                    <label for="radio-Type498">中秋礼盒 ￥498</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-Type498" data-price="498" value="中秋礼盒498" />
                                </div>
                            </div>
                            <div id="typeDes" style="width: 40%; float: right; margin-top: 20px;">
                            </div>
                            <div style="clear: both"></div>
                            <div class="form-group">
                                <span style="float: left; line-height: 30px; padding-right: 5px;">数量:</span>
                                <div class="gw_num single" style="float: left">
                                    <em class="jian">-</em>
                                    <input type="text" value="1" class="num" readonly="readonly" />
                                    <em class="add">+</em>
                                </div>
                                <span style="float: left; line-height: 30px; padding-right: 5px;">份</span>
                            </div>
                            <div class="form-group">
                                <div id="typeimg">
                                    <img class="img-responsive" src="../images/MidAutumn2017/MD298.png" style="border-radius: 0px; margin: 0 auto;" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--<div class="panel panel-danger">
                    <div class="panel-heading">
                        <h3 class="panel-title">Panel title</h3>
                    </div>
                    <div class="panel-body">
                        Panel content
                    </div>
                </div>-->
                </div>
            </div>

            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">配送信息</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">
                                <div class="form-group">
                                    <input class="form-control" placeholder="配送地址" name="Address" id="txtAddr" />
                                    <div style="clear: both"></div>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系人" name="Contacter" id="txtContacter" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系手机" name="ContacterMP" id="txtContacterMP" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label for="radio-UseGiftCard" id="laberradio-UseGiftCard" style="float: right;">使用礼品卷</label>
                    <input type="checkbox" class="TrustRadioUseGiftCard" name="radio-TypeGiftCard" id="radio-UseGiftCard" />
                </div>
            </div>
            <div class="row" id="divgiftcard" style="display: none">
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">礼品卷</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">
                                <div class="form-group">
                                    <input class="form-control" style="font-size: 18px; text-align: center;"
                                        placeholder="礼品卷验证码" id="txtGiftCardCode" onkeyup="CheckCardCode()" />
                                    <span id="cardValtext"></span>
                                    <div style="clear: both"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel-body" style="text-align: right;">
                        共<span style="padding: 0px 5px 0px 5px;" name="spanportion">0</span>份;<br />
                        合计： <span style="padding: 0px 5px 0px 5px;" name="spanTotalPrice">0</span>元;<br />
                        折扣：<span style="padding: 0px 5px 0px 5px;" name="spandeduction">0</span>元;<br />
                        <div style="font-weight: bold; color: red" >实付：<span name="spanActualPrice">0</span>元;
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="padding-bottom: 30px;">
                <input id="btnCreateOrder" type="submit" class="btn btn-primary btn-info" style="margin: auto; display: block; width: 50%" value="下 单" />
            </div>

        </div>
    </div>

</form>
<div id="main" class="wrapper">
    <div id="__bottombar" class="bottombar">
        <a data-tab="index" href="/Home.aspx">
            <div class="item">
                <div class="cover ele1"></div>
                <span>首页</span>
            </div>
        </a>
        <a data-tab="feeds" class="checked" href="/Order/SquirrelOrderPage.aspx">
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
        <a data-tab="me" href="/Order/MyPage.aspx">
            <div class="item">
                <div class="cover ele5"></div>
                <span>我的</span>
            </div>
        </a>
    </div>
</div>

<script>
    //var area2 = new LArea();
    //area2.init({
    //    'trigger': '#addressGroupArea',
    //    'valueTo': '#hidlocation',
    //    'keys': {
    //        id: 'value',
    //        name: 'text'
    //    },
    //    'type': 2,
    //    'data': [provs_data, citys_data, dists_data]
    //});

</script>
