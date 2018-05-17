<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CommunityOrder.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.CommunityOrder" %>

<style>
    .radio label, .checkbox label {
        padding-left: 10px;
    }

    ul.thumbnails.image_picker_selector li .thumbnail {
        border: inherit;
        font-size: 14px;
        text-align: center;
    }

        ul.thumbnails.image_picker_selector li .thumbnail.selected {
            font-size: 14px;
        }

    div.picker ul.image_picker_selector li {
        width: 33%;
    }
</style>
<script src="/js/boxfruitsJson.js?v=20171106001"></script>
<script src="/js/LArea/LArea.js"></script>
<script src="/js/LArea/LAreaDataGroupArea.js"></script>
<link href="/css/LArea.css?v=1.0.0" rel="stylesheet" />
<script>
    var currentorder = orderbase;
    var _openid = '<%=CurrentWeXUser.openid %>';
    var _agencylevel = '<%=CurrentWeXUser.agencylevel %>';
    var _discount = '<%=CurrentWeXUser.discount %>';
    $(document).ready(function () {
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
        if (_agencylevel == "L-1") {
            layer.alert("您还不是正式加盟商，请先提交加盟申请。", function () {
                window.location.href = "/home.aspx";
            });
            
        }
        else if (_agencylevel == "L0") {
            $("#imglevel").attr("src", "../images/agencyL0.png");
        }
        else if (_agencylevel == "L1")
        {
            $("#imglevel").attr("src", "../images/agencyL1.png");
        }
        else if (_agencylevel == "L2") {
            $("#imglevel").attr("src", "../images/agencyL2.png");
        }
        try {
            $("#txtBuildNO").val(localStorage.getItem("txtBuildNO"));
            $("#txtRoom").val(localStorage.getItem("txtRoom"));
        }
        catch (ex) {

        }

        setMeun("mOrder");
        InitImagePicker(100);
        $(".TrustRadioSelectAll").checkboxradio({ mini: true });
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
            $("#btnAdd").attr("data-boxunitprice", _selectf.boxprice);
            $("#fruitaddunit").empty()
            $("#fruitaddunit").append("<option value='" + _selectf.unit + "'>" + _selectf.unit + "</option>");
            $("#fruitaddunit").append("<option value='箱'>箱</option>")
            $("#btnAdd").attr("data-unit", _selectf.unit);
            $("#btnAdd").attr("data-fruitNum", _selectf.fruitNum);
            $("#btnAdd").attr("data-unitcost", _selectf.unitcost);
            $("#btnAdd").attr("data-boxcost", _selectf.boxcost);

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



        $("#btnAdd").click(function () {
            var _count = $(".unitcount .gw_num.group input").val();
            var up = $(this).attr("data-unitprice");
            var un = $(this).attr("data-unit");
            var co = $(this).attr("data-unitcost");
            if ($("#fruitaddunit").val() == "箱") {
                up = $(this).attr("data-boxunitprice");
                un = "箱";
                co = $(this).attr("data-boxcost");
            }
            currentorder.fruits.push(
                {
                    fruitid: $(this).attr("data-fruitid"),
                    name: $(this).attr("data-fruitname"),
                    count: _count,
                    unit: un,
                    unitprice: up,
                    price: up * _count,
                    fruitNum: $("#btnAdd").attr("data-fruitNum"),
                    cost: co
                });
            caculateDaysAndCostGroup();
            layer.closeAll();

        });

        function caculateDaysAndCostGroup() {
            var _totalprice = 0;
            currentorder.totalprice = 0;
            $("#spangroupfruitlist").html("");
            $.each(currentorder.fruits, function () {
                _totalprice += this.price;
                $("#spangroupfruitlist").append(this.name + ": " + this.fruitNum * this.count + this.unit + " " + this.price + "元</br>");
            })
            //var _agencylevel = 'L1';
            //var _discount = '0.95';
            currentorder.totalprice = _totalprice * currentorder.count;
            currentorder.actualprice = _totalprice * currentorder.count * _discount;
            currentorder.deduction = currentorder.totalprice - currentorder.actualprice;
            $("span[name='spanTotalPriceGroup']").text("现价:" + currentorder.actualprice + "元");
            if (_discount < 1) {
                $("span[name='spanDiscount']").text("折扣:" + _discount * 10 + "折");
            }
            else {
                $("span[name='spanDiscount']").text("折扣:无");
            }
            $("span[name='spanOldPrice']").text("原价:" + currentorder.totalprice + "元");
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

        $("#txtStartDate").datepicker({
            minDate: new Date(),
            dateFormat: "yy/mm/dd"
        });

        $("#signupForm").validate({
            rules: {
                StartDate: "required",
                BuildNO: "required",
                Room: "required",
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
                StartDate: "* 请选择提货日期",
                BuildNO: "* 请填写楼号",
                Room: "* 请填写房号",
                ContacterMP: {
                    required: "* 请填写联系人手机",
                    minlength: "* 确认手机不能小于11个字符"
                }
            }
        });
    })

    $.validator.setDefaults({
        submitHandler: function () {
            //layer.load(0, { shade: 0.1 });
            debugger;

            getGroupvalue();
            //return;
            //window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
            if (currentorder.fruits.length <= 0) {
                layer.alert("请选择水果。");
                return;
            }
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
                        //layer.msg("感谢您的预定，小伙伴会尽快联系您。", { icon: 6 }, function () {
                        //    window.location.href = "/example/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.totalprice * 100 + "&order_id=1";
                        //    //do something
                        //});
                        //if (_otheraddr) {
                        if ($('#chkPayonline').is(':checked')) {
                            window.location.href = "/Order/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.actualprice * 100 + "&order_id=" + result.orderid;
                        }
                        else {
                            //window.location.href = "/Order/WXPay.aspx?openid=" + currentorder.openid + "&total_fee=" + currentorder.actualprice * 100 + "&order_id=" + result.orderid;
                            window.location.href = "/Order/CartPage.aspx"

                        }
                    }

                },
                error: function (x, e) {
                    layer.alert("下单预定异常，请重试。");
                },
                complete: function (x) {
                    //alert("complete");
                }
            });

        }
    });

    function getGroupvalue() {

        currentorder.openid = _openid;
        currentorder.fruittype = '社区预定';
        currentorder.startdate = $("#txtStartDate").val();
        currentorder.count = "1";
        currentorder.deliveryaddr = $("#Selectaddr").val()
        currentorder.user = $("#txtBuildNO").val() + "-" + $("#txtRoom").val();
        currentorder.mp = $("#txtContacterMP").val();
        currentorder.days = 1;

        currentorder.discount = _discount;
        currentorder.agencylevel = _agencylevel;

        localStorage.setItem("txtBuildNO", $("#txtBuildNO").val());
        localStorage.setItem("txtRoom", $("#txtRoom").val());
    }


    function InitImagePicker(limited) {
        $("select.image-picker").imagepicker({
            limit: limited,
            show_label: true,
            limit_reached: function () {
                layer.alert("最多可以选择" + limited + "种水果。");
            }
        })


    }


</script>
<form id="signupForm" runat="server">
    <div class="container midcontent">
        <div class="content">
            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">享用时间</h3>
                        </div>
                        <div class="panel-body">
                            <div class="m-b-15">
                                <div class="form-group">
                                    <select class="form-control" id="Selectaddr" style="border-radius: 0px;">
                                        <option>世茂云图 上海浦东康涵路58弄</option>
                                        <option>上海信息大楼 上海浦东世纪大道211号</option>
                                        <option>邮寄</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="楼号" name="BuildNO" id="txtBuildNO" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="房号" name="Room" id="txtRoom" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="联系手机" type="number" name="ContacterMP" id="txtContacterMP"  value="<%=CurrentWeXUser.MP %>"/>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="预计提取日期" name="StartDate" id="txtStartDate" readonly="readonly" />
                                    *提货地址为15号楼1203室
                                </div>

                            </div>


                        </div>
                    </div>
                </div>
            </div>

            <div class="row group">
                <div class="col-sm-4">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title">选择水果</h3>
                        </div>
                        <div class="panel-body" style="padding-left: 1px; padding-right: 1px">
                            <div class="radio m-b-15">
                                <div class="picker order">
                                    <select class="image-picker show-html" multiple="multiple">
                                        <option data-img-src='../images/70/1-aks.png?id=1' value='1'>阿克苏苹果</option>
                                        <option data-img-src='../images/70/2-nyg.png?id=2' value='2'>智利牛油果</option>
                                        <option data-img-src='../images/70/3-zlnm.png?id=3' value='3'>智力蓝莓</option>
                                        <option data-img-src='../images/70/4-flbfl.png?id=4' value='4'>菲律宾凤梨</option>

                                        <option data-img-src='../images/70/5-rbhmg.png?id=5' value='5'>日本哈密瓜</option>
                                        <option data-img-src='../images/70/6-twhlg.png?id=6' value='6'>台湾火龙果</option>
                                        <option data-img-src='../images/70/7-tgyq.png?id=7' value='7'>泰国椰青</option>
                                        <option data-img-src='../images/70/9-tnssl.png?id=9' value='9'>突尼斯软子石榴</option>
                                        <option data-img-src='../images/70/10-xmfmht.png?id=10' value='10'>小蜜蜂猕猴桃</option>
                                        <option data-img-src='../images/70/13-gnqc.png?id=13' value='13'>赣南脐橙</option>
                                        <option data-img-src='../images/70/14-mgqy.png?id=14' value='14'>美国青柚</option>
                                        <option data-img-src='../images/70/11-llb.png?id=11' value='11'>榴莲饼</option>
                                        <option data-img-src='../images/70/12-sjsb.png?id=12' value='12'>霜降柿饼</option>
                                        
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
                    <img id="imglevel" style="width: 40px;float:left" />
                    <div class="panel-body" style="text-align: right;">
                        <span style="font-weight: bold; padding: 0px 5px 0px 5px; color: red" name="spanTotalPriceGroup">现价：0 元;</span>
                        <span style="padding: 0px 5px 0px 5px; color: red" name="spanDiscount">折扣：</span>
                        <span style="padding: 0px 5px 0px 5px; color: #D5D5D5; text-decoration: line-through;" name="spanOldPrice">原价：0 元;</span>
                    </div>
                </div>
                <div class="col-sm-4">
                    <input type="checkbox" id="chkPayonline" />在线支付（也可下单后线下支付）
                </div>
            </div>
            <div class="row" style="padding-bottom: 30px;">
                <input id="btnCreateOrder" type="submit" class="btn btn-primary btn-info" style="margin: auto; display: block; width: 50%" value="下单预定" />
            </div>
        </div>
    </div>

    <div id="groupfruitadd" class="layui-layer-wrap" style="display: none; padding: 20px; height: 100px;">
        <div class="form-group">
            <div class="groupcomments">
            </div>
        </div>
        <div class="form-group unitcount">
            <div class="gw_num group" style="float: left;width: 160px;border: inherit;">
                <em class="jian">-</em>
                <input type="text" value="1" class="num" readonly="readonly" style="border-top: 1px solid #dbdbdb;border-bottom: 1px solid #dbdbdb;"/>
                <em class="add">+</em>
                <select id="fruitaddunit" style="float: left; height: 30px;">
                    <option value="箱">箱</option>
                </select>
            </div>
            <span style="float: left; line-height: 30px; padding-right: 5px;"></span>
        </div>
        <div class="form-group">
            <input id="btnAdd" type="button" data-fruitnum="" data-unit="" data-fruitname="" data-fruitid="" data-unitprice="" data-boxunitprice=""  data-unitcost="" data-unitcost="" data-boxcost="" class="btn btn-primary btn-info" style="float: right" value="添加" />
        </div>
    </div>
</form>
