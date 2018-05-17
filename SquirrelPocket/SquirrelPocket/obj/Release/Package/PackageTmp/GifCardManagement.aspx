<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GifCardManagement.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.GifCardManagement" %>

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

            ShowSingle();
            ShowGiftCode();
        })

        function ShowSingle() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                async: false,
                url: "../Handlers/GiftCardHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "getgiftcard"},
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.response.groups.length > 0) {

                        ShowGiftCodeList(result.response.groups);
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

        function ShowGiftCodeList(_Logs) {

            $("#tableSingle").kendoGrid({
                //toolbar: ["excel"],
                excel: {
                    fileName: "果切预定清单.xlsx",
                    allPages: true
                },
                dataSource: {
                    data: _Logs,
                    schema: {
                        model: {
                            fields: {
                                title: { type: "string" },
                                id: { type: "string" },
                                valid_start_time: { type: "string" },
                                valid_end_time: { type: "string" },
                                is_limit: { type: "string" },
                                total_qty: { type: "string" },
                                stock_qty: { type: "string" },
                                total_take: { type: "string" },
                                denominations: { type: "string" },
                                //fruittype: { type: "string" },
                                //count: { type: "string" },
                                //deliveryaddr: { type: "string" },
                                //user: { type: "string" },
                                //mp: { type: "string" },
                                //date: { type: "date" },
                                //fruits: { type: "string" },
                                //deliveryid: { type: "deliveryid" },
                                //deliverystatus: { type: "deliverystatus" }
                            }
                        }
                    },
                    pageSize: 20
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: {
                    //extra: true,
                    operators: {
                        string: {
                            contains: "Contains",
                            startswith: "Starts with",
                            endswith: "End with"
                        }
                    }
                },
                columnMenu: false,
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    { field: "id", width: "3%", title: "id", encoded: false },
                    { field: "title", width: "5%", title: "title", encoded: false },
                    { field: "denominations", width: "5%", title: "denominations", encoded: false },
                    { field: "total_take", width: "5%", title: "total_take", encoded: false },
                    { field: "total_qty", width: "5%", title: "total", encoded: false },
                    { field: "stock_qty", width: "5%", title: "stock", encoded: false },
                    { field: "is_limit", width: "5%", title: "limit", encoded: false },
                    { field: "valid_start_time", width: "5%", title: "start_time", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "valid_end_time", width: "5%", title: "end_time", encoded: false, format: "{0:yyyy/MM/dd}" }
                    //{ field: "fruittype", width: "15%", title: "平盘类型", encoded: false },
                    //{ field: "count", width: "3%", title: "份数", encoded: false },
                    //{ field: "deliveryaddr", width: "20%", title: "配送地址", encoded: false },
                    //{ field: "user", width: "5%", title: "联系人", encoded: false },
                    //{ field: "mp", width: "5%", title: "电话", encoded: false },
                    //{ field: "date", width: "5%", title: "配送日期", encoded: false, format: "{0:yyyy/MM/dd}" },
                    //{ field: "fruits", width: "20%", title: "水果搭配", encoded: false },
                    //{ field: "deliverystatus", width: "5%", title: "配送状态", encoded: false }
                ]
            });

        }

        function ShowGiftCode() {
            var _Logs = [];

            $.ajax({
                type: "POST",
                async: false,
                url: "../Handlers/GiftCardHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "giftcardtakelist" },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.response.giftcardlist.length > 0) {

                        ShowGiftCodeL(result.response.giftcardlist);
                        //layer.closeAll();
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
        function ShowGiftCodeL(_Logs) {
            $("#tableSingle2").html("");
            $("#tableSingle2").kendoGrid({
                toolbar: ["excel"],
                excel: {
                    fileName: "礼品码清单.xlsx",
                },
                dataSource: {
                    data: _Logs,
                    schema: {
                        model: {
                            fields: {
                                id: { type: "string" },
                                giftcardcode: { type: "string" },
                                PromoId: { type: "string" },
                                generatedate: { type: "string" },
                                isused: { type: "string" },
                                useddate: { type: "string" },
                                forcompany: { type: "string" },
                                expireddate: { type: "string" },
                                usedmobile: { type: "string" },
                                usedname: { type: "string" },

                                amount: { type: "string" },
                                enabled: { type: "string" },
                                deliveryaddr: { type: "string" },
                                jumpurl: { type: "string" },
                                usedopenid: { type: "string" }
                                //deliveryid: { type: "deliveryid" },
                                //deliverystatus: { type: "deliverystatus" }
                            }
                        }
                    },
                    pageSize: 50
                },
                //height: 1000,
                scrollable: false,
                sortable: true,
                groupable: true,
                filterable: {
                    //extra: true,
                    operators: {
                        string: {
                            contains: "Contains",
                            startswith: "Starts with",
                            endswith: "End with"
                        }
                    }
                },
                columnMenu: false,
                pageable: true,
                pageable: {
                    input: true,
                    numeric: false,
                    buttonCount: 10,
                    pageSizes: true
                },
                columns: [
                    {
                        width: "1%",
                        template: "<input type='checkbox' id='checkbox#: id #' data-value='#: id #' />",
                        headerTemplate: "<input type='checkbox' id='checkboxALL' onclick='checkAll(this)'/>"
                    },
                    { field: "id", width: "3%", title: "id", encoded: false },
                    { field: "giftcardcode", width: "3%", title: "giftcardcode", encoded: false },
                    { field: "PromoId", width: "5%", title: "PromoId", encoded: false },
                    { field: "generatedate", width: "5%", title: "generatedate", encoded: false },
                    { field: "isused", width: "5%", title: "isused", encoded: false },
                    { field: "enabled", width: "5%", title: "enabled", encoded: false },
                    { field: "useddate", width: "5%", title: "useddate", encoded: false },
                    { field: "forcompany", width: "5%", title: "forcompany", encoded: false },
                    { field: "expireddate", width: "5%", title: "expireddate", encoded: false, format: "{0:yyyy/MM/dd}" },
                    { field: "usedmobile", width: "5%", title: "usedmobile", encoded: false },
                    { field: "usedname", width: "5%", title: "usedname", encoded: false },
                    { field: "usedopenid", width: "5%", title: "usedopenid", encoded: false }
                ]
            });
        }

        function checkAll(input) {
            var checkboxs = $("#tableSingle2").find("input[type='checkbox']");
            checkboxs.each(function () {
                if (this.checked != input.checked) {
                    this.checked = input.checked;
                }
            })
        }

        function cardactive() {
            var checkboxs = $("#tableSingle2").find("input[type='checkbox']");
            var activeids="";
            checkboxs.each(function () {
                if (this.checked && $(this).attr("data-value") != undefined && $(this).attr("data-value") != "") {
                    if (activeids == "")
                    {
                        activeids = $(this).attr("data-value");
                    }
                    activeids += "," + $(this).attr("data-value");
                }
            })

            if (activeids == "")
            {
                layer.alert("请选择礼品码", { icon: 5 });
                return;
            }
            $.ajax({
                type: "POST",
                async: false,
                url: "../Handlers/GiftCardHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "cardactive", ids: activeids },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.response.issuccess == 1) {
                        ShowGiftCode();
                        layer.alert("激活成功", { icon: 6 });

                    }
                    else {

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
        function cardinactive() {
            var checkboxs = $("#tableSingle2").find("input[type='checkbox']");
            var activeids = "";
            checkboxs.each(function () {
                if (this.checked && $(this).attr("data-value") != undefined && $(this).attr("data-value") != "") {
                    if (activeids == "") {
                        activeids = $(this).attr("data-value");
                    }
                    activeids += "," + $(this).attr("data-value");
                }
            })

            if (activeids == "") {
                layer.alert("请选择礼品码", { icon: 5 });
                return;
            }
            $.ajax({
                type: "POST",
                async: false,
                url: "../Handlers/GiftCardHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "cardinactive", ids: activeids },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.response.issuccess == 1) {
                        ShowGiftCode();
                        layer.alert("禁用成功", { icon: 6 });

                    }
                    else {

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
</head>
<body>
    优惠码列表：
    <div id="tableSingle"></div><br />
    
    平台礼品卷列表：<br />
    <input type="button" value="激 活" onclick="cardactive()" />
    <input type="button" value="禁 用" onclick="cardinactive()" />
    <div id="tableSingle2"></div>
</body>
</html>
