<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GifCardTake.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.GifCardTake" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="/css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="/js/jquery.min.js"></script>

    <!-- Custom Theme files -->
    <!--theme-style-->
    <link href="/css/style.css?v=1.0.0" rel="stylesheet" type="text/css" media="all" />
    <link href="/css/bootstrap-overwrite.css?v=1.0.0" rel="stylesheet" type="text/css" media="all" />
    <style>
        .PayButton {
            width: 100%;
            height: 50px;
            background-color: #00CD00;
            border: 0px #FE6714 solid;
            cursor: pointer;
            color: white;
            font-size: 16px;
            margin: 0 auto;
            display: block;
            font-weight: bold;
        }

        .form-control.error {
            border-color: red;
        }

        .form-control {
            border-radius: initial;
            height: 50px !important;
            font-size: 16px;
        }
    </style>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="/js/layer/layer.js"></script>
    <link href="/js/layer/skin/layer.css" rel="stylesheet" />

    <!--validation-->
    <script src="/js/jquery-validation/jquery.validate.min.js"></script>
    <script src="/js/jquery-validation/localization/messages_zh.js"></script>
    <script>
        $(document).ready(function () {
            setvalidate();
        })

        $.validator.setDefaults({
            submitHandler: function () {
                //layer.load(0, { shade: 0.1 });
                debugger;


                //return;
             var msg =  layer.msg('手机号：' + $("#txtContacterMP").val() +
                    '<br/>注册码：' + $("#txtGidCode").val()
                    + '<br/>确认后无法撤回和修改，确认提交？', {
                    shade: 0.3,
                    time: 0 //不自动关闭
              , btn: ['确认', '取消']
              , yes: function (index) {
                  var index = layer.load(1, {
                      shade: [0.5, '#fff'] //0.1透明度的白色背景
                  });
                  cardtake();
                  

              }
              , btn2: function () {
                      layer.closeAll();
                  }

                });

            }
        });

        function setvalidate() {
            $("#signupForm").validate({
                rules: {
                    name: "required",
                    ContacterMP: {
                        required: true,
                        minlength: 11,
                        maxlength: 11
                    },
                    GidCode: {
                        required: true,
                        minlength: 12,
                        maxlength: 12
                    }

                },
                messages: {
                    name: "*",
                    GidCode: {
                        required: "*",
                        minlength: "* 确认注册码为12个数字",
                        maxlength: "* 确认注册码为12个数字"
                    },
                    ContacterMP: {
                        required: "*",
                        minlength: "* 确认手机为11个数字",
                        maxlength: "* 确认手机为11个数字"
                    }
                }
            });

        function cardtake() {
            $.ajax({
                type: "POST",
                async: false,
                url: "../Handlers/GiftCardHandler.ashx",
                contentType: "application/x-www-form-urlencoded", //必须有
                data: { Action: "giftcardtake", openid: $("#hidopenid").val(), mobile: $("#txtContacterMP").val(), name: $("#txtname").val(), cardcode: $("#txtGidCode").val() },
                //currentorder.toString()
                success: function (returndata) {
                    var result = JSON.parse(returndata);
                    if (result.response.issuccess == 0) {
                        layer.closeAll();
                        layer.alert(result.response.msg, { icon: 5 });

                    }
                    else {
                        layer.alert(result.response.msg + " 您可以进入[会员主页]-[我的优惠码]中查看。", {
                            icon: 6,
                            closeBtn: 0
                        }, function () {
                            if (result.response.jumpurl != "") {
                                window.location.href = result.response.jumpurl;
                            }
                            else {
                                window.location.href = "https://h5.youzan.com/v2/feature/vcElP79PpH";
                            }

                        });
                    }

                },
                error: function (x, e) {
                    layer.closeAll();
                    layer.alert("消息发送异常，请重试。", { icon: 2 });
                },
                complete: function (x) {
                    //alert("complete");
                }
            });
        }
    </script>
</head>
<body>
    <form id="signupForm" runat="server">
        <div class="container midcontent">
            <div class="header">
                <div class="header-top" style="padding: 20px 0 20px 0;">
                    <div class="logo">
                        <img class="face" style="width: 40px; height: 40px;" src="http://wx.qlogo.cn/mmopen/CJ35Z2cnZA24U0CEXWCNrM7qzkVww1piakIXcON9yAwibg44NYhEz103doVM8qLQdMic5QfkXHia2wtE6UO3dRm4tSEGtaicOmQox/0" />地球  
                    </div>
                    <div style="float: right">
                        <img src="../images/logo-foot.png" style="width: 120px;" alt="" />
                    </div>
                    <div class="clearfix"></div>
                </div>

            </div>
            <div class="content">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="panel panel-warning">
                            <div class="panel-heading">
                                <h3 class="panel-title">礼品卷</h3>
                            </div>
                            <div class="panel-body">

                                <div class="form-group">
                                    <input type="hidden" value="okou5v6zJqXG1dSta-IjgTmxQ-dE" id="hidopenid" />
                                    <input class="form-control" placeholder="姓名" name="name" id="txtname" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="手机号" type="number" name="ContacterMP" id="txtContacterMP" />
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="12位数字礼品卷码" type="number" name="GidCode" id="txtGidCode" />
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div style="text-align: center;">
                    <a href="https://shop192168.youzan.com/v2/promocodes">我的礼品码</a>
                </div>
                <div class="row" style="position: fixed; bottom: 0px; margin: auto; left: 0; right: 0;">
                    <div>
                        <div runat="server" id="divbutton">
                            <input id="btnPay" type="submit" value="礼品码验证" class="PayButton" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
