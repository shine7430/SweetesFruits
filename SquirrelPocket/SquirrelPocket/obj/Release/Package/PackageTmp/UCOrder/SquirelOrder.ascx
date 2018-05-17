<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SquirelOrder.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.SquirelOrder" %>
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

</style>
<script src="/js/boxfruitsJson.js"></script>
<script src="/js/LArea/LArea.js"></script>
<script src="/js/LArea/LAreaDataGroupArea.js"></script>
<link href="/css/LArea.css?v=1.0.0" rel="stylesheet" />
<script>
    var _openid = '<%=CurrentWeXUser.openid %>';
    var currentorder = orderbase;
    var _ordertype = "single";
    var _otheraddr = false;
    $(document).ready(function () {
        setMeun("mOrder");
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
        setSingleOrdervalidate();
        //setGroupOrdervalidate();
        getStartDate();
        InitImagePicker(100);
        $(".TrustRadio").checkboxradio();
        $(".TrustRadio.group").checkboxradio({ mini: true });
        $(".TrustRadioSelectAll").checkboxradio({ mini: true });
        $("label.ui-checkboxradio-label").click(function () {
            var _id = $(this).attr("for");
            var _unitp = $("#" + _id).attr("data-price");
            switch (_unitp) {
                case "15":
                    $(".row.order").show();
                    $(".row.group").hide();
                    $("#typeimg img").attr("src", "../images/300/shuangpin-1-300.jpg");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    InitImagePicker(100);
                    caculateDaysAndCost();
                    break;
                case "20":
                    $(".row.order").show();
                    $(".row.group").hide();
                    $("#typeimg img").attr("src", "../images/300/sangpin-1-300.jpg");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    InitImagePicker(100);
                    caculateDaysAndCost();
                    break;
                case "30":
                    $(".row.order").show();
                    $(".row.group").hide();
                    $("#typeimg img").attr("src", "../images/300/duopin-1-300.jpg");
                    setSingleOrdervalidate();
                    _ordertype = "single";
                    currentorder.count = $(".gw_num.single .num").val();
                    currentorder.unitprice = _unitp;
                    InitImagePicker(100);
                    caculateDaysAndCost();
                    break;
                case "X":
                    $(".row.order").hide();
                    $(".row.group").show();
                    currentorder.count = $(".ordercount .gw_num.group .num").val();
                    $("#typeimg img").attr("src", "../images/300/lihe-1-300.jpg");
                    currentorder.unitprice = "0";
                    setGroupOrdervalidate();
                    caculateDaysAndCostGroup();
                    InitImagePicker(100);
                    _ordertype = "group";
                    $(".row.group .thumbnails.image_picker_selector .thumbnail").click(function () {
                        var img = $(this).find("img");
                        var id = img.attr("src").substring(img.attr("src").indexOf("?id=") + 4, img.attr("src").length);
                        var _selectf = "";
                        $.each(boxfruits, function () {
                            if (this.id == id) {
                                //do matters
                                _selectf = this;
                                return;
                            }
                        })

                        if (!$(this).hasClass("selected")) {
                            removeGroupFruit(_selectf.id);
                            return;
                        }

                        $("#groupfruitadd .groupcomments").html(_selectf.comments);
                        $("#btnAdd").attr("data-fruitid", _selectf.id);
                        $("#btnAdd").attr("data-fruitname", _selectf.name);
                        $("#btnAdd").attr("data-unitprice", _selectf.unitprice);
                        $("#btnAdd").attr("data-unit", _selectf.unit);
                        $("#btnAdd").attr("data-fruitNum", _selectf.fruitNum);

                        layer.open({
                            type: 1,
                            title: false,
                            closeBtn: 1,
                            area: '80%',
                            skin: 'white', //没有背景色
                            shadeClose: true,
                            content: $('#groupfruitadd')
                        });
                    });
                    break;
            }



        });


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

        //加的效果
        $(".unitcount .gw_num.group .add").click(function () {
            var n = $(this).prev().val();
            var num = parseInt(n) + 1;
            if (num == 0) { return; }
            $(this).prev().val(num);

        });
        //减的效果
        $(".unitcount .gw_num.group .jian").click(function () {
            var n = $(this).next().val();
            var num = parseInt(n) - 1;
            if (num == 0) { return }
            $(this).next().val(num);

        });

        //加的效果
        $(".ordercount .gw_num.group .add").click(function () {
            var n = $(this).prev().val();
            var num = parseInt(n) + 1;
            if (num == 0) { return; }
            $(this).prev().val(num);
            currentorder.count = num;
            caculateDaysAndCostGroup();

        });
        //减的效果
        $(".ordercount .gw_num.group .jian").click(function () {
            var n = $(this).next().val();
            var num = parseInt(n) - 1;
            if (num == 0) { return }
            $(this).next().val(num);
            currentorder.count = num;
            caculateDaysAndCostGroup();

        });

        var isall = false;
        $("#laberradio-SelectALL").click(function () {
            if (!isall) {
                $(".picker.order ul.thumbnails.image_picker_selector li div.thumbnail").removeClass("selected");
                $(".picker.order ul.thumbnails.image_picker_selector li div.thumbnail").addClass("selected");
                $(".picker.order select.image-picker option").removeAttr("selected");
                $(".picker.order select.image-picker option").attr("selected", "true");
                isall = true;
            }
            else {
                $(".picker.order ul.thumbnails.image_picker_selector li div.thumbnail").removeClass("selected");
                $(".picker.order select.image-picker option").removeAttr("selected");
                isall = false;
            }
        });

        $("#btnAdd").click(function () {
            var _count = $(".unitcount .gw_num.group input").val();
            currentorder.fruits.push(
                {
                    fruitid: $(this).attr("data-fruitid"),
                    name: $(this).attr("data-fruitname"),
                    count: _count,
                    unit: $(this).attr("data-unit"),
                    unitprice: $(this).attr("data-unitprice"),
                    price: $(this).attr("data-unitprice") * _count,
                    fruitNum: $("#btnAdd").attr("data-fruitNum")
                });
            caculateDaysAndCostGroup();
            layer.closeAll();

        });

        $("#btnOtherAddr").click(function () {

            if (_otheraddr) {
                _otheraddr = false;
                $("#txtAddr").hide();
                $("#addrSelect").show();
                $("#btnOtherAddr").text("其他");
            }
            else {
                _otheraddr = true;
                $("#txtAddr").show();
                $("#addrSelect").hide();
                $("#btnOtherAddr").text("选择");

            }
            return false;

        });

    });

    function InitImagePicker(limited) {
        $("select.image-picker").imagepicker({
            limit: limited,
            show_label: true,
            limit_reached: function () {
                layer.alert("最多可以选择" + limited + "种水果。");
            }
        })


    }

    function setSingleOrdervalidate() {
        $("#signupForm").validate({
            rules: {
                StartDate: "required",
                EndDate: "required",
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
                StartDate: "* 请选择开始日期",
                EndDate: "* 请选择结束日期",
                Contacter: "* 请填写联系人",
                ContacterMP: {
                    required: "* 请填写联系人手机",
                    minlength: "* 确认手机不能小于11个字符"
                }
            }
        });
    }

    function setGroupOrdervalidate() {

        $("#txtStartDateGroup").rules("add", { required: true, messages: { required: "* 请选择期望配送日期" } });
        $("#addressGroupArea").rules("add", { required: true, messages: { required: "* 请填写收货小区" } });
        $("#txtaddressGroup").rules("add", { required: true, messages: { required: "* 请填写收货地址" } });
        $("#txtContacterGroup").rules("add", { required: true, messages: { required: "* 请填写联系人" } });
        $("#txtContacterMPGroup").rules("add",
            {
                required: true,
                minlength: 11,
                messages: {
                    required: "* 请填写联系人手机",
                    minlength: "* 确认手机不能小于11个字符"
                }
            });


    }

    $.validator.setDefaults({
        submitHandler: function () {
            //layer.load(0, { shade: 0.1 });
            debugger;
            if (_ordertype == "single") {
                getvalue();
                generaldailyfruit();
            }
            else {
                getGroupvalue();
            }
            //return;
            //window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
            if (currentorder.fruits.length <= 0) {
                layer.alert("请选择水果。");
                return;
            }
            var index = layer.load(1, {
                shade: [0.5, '#fff'] //0.1透明度的白色背景
            });
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
                        //layer.msg("感谢您的预定，小伙伴会尽快联系您。", { icon: 6 }, function () {
                        //    window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
                        //    //do something
                        //});
                        //if (_otheraddr) {
                        if (false) {
                            layer.msg("尊敬的客户您好，松鼠果兜已经记下您爱吃的水果种类，后续你所预定的大楼团购人数达到8人，我们将会开始配送，后续会及时更新信息给您，感谢您的支持。您身边的水果专家---松鼠果兜", { icon: 6 }, function () {
                                window.location.href = "/Order/CartPage.aspx";
                                //do something
                            });
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

        var currentsfruit = [];

        currentorder.openid = _openid;
        currentorder.fruittype = $(".radio input[name='radio-Type']:checked").val();
        currentorder.startdate = $("#txtStartDate").val();
        currentorder.enddate = $("#txtEndDate").val();
        currentorder.count = $(".gw_num.single input").val();
        if (_otheraddr) {
            currentorder.otheraddr = "0";
            currentorder.deliveryaddr = $("#txtAddr").val();
        }
        else {
            currentorder.otheraddr = "0";
            currentorder.deliveryaddr = $("#addrSelect").val();
        }
        currentorder.user = $("#txtContacter").val();
        currentorder.mp = $("#txtContacterMP").val();

        $(".picker.order .thumbnail.selected").each(function () {
            var imgsrc = $(this).find("img").attr("src");
            var name = $(this).text();
            var imgid = imgsrc.substring(imgsrc.indexOf("?id=") + 4, imgsrc.length)
            currentorder.fruits.push({ fruitid: imgid, name: name });
        });
    }
    function getGroupvalue() {

        currentorder.openid = _openid;
        currentorder.fruittype = $(".radio input[name='radio-Type']:checked").val();
        currentorder.startdate = $("#txtStartDateGroup").val();
        currentorder.count = $(".ordercount .gw_num.group input").val();
        currentorder.deliveryaddr = $("#addressGroupArea").val() + $("#txtaddressGroup").val();
        currentorder.user = $("#txtContacterGroup").val();
        currentorder.mp = $("#txtContacterMPGroup").val();
        currentorder.days = 1;
    }

    function getStartDate() {

        var _today = new Date();
        var daydiff = 0;
        if (_today.getDay() == 0) {
            daydiff = 7;
        }
        else {
            daydiff = 8 - _today.getDay();
        }
        //var firstMonday = dayAdd(_today, daydiff + diff);

        $("#txtStartDate").datepicker({
            beforeShowDay:
                function (dt) {
                    return [dt.getDay() == 0 || dt.getDay() == 2 || dt.getDay() == 3 || dt.getDay() == 4 || dt.getDay() == 5 || dt.getDay() == 6
                        || dt.Format("yyyy/MM/dd") == '2017/01/23'
                        || dt.Format("yyyy/MM/dd") == '2017/01/30' ? false : true];
                },
            dateFormat: "yy/mm/dd",
            minDate: daydiff,
            onSelect: function (sd) {
                caculateDaysAndCost();
            }

        });

        $("#txtEndDate").datepicker({
            beforeShowDay:
                function (dt) {
                    return [dt.getDay() == 0 || dt.getDay() == 1 || dt.getDay() == 2 || dt.getDay() == 3 || dt.getDay() == 4 || dt.getDay() == 6
                        || dt.Format("yyyy/MM/dd") == '2017/01/27'
                        || dt.Format("yyyy/MM/dd") == '2017/02/03' ? false : true];
                },
            dateFormat: "yy/mm/dd",
            minDate: daydiff,
            onSelect: function (ed) {
                caculateDaysAndCost();
            }

        });

        $("#txtStartDateGroup").datepicker({
            beforeShowDay:
                function (dt) {
                    //return [true];
                    return [dt.getDay() == 6 || dt.getDay() == 1 || dt.getDay() == 2 || dt.getDay() == 3 || dt.getDay() == 4 || dt.getDay() == 5
                        || dt.Format("yyyy/MM/dd") == '2017/01/23'
                        || dt.Format("yyyy/MM/dd") == '2017/01/30' ? false : true];
                },
            dateFormat: "yy/mm/dd",
            minDate: daydiff,
            onSelect: function (ed) {
                //caculateDaysAndCost()
            }

        });


    }

    function caculateDaysAndCost() {


        if ($("#txtStartDate").val() != "" && $("#txtEndDate").val() != "") {
            if (Date.parse($("#txtStartDate").val()) > Date.parse($("#txtEndDate").val())) {
                layer.alert("结束日期必须晚于开始日期");
                $("#txtEndDate").val("");
                return;
            }
            var daydiffdays = getWorkDayCount("en", $("#txtStartDate").val(), $("#txtEndDate").val());
            currentorder.days = daydiffdays;
            currentorder.totalprice = currentorder.unitprice * currentorder.count * currentorder.days;
            currentorder.actualprice = currentorder.totalprice - currentorder.deduction;

            $("span[name='spanDays']").text(currentorder.days);
            $("span[name='spanportion']").text(currentorder.count * currentorder.days);
            $("span[name='spanTotalPrice']").text(currentorder.totalprice);
            $("span[name='spanActualPrice']").text(currentorder.totalprice - currentorder.deduction);

        }
    }

    function caculateDaysAndCostGroup() {
        var _totalprice = 0;
        currentorder.totalprice = 0;
        $("#spangroupfruitlist").html("");
        $.each(currentorder.fruits, function () {
            _totalprice += this.price;
            $("#spangroupfruitlist").append(this.name + ": " + this.count + "份 " + this.price + "元</br>");
        })
        currentorder.totalprice = _totalprice * currentorder.count;
        $("span[name='spanTotalPriceGroup']").text(currentorder.totalprice);
    }

    function generaldailyfruit() {

        currentorder.deliverys = [];

        var typecount = 2;
        switch (currentorder.unitprice) {
            case "15":
                typecount = 2;
                break
            case "20":
                typecount = 3;
                break;
            case "30":
                typecount = 4;
                break;
            default:
                break;
        }

        var deliverys = [];
        var gstartdate = currentorder.startdate;
        var genddate = currentorder.enddate;
        var rangeNum = currentorder.fruits.length;

        var index = 0;
        for (var day = gstartdate; new Date(day) <= new Date(genddate) ; day = dayAdd(day, 1)) {
            if (checkday(new Date(day))) {
                var _fruit = [];
                for (var j = 0; j < typecount; j++) {
                    _fruit.push({ fruitid: currentorder.fruits[index % rangeNum].fruitid, name: currentorder.fruits[index % rangeNum].name });
                    index++;
                }
                deliverys.push({ orderid: "", count: currentorder.count, date: day, deliveryfruits: _fruit });
            }

        }

        currentorder.deliverys = deliverys;

    }

    function checkday(dt) {
        return dt.getDay() == 0 || dt.getDay() == 6 ? false : true;
    }

    function removeGroupFruit(fruitid) {
        var _removeindex = 0;
        $.each(currentorder.fruits, function () {
            if (this.fruitid == fruitid) {
                currentorder.fruits.splice(_removeindex, 1);
                return;
            }
            _removeindex++;
        })

        caculateDaysAndCostGroup();
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
                            <h3 class="panel-title">拼盘方式</h3>
                        </div>
                        <div class="panel-body">
                            <div style="width: 70%; float: left">
                                <div class="radio m-b-15">
                                    <label for="radio-Type2">双果任意拼(15元/份)</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-Type2" data-price="15" value="双果任意拼(15元/份)" checked="checked" />
                                </div>
                                <div class="radio m-b-15">
                                    <label for="radio-Type3">三果任意拼(20元/份)</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-Type3" data-price="20" value="三果任意拼(20元/份)" />
                                </div>

                                <div class="radio m-b-15">
                                    <label for="radio-TypeN">多果任意拼(30元/份)</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-TypeN" data-price="30" value="多果任意拼(30元/份)" />
                                </div>
                                <div class="radio m-b-15">
                                    <label for="radio-TypeP">精品礼盒DIY</label>
                                    <input type="radio" class="TrustRadio" name="radio-Type" id="radio-TypeP" data-price="X" value="精品礼盒DIY" />
                                </div>
                            </div>
                            <div id="typeimg" style="width: 30%; float: right; margin-top: 20px;">
                                <img class="img-responsive" src="../images/300/shuangpin-1-300.jpg" style="border-radius: 0px;" />
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

            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">享用时间</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">

                                <div class="form-group">
                                    <input class="form-control" placeholder="开始日期" name="StartDate" id="txtStartDate" readonly="readonly" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="结束日期" name="EndDate" id="txtEndDate" readonly="readonly" />
                                </div>


                                <div class="form-group">
                                    <span style="float: left; line-height: 30px; padding-right: 5px;">每日:</span>
                                    <div class="gw_num single" style="float: left">
                                        <em class="jian">-</em>
                                        <input type="text" value="1" class="num" readonly="readonly" />
                                        <em class="add">+</em>
                                    </div>
                                    <span style="float: left; line-height: 30px; padding-right: 5px;">份</span>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel-body" style="text-align: right; color: red">
                        共<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanportion">0</span>份;<br/>
                              合计： <span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanTotalPrice">0</span>元;<br/>
                        折扣：<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spandeduction">0</span>元;<br/>
                        应付：<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanActualPrice">0</span>元;
                    </div>
                </div>
            </div>
            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title">选择水果</h3>
                        </div>
                        <div class="panel-body" style="padding-left: 1px; padding-right: 1px">
                            <div class="m-b-15">
                                <div style="height: 30px; width: 100%;">
                                    <span style="color: red; float: left; padding: 5px 0px 5px 10px;">* 平台自动生成每日搭配清单</span>
                                    <label for="radio-SelectALL" id="laberradio-SelectALL" style="float: right;">全选</label>
                                    <input type="checkbox" class="TrustRadioSelectAll" name="radio-Type" id="radio-SelectALL" />
                                </div>
                            </div>
                            <div class="radio m-b-15">
                                <div class="picker order">
                                    <select class="image-picker show-html" multiple="multiple">
                                        <option data-img-src='../images/300/Org-1-300.jpg?id=1' value='1'>澳洲橙</option>
                                        <option data-img-src='../images/300/Orgblood-2-300.jpg?id=2' value='2'>澳洲血橙</option>
                                        <option data-img-src='../images/300/Prune-1-300.jpg?id=3' value='3'>美国西梅</option>
                                        <option data-img-src='../images/300/Cherries-1-300.jpg?id=4' value='4'>美国车厘子</option>

                                        <option data-img-src='../images/300/Blackgrape-1.300.jpg?id=5' value='5'>美国黑提</option>
                                        <option data-img-src='../images/300/huolongdan-1-300.jpg?id=6' value='6'>红宝石恐龙蛋</option>
                                        <option data-img-src='../images/300/konglongdanlbs-1-300.jpg?id=19' value='19'>绿宝石恐龙蛋</option>
                                        <option data-img-src='../images/300/hamigua-1-300.jpg?id=7' value='7'>缅甸哈密瓜</option>
                                        <option data-img-src='../images/300/wendan-1-300.jpg?id=8' value='8'>台湾麻豆文旦</option>
                                        <option data-img-src='../images/300/cuitianshi-1-300.jpg?id=9' value='9'>台湾脆甜柿</option>
                                        <option data-img-src='../images/300/mangguo-1-300.jpg?id=10' value='10'>台湾芒果</option>
                                        <option data-img-src='../images/300/fengli-1-300.jpg?id=11' value='11'>台湾金钻凤梨</option>
                                        <option data-img-src='../images/300/jinyou-1-300.jpg?id=12' value='12'>泰国金柚</option>
                                        <option data-img-src='../images/300/shanzhu-1-300.jpg?id=13' value='13'>泰国山竹</option>
                                        <option data-img-src='../images/300/hongmaodan-1-300.jpg?id=14' value='14'>泰国红毛丹</option>
                                        <option data-img-src='../images/300/shiliu-1-300.jpg?id=15' value='15'>突尼斯石榴</option>
                                        <option data-img-src='../images/300/jinguo-1-300.jpg?id=16' value='16'>新西兰金果</option>
                                        <option data-img-src='../images/300/huolongguobaixin-1-300.jpg?id=17' value='17'>越白心火龙果</option>
                                        <option data-img-src='../images/300/huolongguohongxin-1-300.jpg?id=18' value='18'>越红心火龙果</option>
                                    </select>
                                </div>
                            </div>
                            <%--                            <div>
                                <div><span style="color: red; float: left; padding: 5px 0px 5px 10px;">* 下单后平台自动生成每日配送清单</span></div>
                                <div>
                                    <label for="radio-SelectALL" id="laberradio-SelectALL" style="float: right;">全选</label>
                                    <input type="checkbox" class="TrustRadioSelectAll" name="radio-Type" id="radio-SelectALL" />
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">配送信息</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">
                                <div class="form-group">
                                    <select class="form-control" id="addrSelect" style="width: 90%; float: left; border-radius: 0px;">
                                        <option>上海信息大楼 上海浦东新区世纪大道211号</option>
                                        <option>上海证券大厦 上海市浦东新区浦东南路528号</option>
                                        <option>国家开发银行 上海市浦东新区浦东南路500号</option>
                                        <option>渣打银行大厦 上海市浦东新区世纪大道201号</option>
                                        <option>浦东发展银行大厦 浦东新区浦东南路588号(近世纪大道)</option>
                                    </select>
                                    <input class="form-control" placeholder="其他配送地址" name="Address" id="txtAddr" style="display: none; width: 90%; float: left; border-radius: 0px;" />
                                    <span id="btnOtherAddr" style="width: 10%; float: right; line-height: 40px; background-color: #65a032; font-size: 10px; color: #FFFFFF; text-align: center">其他</span>
                                    <div style="clear: both"></div>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系人" name="Contacter" id="txtContacter"  />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系手机" type="number" name="ContacterMP"  id="txtContacterMP" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row order">
                <div class="col-sm-4">
                    <div class="panel-body" style="text-align: right; color: red">
                        共<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanportion">0</span>份;<br/>
                              合计： <span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanTotalPrice">0</span>元;<br/>
                        折扣：<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spandeduction">0</span>元;<br/>
                        应付：<span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanActualPrice">0</span>元;
                    </div>
                </div>
            </div>
            <%----------------礼盒预定------------------------------------------------------------------------------------------------------------------------------------%>
            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title">选择水果</h3>
                        </div>
                        <div class="panel-body" style="padding-left: 1px; padding-right: 1px">
                            <%--                            <div class="m-b-15">
                                <div style="height: 30px; width: 100%;">
                                    <label for="radio-SelectALLGroup" id="laberradio-SelectALLGroup" style="float: right;">全选</label>
                                    <input type="checkbox" class="TrustRadioSelectAll" name="radio-Type" id="radio-SelectALLGroup" />
                                </div>
                            </div>--%>
                            <div class="m-b-15">
                                <div class="picker group">
                                    <select class="image-picker show-html" multiple="multiple">
                                        <option data-img-src='../images/300/Org-1-300.jpg?id=1' value='1'>澳洲橙</option>
                                        <option data-img-src='../images/300/Orgblood-2-300.jpg?id=2' value='2'>澳洲血橙</option>
                                        <option data-img-src='../images/300/Prune-1-300.jpg?id=3' value='3'>美国西梅</option>
                                        <option data-img-src='../images/300/Cherries-1-300.jpg?id=4' value='4'>美国车厘子</option>
                                        <option data-img-src='../images/300/Blackgrape-1.300.jpg?id=5' value='5'>美国黑提</option>
                                        <option data-img-src='../images/300/huolongdan-1-300.jpg?id=6' value='6'>红宝石恐龙蛋</option>
                                        <option data-img-src='../images/300/konglongdanlbs-1-300.jpg?id=19' value='19'>绿宝石恐龙蛋</option>
                                        <option data-img-src='../images/300/hamigua-1-300.jpg?id=7' value='7'>缅甸哈密瓜</option>
                                        <option data-img-src='../images/300/wendan-1-300.jpg?id=8' value='8'>台湾麻豆文旦</option>
                                        <option data-img-src='../images/300/cuitianshi-1-300.jpg?id=9' value='9'>台湾脆甜柿</option>
                                        <option data-img-src='../images/300/mangguo-1-300.jpg?id=10' value='10'>台湾芒果</option>
                                        <option data-img-src='../images/300/fengli-1-300.jpg?id=11' value='11'>台湾金钻凤梨</option>
                                        <option data-img-src='../images/300/jinyou-1-300.jpg?id=12' value='12'>泰国金柚</option>
                                        <option data-img-src='../images/300/shanzhu-1-300.jpg?id=13' value='13'>泰国山竹</option>
                                        <option data-img-src='../images/300/hongmaodan-1-300.jpg?id=14' value='14'>泰国红毛丹</option>
                                        <option data-img-src='../images/300/shiliu-1-300.jpg?id=15' value='15'>突尼斯石榴</option>
                                        <option data-img-src='../images/300/jinguo-1-300.jpg?id=16' value='16'>新西兰金果</option>
                                        <option data-img-src='../images/300/huolongguobaixin-1-300.jpg?id=17' value='17'>越白心火龙果</option>
                                        <option data-img-src='../images/300/huolongguohongxin-1-300.jpg?id=18' value='18'>越红心火龙果</option>
                                        <option data-img-src='../images/300/qiuyueli-1-300.jpg?id=20' value='20'>韩国秋月梨</option>
                                        <option data-img-src='../images/300/hongmeigui-1-300.jpg?id=21' value='21'>新西兰红玫瑰</option>
                                        <option data-img-src='../images/300/qinpingguo-1-300.jpg?id=22' value='22'>智利青苹果</option>
                                    </select>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="row group">
                <div class="col-sm-4">
                    <div style="text-align: left">
                        <span id="spangroupfruitlist"></span>
                    </div>
                </div>
            </div>
            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel-body" style="text-align: right; color: red">
                        <span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanTotalPriceGroup">0 </span>元;
                    </div>
                </div>
            </div>

            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">配送信息</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">
                                <div class="form-group">
                                    <input class="form-control" placeholder="配送日期 (每周日下午)" name="StartDateGroup" id="txtStartDateGroup" readonly="readonly" />
                                </div>
                                <div class="form-group ordercount" style="height: 30px;">
                                    <span style="float: left; line-height: 30px; padding-right: 5px;">购买盒数:</span>
                                    <div class="gw_num group" style="float: left">
                                        <em class="jian">-</em>
                                        <input type="text" value="1" class="num" readonly="readonly" />
                                        <em class="add">+</em>
                                    </div>
                                    <span style="float: left; line-height: 30px; padding-right: 5px;">盒</span>
                                </div>
                                <div class="form-group ">
                                    <input class="form-control" placeholder="地区" name="addressGroupArea" id="addressGroupArea" readonly="readonly" />
                                    <input id="hidlocation" type="hidden" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="具体地址" name="addressGroup" id="txtaddressGroup" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系人" name="ContacterGroup" id="txtContacterGroup" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系手机" name="ContacterMPGroup" id="txtContacterMPGroup" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel-body" style="text-align: right; color: red">
                        <span style="font-weight: bold; padding: 0px 5px 0px 5px;" name="spanTotalPriceGroup">0</span>元;
                    </div>
                </div>
            </div>


            <div class="row" style="padding-bottom: 30px;">
                <input id="btnCreateOrder" type="submit" class="btn btn-primary btn-info" style="margin: auto; display: block; width: 50%" value="下 单" />
            </div>

            <div class="row group" style="display: none;">
                <div class="col-sm-4">
                    <!--<div class="panel-body" style="text-align:right">
                    <span style="color:red"> 预计总价：300 人民币</span>
                </div>-->
                    <div class="panel-body" style="text-align: right">
                        <p>
                            <span style="color: red">* 礼盒预定也可以直接联系客服</span>
                        </p>
                        <p><span style="color: red">手机：13636567107 联系人：申先生</span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="groupfruitadd" class="layui-layer-wrap" style="display: none; padding: 20px; height: 100px;">
        <div class="form-group">
            <div class="groupcomments">
            </div>
        </div>
        <div class="form-group unitcount">
            <div class="gw_num group" style="float: left">
                <em class="jian">-</em>
                <input type="text" value="1" class="num" readonly="readonly" />
                <em class="add">+</em>
            </div>
            <span style="float: left; line-height: 30px; padding-right: 5px;">份</span>
        </div>
        <div class="form-group">
            <input id="btnAdd" type="button" data-fruitnum="" data-unit="" data-fruitname="" data-fruitid="" data-unitprice="" class="btn btn-primary btn-info" style="float: right" value="添加" />
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
</div>--%>

<script>
    var area2 = new LArea();
    area2.init({
        'trigger': '#addressGroupArea',
        'valueTo': '#hidlocation',
        'keys': {
            id: 'value',
            name: 'text'
        },
        'type': 2,
        'data': [provs_data, citys_data, dists_data]
    });

</script>
