<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SquirelOrderDetail.ascx.cs" Inherits="AllTrustUs.SquirrelPocket.UCOrder.SquirelOrderDetail" %>
<script>
    $(document).ready(function () {
        setMeun("mMyOrder");
        var _status = '<%=OrderPay.status %>';
        var _otheraddr = '<%=OrderPay.otheraddr %>';
        var _canRefund = '<%=canRefund%>';
        if (_status == "未支付") {

            $("#btnCancel").show();
            if (_otheraddr != "1") {
                $("#btnGotoPay").show();

                $("#btnGotoPay").click(function () {
                    window.location.href = "/Order/WXPay.aspx?openid=" + '<%=OrderPay.openid %>' + "&total_fee=" + '<%=OrderPay.actualprice %>' * 100 + "&order_id=" + '<%=order_id %>';
            })
        }
    }

        if (_canRefund == "True") {
            $("#btnRefund").show();
            $("#btnRefund").click(function () {
                var index = layer.load(1, {
                    shade: [0.1, '#fff'] //0.1透明度的白色背景
                });

                var order_id = '<%=order_id %>';
                $.ajax({
                    type: "POST",
                    url: "../Handlers/OrderHandler.ashx",
                    contentType: "application/x-www-form-urlencoded", //必须有
                    data: { Action: "orderRefund", orderid: order_id },
                    //currentorder.toString()
                    success: function (returndata) {
                        var result = JSON.parse(returndata);
                        if (result.result == "successed") {
                            layer.alert("取消并退款成功。");
                            $("#btnRefund").hide();
                            //window.location.href = "/Order/CartPage.aspx";
                        }
                        else {
                            layer.alert("退款错误，请重试。");
                        }
                        layer.closeAll('loading');
                    },
                    error: function (x, e) {
                        layer.alert("消息发送异常，请重试。");
                    },
                    complete: function (x) {
                        //alert("complete");
                    }
                });

            })
        }

    })

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
                    $("#DeliContent .delitable").append('<tr class="deli-head"><td>日期</td><td style="text-align:left">水果</td><td>份数</td><td>状态</td></tr>');
                    $.each(result.deliverys, function () {
                        var _tr = '<tr>'
                        _tr += '<td>' + this.Date + '</>';
                        _tr += '<td style="text-align:left">'
                        $.each(this.Deliveryfruits, function (name, obj) {
                            _tr += obj.Name + ';</br>';
                        })
                        _tr += '</td>'
                        _tr += '<td style="text-align:center">' + this.Count + '</td>';
                        _tr += '<td style="text-align:center">' + this.deliverystatus + '</td>';

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

    function CancelOrder() {
        var orderid = '<%=order_id %>';

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
                                      //_parent.hide();

                                      layer.close(index);
                                      window.location.href = "../Order/CartPage.aspx"
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

</script>
<div class="container midcontent">
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
                                    <p><%= Int32.Parse(OrderPay.days)*Int32.Parse(OrderPay.count) %></p>
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
                                <label class="list-laber">总价:</label>
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
                        <div class="form-group" runat="server" id="divdeliverystatus" visible="false">
                            <div class="list-group">
                                <label class="list-laber">配送状态:</label>
                                <span class="list-content">
                                    <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.deliverystatus %></span></p>
                                </span>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="list-group">
                                <label class="list-laber">支付状态:</label>
                                <span class="list-content">
                                    <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.status %></span></p>
                                </span>
                            </div>
                        </div>
                                                <div class="form-group">
                            <div class="list-group">
                                <label class="list-laber">快递单:</label>
                                <span class="list-content">
                                    <p class="form-control-static"><span style="color: red; font-weight: bold"><%=OrderPay.ExpressNumber %></span></p>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="row">
            <div class="col-sm-4">
                <input id="btnGotoPay" type="button" onclick="callpay();" value="去支付" class="PayButton" style="display: none; margin-bottom: 5px;" />
                <input id="btnRefund" type="button" value="申请退款" class="PayButton" style="display: none; margin-bottom: 5px;" />
                <input id="btnCancel" type="button" onclick="CancelOrder();" value="删除" class="PayButton" style="background-color: #FE6714; display: none; margin-bottom: 5px;" />

            </div>
        </div>
    </div>

</div>
<style>
    .Dele-container {
        width: 300px;
        height: 450px;
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
    </div>
</div>
--%>
