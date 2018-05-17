<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderQuery.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Management.OrderQuery" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/js/jquery.min.js"></script>

    <link href="/css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <script src="/js/bootstrap.min.js"></script>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <link href="/JQueryControl/kendoUI/styles/kendo.common.min.css" rel="stylesheet" />
    <link href="/JQueryControl/kendoUI/CustomizeTheme/Silver/kendo.custom.css" rel="stylesheet" />

    <script src="/JQueryControl/kendoUI/js/kendo.all.min.js"></script>
    <script src="/JQueryControl/kendoUI/js/jszip.min.js"></script>
    <script src="/js/layer/layer.js"></script>

    <script src="/js/Common.js"></script>

    <script>

        $(function () {
            layer.load(1, {
                shade: [0.2, '#fff'] //0.1透明度的白色背景
            });
            //ShowSingle();
            ShowCommunity();
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                // 获取已激活的标签页的名称
                layer.load(1, {
                    shade: [0.2, '#fff'] //0.1透明度的白色背景
                });

                var activeTab = $(e.target).text();
                switch (activeTab) {
                    case "拼盘订单":
                        ShowSingle();
                        break;
                    case "礼盒预定":
                        ShowGiftBox();
                        break;
                    case "水果数量配比计划":
                        ShowFruitsEstimate();
                        break;
                    case "社区预定":
                        ShowCommunity();
                        break;
                    default:
                        break;
                }
                // 获取前一个激活的标签页的名称
                //var previousTab = $(e.relatedTarget).text();
                //$(".active-tab span").html(activeTab);
                //$(".previous-tab span").html(previousTab);
            });

        })

        function ShowSingle() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getdeliverys", conditions: "" },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {


                        for (var i = 0; i < result.orders.length; i++) {

                            var _object = {
                                orderid: result.orders[i].orderid,
                                openid: result.orders[i].openid,
                                nickname: result.orders[i].nickname,
                                fruittype: result.orders[i].fruittype,
                                count: result.orders[i].count,
                                deliveryaddr: result.orders[i].deliveryaddr,
                                user: result.orders[i].user,
                                mp: result.orders[i].mp,
                                date: result.orders[i].date,
                                fruits: result.orders[i].fruits,
                                deliverystatus: result.orders[i].deliverystatus,
                                deliveryid: result.orders[i].deliveryid
                            };
                            _Logs.push(_object);

                        }
                        ShowGridSingle(_Logs);
                        layer.closeAll();
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
        function ShowGridSingle(_Logs) {

            $("#tableSingle").kendoGrid({
                toolbar: ["excel"],
                excel: {
                    fileName: "果切预定清单.xlsx",
                    allPages: true
                },
                dataSource: {
                    data: _Logs,
                    group: { field: "date" },
                    schema: {
                        model: {
                            fields: {
                                orderid: { type: "string" },
                                nickname: { type: "string" },
                                fruittype: { type: "string" },
                                count: { type: "string" },
                                deliveryaddr: { type: "string" },
                                user: { type: "string" },
                                mp: { type: "string" },
                                date: { type: "date" },
                                fruits: { type: "string" },
                                deliveryid: { type: "deliveryid" },
                                deliverystatus: { type: "deliverystatus" }
                            }
                        }
                    },
                    pageSize: 20
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: true,
                columnMenu: true,
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    { field: "orderid", width: "3%", title: "订单号", encoded: false },
                    { field: "nickname", width: "5%", title: "下单客户", encoded: false },
                    { field: "fruittype", width: "15%", title: "平盘类型", encoded: false },
                    { field: "count", width: "3%", title: "份数", encoded: false },
                    { field: "deliveryaddr", width: "20%", title: "配送地址", encoded: false },
                    { field: "user", width: "5%", title: "联系人", encoded: false },
                    { field: "mp", width: "5%", title: "电话", encoded: false },
                    { field: "date", width: "5%", title: "配送日期", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "fruits", width: "20%", title: "水果搭配", encoded: false },
                    { field: "deliverystatus", width: "5%", title: "配送状态", encoded: false },
                    {
                        field: "操作",
                        template: function (ro) {
                            if (ro.deliverystatus == "已配送") {
                                return "";
                            }
                            else {
                                return "<input type='button' id='" + ro.deliveryid + "' value='已配送' onclick='SingleDelivery(\"" + ro.deliveryid + "\",\"" + ro.orderid + "\",this)' />";
                            }
                        }

                    }
                ]
            });

        }


        function ShowGiftBox() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getgiftboxdelivery", conditions: "" },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {


                        for (var i = 0; i < result.orders.length; i++) {

                            var _object = {
                                orderid: result.orders[i].orderid,
                                openid: result.orders[i].openid,
                                nickname: result.orders[i].nickname,
                                fruittype: result.orders[i].fruittype,
                                count: result.orders[i].count,
                                deliveryaddr: result.orders[i].deliveryaddr,
                                user: result.orders[i].user,
                                mp: result.orders[i].mp,
                                date: result.orders[i].date,
                                fruits: result.orders[i].fruits,
                                deliverystatus: result.orders[i].deliverystatus,
                                GiftCardCode: result.orders[i].GiftCardCode,
                                ExpressNumber: result.orders[i].ExpressNumber,

                            };
                            _Logs.push(_object);

                        }
                        ShowGridGiftBox(_Logs);
                        layer.closeAll();
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
        function ShowGridGiftBox(_Logs) {

            $("#tableGiftBox").kendoGrid({
                toolbar: ["excel"],
                excel: {
                    fileName: "礼盒预定清单.xlsx",
                    allPages: true
                },
                dataSource: {
                    data: _Logs,
                    group: { field: "date" },
                    schema: {
                        model: {
                            fields: {
                                orderid: { type: "string" },
                                nickname: { type: "string" },
                                fruittype: { type: "string" },
                                count: { type: "string" },
                                deliveryaddr: { type: "string" },
                                user: { type: "string" },
                                mp: { type: "string" },
                                date: { type: "date" },
                                fruits: { type: "string" },
                                GiftCardCode: { type: "string" },
                                ExpressNumber: { type: "string" },
                                deliverystatus: { type: "string" }
                            }
                        }
                    },
                    pageSize: 20
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: true,
                columnMenu: true,
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    { field: "orderid", width: "3%", title: "订单号", encoded: false },
                    { field: "nickname", width: "5%", title: "预订人", encoded: false },
                    { field: "fruittype", width: "15%", title: "类型", encoded: false },
                    { field: "count", width: "3%", title: "盒数", encoded: false },
                    { field: "user", width: "5%", title: "联系人", encoded: false },
                    { field: "deliveryaddr", width: "20%", title: "地址", encoded: false },
                    { field: "mp", width: "5%", title: "电话", encoded: false },
                    { field: "date", width: "5%", title: "配送日期", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "fruits", width: "20%", title: "水果", encoded: false },
                    { field: "GiftCardCode", width: "5%", title: "礼品卷", encoded: false },
                    {
                        field: "ExpressNumber", width: "5%", title: "快递单", encoded: false,
                        template: function (ro) {
                            return "<input type='text' id='" + ro.orderid + "' value='" + ro.ExpressNumber + "' onchange='ChangeExpressNumber(\"" + ro.orderid + "\",this)' />";
                        }
                    },
                    { field: "deliverystatus", width: "5%", title: "配送状态", encoded: false },
                    {
                        field: "操作",
                        template: function (ro) {
                            if (ro.deliverystatus == "已配送") {
                                return "";
                            }
                            else {
                                return "<input type='button' id='" + ro.orderid + "' value='已配送' onclick='BoxDelivery(\"" + ro.orderid + "\",this)' />";
                            }
                        }

                    }
                ]
            });

        }

        //社区预定
        function ShowCommunity() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getcommunitydelivery", conditions: "" },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {


                        for (var i = 0; i < result.orders.length; i++) {

                            var _object = {
                                orderid: result.orders[i].orderid,
                                openid: result.orders[i].openid,
                                nickname: result.orders[i].nickname,
                                fruittype: result.orders[i].fruittype,
                                count: result.orders[i].count,
                                deliveryaddr: result.orders[i].deliveryaddr,
                                user: result.orders[i].user,
                                mp: result.orders[i].mp,
                                date: result.orders[i].date,
                                fruits: result.orders[i].fruits,
                                deliverystatus: result.orders[i].deliverystatus,
                                GiftCardCode: result.orders[i].GiftCardCode,
                                ExpressNumber: result.orders[i].ExpressNumber,
                                actualprice: result.orders[i].actualprice,
                                status: result.orders[i].status,
                                agencylevel: result.orders[i].agencylevel,
                                discount: result.orders[i].discount,
                                rebate: result.orders[i].rebate,
                                rebateprice: result.orders[i].rebate * result.orders[i].actualprice
                            };
                            _Logs.push(_object);

                        }
                        ShowCommunityData(_Logs);
                        layer.closeAll();
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
        function ShowCommunityData(_Logs) {

            $("#tableCommunity").kendoGrid({
                toolbar: ["excel"],
                excel: {
                    fileName: "社区预定清单.xlsx",
                    allPages: true
                },
                dataSource: {
                    data: _Logs,
                    group: [{ field: "deliveryaddr" }, { field: "nickname" }],
                    schema: {
                        model: {
                            fields: {
                                orderid: { type: "string" },
                                nickname: { type: "string" },
                                fruittype: { type: "string" },
                                count: { type: "string" },
                                deliveryaddr: { type: "string" },
                                user: { type: "string" },
                                mp: { type: "string" },
                                date: { type: "date" },
                                fruits: { type: "string" },
                                GiftCardCode: { type: "string" },
                                ExpressNumber: { type: "string" },
                                deliverystatus: { type: "string" },
                                actualprice: { type: "number" },
                                status: { type: "string" },
                                agencylevel: { type: "string" },
                                discount: { type: "number" },
                                rebate: { type: "number" },
                                rebateprice: { type: "number" }
                            }
                        }
                    },
                    pageSize: 20,
                    sort: { field: "orderid", dir: "asc" },
                    aggregate: [{ field: "actualprice", aggregate: "sum" }, { field: "rebateprice", aggregate: "sum" }]
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: {
                    extra: true,
                    operators: {
                        string: {
                            contains: "Contains",
                            startswith: "Starts with",
                            endswith: "End with"
                        }
                    }
                },
                columnMenu: {
                    filterable: true,
                    sortable: false,
                    columns: false
                },
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    { field: "orderid", width: "3%", title: "订单号", encoded: false },
                    { field: "nickname", width: "5%", title: "预订人", encoded: false, hidden: true },
                    { field: "fruittype", width: "10%", title: "类型", encoded: false },
                    //{ field: "count", width: "3%", title: "盒数", encoded: false },
                    { field: "user", width: "5%", title: "联系人", encoded: false },
                    { field: "deliveryaddr", width: "20%", title: "地址", encoded: false, hidden: true },
                    { field: "mp", width: "5%", title: "电话", encoded: false },
                    { field: "date", width: "5%", title: "提取日期", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "fruits", width: "20%", title: "水果", encoded: false },
                    //{ field: "GiftCardCode", width: "5%", title: "礼品卷", encoded: false },
                    { field: "actualprice", width: "8%", title: "实际金额", encoded: false, footerTemplate: "Total: #=kendo.toString(sum, '0.00')#", format: "{0:0.00}", attributes: { style: "text-align:right;  color: red;" }, footerAttributes: { style: "text-align:right; color: red;" } },
                    { field: "agencylevel", width: "5%", title: "级别", encoded: false },
                    { field: "discount", width: "5%", title: "折扣", encoded: false },
                    { field: "rebate", width: "5%", title: "返利", encoded: false },
                    { field: "rebateprice", width: "8%", title: "返利金额", encoded: false, footerTemplate: "Total: #=kendo.toString(sum, '0.00')#", format: "{0:0.00}", attributes: { style: "text-align:right; color: green;" }, footerAttributes: { style: "text-align:right; color: green;" } },
            {
                field: "ExpressNumber", width: "5%", title: "快递单", encoded: false,
                template: function (ro) {
                    return "<input style='width: 80px;' type='text' id='" + ro.orderid + "' value='" + ro.ExpressNumber + "' onchange='ChangeExpressNumber(\"" + ro.orderid + "\",this)' />";
                }
            },
        { field: "status", width: "5%", title: "状态", encoded: false },
        { field: "deliverystatus", width: "5%", title: "配送状态", encoded: false },
        {
            field: "操作",
            template: function (ro) {
                if (ro.deliverystatus == "已配送") {
                    return "";
                }
                else {
                    return "<input type='button' id='" + ro.orderid + "' value='已配送' onclick='BoxDelivery(\"" + ro.orderid + "\",this)' />";
                }
            }

        }
                ]
            });

        }

        function ChangeExpressNumber(orderid, con) {
            layer.load(1, {
                shade: [0.2, '#fff'] //0.1透明度的白色背景
            });
            var exNum = $(con).val();
            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "ChangeExpressNumber", orderid: orderid, ExpressNumber: exNum },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {

                    }
                    else {
                        layer.alert("消息发送异常，请重试。");
                    }

                },
                error: function (x, e) {
                    layer.alert("消息发送异常，请重试。");
                },
                complete: function (x) {
                    //alert("complete");
                    layer.closeAll();
                }
            });
        }

        function ShowFruitsEstimate() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getcommunityfruitsestimate", conditions: "" },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {


                        for (var i = 0; i < result.orders.length; i++) {

                            var _object = {
                                date: result.orders[i].date,
                                count: result.orders[i].count,
                                fruits: result.orders[i].fruits,
                                unit: result.orders[i].unit,
                                deliveryaddr: result.orders[i].deliveryaddr,
                                status: result.orders[i].status
                            };
                            _Logs.push(_object);

                        }
                        ShowGridFruitsEstimate(_Logs);
                        layer.closeAll();
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
        function ShowGridFruitsEstimate(_Logs) {

            $("#tableFruitsEstimate").kendoGrid({
                toolbar: ["excel"],
                excel: {
                    fileName: "水果配别计划.xlsx",
                    allPages: true
                },
                dataSource: {
                    data: _Logs,
                    group: [{ field: "status" }, { field: "fruits" }],
                    schema: {
                        model: {
                            fields: {
                                date: { type: "date" },
                                unit: { type: "string" },
                                count: { type: "string" },
                                fruits: { type: "string" },
                                deliveryaddr: { type: "string" },
                                status: { type: "string" }

                            }
                        }
                    },
                    pageSize: 20
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: true,
                columnMenu: true,
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    { field: "status", width: "5%", title: "状态", encoded: false },
                    { field: "deliveryaddr", width: "30%", title: "社区", encoded: false },
                    { field: "date", width: "10%", title: "配送日期", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "fruits", width: "20%", title: "水果", encoded: false },
                    { field: "count", width: "10%", title: "数量", encoded: false },
                    { field: "unit", width: "10%", title: "单位", encoded: false }

                ]
            });

        }

        function SingleDelivery(deliveryid, orderid, con) {
            layer.load(1, {
                shade: [0.2, '#fff'] //0.1透明度的白色背景
            });

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "singledelivery", deliveryid: deliveryid, orderid: orderid },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {
                        $($(con).parent().parent().find("td[role='gridcell']")[9]).text("已配送");
                        $(con).hide();
                        layer.closeAll();
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

        function BoxDelivery(deliveryid, con) {
            layer.load(1, {
                shade: [0.2, '#fff'] //0.1透明度的白色背景
            });

            $.ajax({
                type: "POST",
                url: "../Handlers/ManagementHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "bodelivery", deliveryid: deliveryid },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.result == "successed") {
                        $($(con).parent().parent().find("td[role='gridcell']")[14]).text("已配送");
                        $($(con).parent().parent().find("td[role='gridcell']")[13]).text("Completed");
                        $(con).hide();
                        layer.closeAll();
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

    <style>
        .container {
            width: 100%;
            padding: 20px;
        }

        h3 {
            font-weight: bold;
        }

        .row {
            margin-right: inherit;
            margin-left: inherit;
        }

        .layui-layer-loading .layui-layer-loading1 {
            margin: auto;
        }

        .k-grid.k-widget table tbody {
            font-size: 12px;
        }
    </style>

</head>
<body>
    <div class="container">
        <div class="content">

            <ul id="myTab" class="nav nav-tabs">
                <%--                <li><a href="#Single" data-toggle="tab">拼盘订单</a></li>
                <li><a href="#Group" data-toggle="tab">礼盒预定</a></li>--%>
                <li class="active"><a href="#Community" data-toggle="tab">社区预定</a></li>
                <li><a href="#PPlan" data-toggle="tab">水果数量配比计划</a></li>
            </ul>
            <div id="myTabContent" class="tab-content">
                <%--                <div class="tab-pane fade" id="Single">
                    <div id="tableSingle"></div>
                </div>
                <div class="tab-pane fade in" id="Group">
                    <div id="tableGiftBox"></div>
                </div>--%>
                <div class="tab-pane fade in active" id="Community">
                    <div id="tableCommunity"></div>
                </div>
                <div class="tab-pane fade" id="PPlan">
                    <div id="tableFruitsEstimate"></div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>
