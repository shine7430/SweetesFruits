$(document).ready(function () {

})

$.fn.longPress = function (fn) {
    var timeout = undefined;
    var $this = this;
    for (var i = 0; i < $this.length; i++) {
        $this[i].addEventListener('touchstart', function (event) {
            timeout = setTimeout(fn, 1500);
        }, false);
        $this[i].addEventListener('touchend', function (event) {
            clearTimeout(timeout);
        }, false);
    }
}

function dayAdd(date, days) {
    var d = new Date(date);
    d.setDate(d.getDate() + days);
    var month = d.getMonth() + 1;
    var day = d.getDate();
    if (month < 10) {
        month = "0" + month;
    }
    if (day < 10) {
        day = "0" + day;
    }
    return d.getFullYear() + "/" + month + "/" + day;
}

function fn_dayalldiff(s1, s2) {

    s1 = new Date(s1.replace(/-/g, "/"));
    s2 = new Date(s2.replace(/-/g, "/"));

    var days = s2.getTime() - s1.getTime();
    var time = parseInt(days / (1000 * 60 * 60 * 24));
    return time;
}
function fn_daydiff(ibeginDate, iendDate) {
    var beginDate = new Date(ibeginDate);
    //结束日期  
    var endDate = new Date(iendDate);
    //日期差值,即包含周六日、以天为单位的工时，86400000=1000*60*60*24.  
    var workDayVal = (endDate - beginDate) / 86400000 + 1;
    //工时的余数  
    var remainder = workDayVal % 7;
    //工时向下取整的除数  
    var divisor = Math.floor(workDayVal / 7);
    var weekendDay = 2 * divisor;

    //起始日期的星期，星期取值有（1,2,3,4,5,6,0）  
    var nextDay = beginDate.getDay();
    //从起始日期的星期开始 遍历remainder天  
    for (var tempDay = remainder; tempDay >= 1; tempDay--) {
        //第一天不用加1  
        if (tempDay == remainder) {
            nextDay = nextDay + 0;
        } else if (tempDay != remainder) {
            nextDay = nextDay + 1;
        }
        //周日，变更为0  
        if (nextDay == 7) {
            nextDay = 0;
        }

        //周六日  
        if (nextDay == 0 || nextDay == 6 || isNotWorkDay(nextDay)) {
            weekendDay = weekendDay + 1;
        }
    }
    //实际工时（天） = 起止日期差 - 周六日数目。  
    workDayVal = workDayVal - weekendDay;
    return workDayVal;
}

var Holiday = ["2017-01-23", "2017-01-24", "2017-01-25", "2017-01-26", "2017-01-27"];
var WeekendsOff = [];
function nearlyWeeks(mode, weekcount, end) {
    /*
    功能：计算当前时间（或指定时间），向前推算周数(weekcount)，得到结果周的第一天的时期值；
    参数：
    mode -推算模式（'cn'表示国人习惯【周一至周日】；'en'表示国际习惯【周日至周一】）
    weekcount -表示周数（0-表示本周， 1-前一周，2-前两周，以此推算）；
    end -指定时间的字符串（未指定则取当前时间）；
    */

    if (mode == undefined) mode = "cn";
    if (weekcount == undefined) weekcount = 0;
    if (end != undefined)
        end = new Date(new Date(end).toDateString());
    else
        end = new Date(new Date().toDateString());

    var days = 0;
    if (mode == "cn")
        days = (end.getDay() == 0 ? 7 : end.getDay()) - 1;
    else
        days = end.getDay();

    return new Date(end.getTime() - (days + weekcount * 7) * 24 * 60 * 60 * 1000);
};
function getWorkDayCount(mode, beginDay, endDay) {
    /*
    功能：计算一段时间内工作的天数。不包括周末和法定节假日，法定调休日为工作日，周末为周六、周日两天；
    参数：
    mode -推算模式（'cn'表示国人习惯【周一至周日】；'en'表示国际习惯【周日至周一】）
    beginDay -时间段开始日期；
    endDay -时间段结束日期；
    */
    beginDay = new Date(beginDay);
    endDay = new Date(endDay);
    var begin = new Date(beginDay);
    var end = new Date(endDay);

    //每天的毫秒总数，用于以下换算
    var daytime = 24 * 60 * 60 * 1000;
    //两个时间段相隔的总天数
    var days = (end - begin) / daytime + 1;
    //时间段起始时间所在周的第一天
    var beginWeekFirstDay = nearlyWeeks(mode, 0, beginDay.getTime()).getTime();
    //时间段结束时间所在周的最后天
    var endWeekOverDay = nearlyWeeks(mode, 0, endDay.getTime()).getTime() + 6 * daytime;

    //由beginWeekFirstDay和endWeekOverDay换算出，周末的天数
    var weekEndCount = ((endWeekOverDay - beginWeekFirstDay) / daytime + 1) / 7 * 2;
    //根据参数mode，调整周末天数的值
    if (mode == "cn") {
        if (endDay.getDay() > 0 && endDay.getDay() < 6)
            weekEndCount -= 2;
        else if (endDay.getDay() == 6)
            weekEndCount -= 1;

        if (beginDay.getDay() == 0) weekEndCount -= 1;
    }
    else {
        if (endDay.getDay() < 6) weekEndCount -= 1;

        if (beginDay.getDay() > 0) weekEndCount -= 1;
    }

    //根据调休设置，调整周末天数（排除调休日）
    $.each(WeekendsOff, function (i, offitem) {
        var itemDay = new Date(offitem.split('-')[0] + "/" + offitem.split('-')[1] + "/" + offitem.split('-')[2]);
        //如果调休日在时间段区间内，且为周末时间（周六或周日），周末天数值-1
        if (itemDay.getTime() >= begin.getTime() && itemDay.getTime() <= end.getTime() && (itemDay.getDay() == 0 || itemDay.getDay() == 6))
            weekEndCount -= 1;
    });
    //根据法定假日设置，计算时间段内周末的天数（包含法定假日）
    $.each(Holiday, function (i, itemHoliday) {
        var itemDay = new Date(itemHoliday.split('-')[0] + "/" + itemHoliday.split('-')[1] + "/" + itemHoliday.split('-')[2]);
        //如果法定假日在时间段区间内，且为工作日时间（周一至周五），周末天数值+1
        if (itemDay.getTime() >= begin.getTime() && itemDay.getTime() <= end.getTime() && itemDay.getDay() > 0 && itemDay.getDay() < 6)
            weekEndCount += 1;
    });

    //工作日 = 总天数 - 周末天数（包含法定假日并排除调休日）
    return days - weekEndCount;
};

function getQueryString(name) {
    var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
    var r = window.location.search.substr(1).match(reg);
    if (r != null) {
        return unescape(r[2]);
    }
    return null;
}

//2.Date Format
Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1,                 //月份
        "d+": this.getDate(),                    //日
        "h+": this.getHours(),                   //小时
        "m+": this.getMinutes(),                 //分
        "s+": this.getSeconds(),                 //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds()             //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//3.Replace all prototype
String.prototype.replaceAll = function (target, replacement) {
    return this.split(target).join(replacement);
};


//JS操作cookies方法!
//写cookies
function setCookie(name, value) {
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}

function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
    if (arr = document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}

//6.Rest Ajax Call
function SPRD_Rest_Ajax(url, method, async, successfun, failfun) {
    $.ajax({
        url: url,
        method: method,
        async: async,
        headers: { "Accept": "application/json; odata=verbose" },
        success: function (data) {
            var spsData = data.d.results;
            successfun(spsData);
        },
        error: function (data) {
            if (failfun != null) {
                failfun(data);
            }
            else {
                SPRD_failure("Rest Call failed");
            }
        }
    });
}

function setMeun(id) {
    $("#main div a").each(function () {
        $(this).removeClass("checked");
    });
    $("#" + id).addClass("checked");
}

var orderbase = {
    orderid: "",
    openid: "",
    fruittype: "",
    unitprice: "15",
    startdate: "",
    enddate: "",
    days: "",
    count: "1",
    deliveryaddr: "",
    user: "",
    mp: "",
    totalprice: "0",
    otheraddr: "0",
    fruits: [],
    deliverys: [],
    GiftCardCode: "",
    deduction: 0,
    actualprice: 0,
    agencylevel: "L0",
    discount: "1"
}

var fruitbase = {
    fruitid: "",
    name: "",
    count: "",
    unit: "",
    unitprice: "",
    price: ""
}

var deliverybase = {
    orderid: "",
    date: "",
    count: "1",
    status: "",
    deliveryfruits: []
}

var deliveryfruitsbase = {
    fruitid: "",
    name: ""
}
