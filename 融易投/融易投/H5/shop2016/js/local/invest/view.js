/**
 * Created by Administrator on 2016/5/31 0031.
 */
//获得项目基本信息轮播图的view
function getArtWorkBaseInfoPictureHtml(it) {
    return '<div class="swiper-slide"><a><img class="itam-img" src="' + it.picture_url + '" alt=""><span>' + it.name + '</span></a> </div>'
}
//获得基本信息的view
function getArtWorkBaseInfoMainHtml(it /**/) {
    var out = ' <div class="page"> <div class="p-time"> <div class="bl"><em>起拍价：</em><em>' + (it.startingPrice) + '</em><em>元</em></div> <div class="br"> <!--@TODO 倒计时 并且根据拍卖进度变化--> ';
    if (it.step == "30") {
        out += ' <em>距拍卖开始</em> ';
    } else if (it.step == "31") {
        out += ' <em>距拍卖结束</em> ';
    } else if (it.step == "32") {
        out += ' <em>拍卖结束</em> ';
    }
    out += ' ';
    if (it.step == "30" || it.step == "31") {
        out += ' <span class="time" onload="countDown(\'';
        if (it.step == "30") {
            out += '' + (it.auctionStartDatetime);
        } else {
            out += '' + (it.auctionEndDatetime);
        }
        out += '\')"><em class="num" id="hh">01</em><em class="str">小时</em><em class="num" id="mm">30</em><em class="str">分</em><em class="num" id="ss">59</em><em class="str">秒</em> </span> ';
    } else {
        out += ' <span class="time"><strong> 恭喜 ' + (it.winner.name) + '</strong></span> ';
    }
    out += ' </div> </div> <!--//End--p-time--> <div class="mp"> <div class="pic"><a onclick="redirectUser(\'' + (it.masterId) + '\')"><img src="' + (it.headUrl) + '" alt=""></a></div> <div class="n-page"><span class="name">' + (it.masterName) + '</span><strong></strong><span class="rank">' + (it.title) + '</span></div> </div> <div class="t-page"> <div class="wh"> <i></i> <span>' + (it.brief) + '</span> <em></em> </div> </div> </div>';
    return out;
}
//获得拍卖信息的view
function getArtWorkBaseInfoAuctionMessageHtml(it /**/) {
    var out = ' <ul> <li class=""> <p><span>' + (it.auctionNum) + '</span>次</p> <p>有效出价</p> </li> <li class=""> <p><span>' + (it.viewNum) + '</span>次</p> <p>浏览次数</p> </li> <li class=""> <p><span>' + (getAuctionPrice(it.startingPrice) ) + '</span>元</p> <p>加价幅度</p> </li> <li class=""> <p><span>30</span>秒</p> <p>延时周期</p> </li> </ul>';
    return out;
}
//获得项目进度（融资）的view
function getArtWorkScheduleInvestHtml(it /**/) {
    var out = ' <div class="title"> <div class="l-icon rz-icon"></div> <div class="r-txt"> <span class="head">融资</span> <span class="month">' + getDateStr(it.investStartDatetime) + '</span> <span class="alltime">' + getTimeStr(it.investStartDatetime) + '</span> </div> </div> <div class="page"> <span class="p-head">' + getDayNums((new Date().getTime()) - (it.investStartDatetime)) + '天前</span> <p>项目审核通过发起融资，共有' + (it.artworkInvestsSize) + '位用户投资。</p> </div>';
    return out;
}
//获得项目进度（创作）的view
function getArtWorkScheduleCreateHtml(it /**/) {
    var out = ' <div class="title"> <div class="l-icon rz-icon"></div> <div class="r-txt"> <span class="head">创作</span> <span class="month">' + (getDateStr(it.investEndDatetime)) + '</span> <span class="alltime">' + (getTimeStr(it.investEndDatetime)) + '</span> </div> </div> <div class="page"> <p>预计作品创作完成还有' + (getDayNums(it.auctionStartDatetime - it.investEndDatetime)) + '天。</p> </div>';
    return out;
}
//获得项目进度（拍卖）的view
function getArtWorkScheduleAuctionHtml(it /**/) {
    var out = ' <div class="title"> <div class="l-icon rz-icon"></div> <div class="r-txt"> <span class="head">拍卖</span> <span class="month">' + (getDateStr(it.auctionStartDatetime)) + '</span> <span class="alltime">08:50' + (getTimeStr(it.auctionStartDatetime)) + '</span> </div> </div>';
    return out;
}
//获得项目进度（动态）的view
function getArtWorkScheduleMessageHtml(it /**/) {
    var out = '<div class="page"> <div class="tm-box fl wb" style="margin-top:-42px;"> <span class="month" style="margin-right:11px;">' + (getDateStr(it.messageList[0].createDatetime)) + '</span> <span class="alltime">' + (getTimeStr(it.messageList[0].createDatetime)) + '</span> </div> <div class="list"> <div class="messageContent"> ' + (it.messageList[0].content) + ' </div> <div class="p-all" style="width: 100%;float: left"> ';
    for (var i = 0; i < it.messageList[0].artworkCommentList.length; i++) {
        var comment = it.messageList[0].artworkCommentList[i];
        if (typeof comment.fatherComment != "undefined" && comment.fatherComment != null) {
            out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">';
            if (comment.creator.id == getCurrentUserId()) {
                out += '我的';
            } else {
                out += ' ' + (comment.creator.name) + ' ';
            }
            out += '</a>回复<a onclick="redirectUser(\'' + comment.fatherComment.creator.id + '\')">' + (comment.fatherComment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
        } else {
            out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">' + (comment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
        }
        out += ' ';
    }
    out += ' <div class="hideCommentList" style="display: none;"> ';
    for (var i = 5; i < it.messageList[0].artworkCommentList.length; i++) {
        var comment = it.messageList[0].artworkCommentList[i];
        if (typeof comment.fatherComment != "undefined" && comment.fatherComment != null) {
            out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">';
            if (comment.creator.id == getCurrentUserId()) {
                out += '我的';
            } else {
                out += ' ' + (comment.creator.name) + ' ';
            }
            out += '</a>回复<a onclick="redirectUser(\'' + comment.fatherComment.creator.id + '\')">' + (comment.fatherComment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
        } else {
            out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">' + (comment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
        }
        out += ' ';
    }
    out += ' </div> </div> <a id="addList" style="font-size: 14px;color:#666" onclick="$(\'.hideCommentList\').show();$(this).hide();tabsHeight();">查看所有评论</a> </div> <div class="hideMessageList" style="display: none;"> ';
    for (var k = 1; k < it.messageList.length; k++) {
        var message = it.messageList[k];
        out += ' <!--<div class="page">--> <div class="tm-box fl wb" style="margin-top: 15px;"> <span class="month" style="margin-right:11px;">' + (getDateStr(message.createDatetime)) + '</span> <span class="alltime">' + (getTimeStr(message.createDatetime)) + '</span> </div> <div class="list"> <div class="messageContent"> ' + (message.content) + ' </div> <div class="p-all" style="width: 100%;float: left"> ';
        for (var i = 0; i < message.artworkCommentList.length; i++) {
            var comment = message.artworkCommentList[i];
            if (typeof comment.fatherComment != "undefined" && comment.fatherComment != null) {
                out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">';
                if (comment.creator.id == getCurrentUserId()) {
                    out += '我的';
                } else {
                    out += ' ' + (comment.creator.name) + ' ';
                }
                out += '</a>回复<a onclick="redirectUser(\'' + comment.fatherComment.creator.id + '\')">' + (comment.fatherComment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
            } else {
                out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">' + (comment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
            }
            out += ' ';
        }
        out += ' <div class="hideCommentList' + (message.id) + '" style="display: none;"> ';
        for (var i = 5; i < message.artworkCommentList.length; i++) {
            var comment = message.artworkCommentList[i];
            if (typeof comment.fatherComment != "undefined" && comment.fatherComment != null) {
                out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">';
                if (comment.creator.id == getCurrentUserId()) {
                    out += '我的';
                } else {
                    out += ' ' + (comment.creator.name) + ' ';
                }
                out += '</a>回复<a onclick="redirectUser(\'' + comment.fatherComment.creator.id + '\')">' + (comment.fatherComment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
            } else {
                out += ' <p class="p-list"><a onclick="redirectUser(\'' + comment.creator.id + '\')">' + (comment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> ';
            }
            out += ' ';
        }
        out += ' </div> </div> <a style="font-size: 14px;color:#666" onclick="$(\'.hideCommentList' + (message.id) + '\').show();$(this).hide();tabsHeight();">查看所有评论</a> </div> <!--</div>--> ';
    }
    out += ' </div> <div class="button"> <a onclick="$(\'.hideMessageList\').show();$(this).hide();tabsHeight();">查看更多动态</a> </div> </div>';
    return out;
}
//获得项目详情的view
function getArtWorkDetailHtml(it /**/) {
    var out = ' <div class="details"> <h5>项目介绍</h5> <div class="content"> <p>' + (it.description) + '</p> ';
    for (var i = 0; i < it.artworkAttachmentList.length; i++) {
        out += ' <a href=""><img src="' + (it.artworkAttachmentList[i].fileName) + '" alt=""></a> ';
    }
    out += ' </div> </div> <div class="details"> <h5>创作过程说明</h5> <div class="content"> ' + (it.make_instru) + ' </div> </div> <div class="details"> <h5>融资解惑</h5> <div class="content"> ' + (it.financing_aq) + ' </div> </div>';
    return out;
}
//获得用户评价的view
function getArtWorkCommentHtml(it /**/) {
    var out = ' ';
    for (var i = 0; i < it.commentList.length; i++) {
        var comment = it.commentList[i];
        if (typeof comment.fatherComment != "undefined" && comment.fatherComment != null) {
            out += ' <li> <div class="pic"><a onclick="redirectUser(\'' + comment.creator.id + '\')"><img src="' + (comment.creator.pictureUrl) + '" alt=""></a></div> <div class="box"> <div class="name"><span>' + (comment.creator.name) + '</span><span class="time">' + (getTimeStr(comment.createDatetime)) + '</span> </div> <!--回复--> <div class="content"> <div class="reply"> <p>回复 <a onclick="redirectUser(\'' + comment.fatherComment.creator.id + '\')">' + (comment.fatherComment.creator.name) + '</a>：<span>' + (comment.content) + '</span> </p> </div> </div> </div> </li> ';
        } else {
            out += ' <li> <div class="pic"><a onclick="redirectUser(\'' + comment.creator.id + '\')"><img src="' + (comment.creator.pictureUrl) + '" alt=""></a></div> <div class="box"> <div class="name"><span>' + (comment.creator.name) + '</span><span class="time">' + (getTimeStr(comment.createDatetime)) + '</span> </div> <div class="content">' + (comment.content) + '</div> </div> </li> ';
        }
        out += ' ';
    }
    return out;
}
//拍卖纪录的view
function getArtWorkAuctionBiddingHtml(it /**/) {
    var out = ' ';
    for (var i = 0; i < it.artWorkBiddingList.length; i++) {
        var bidding = it.artWorkBiddingList[i];
        out += ' <li> <span><img src="' + (bidding.creator.headUrl) + '" alt=""><strong>' + (dealUsername(bidding.creator.username)) + '</strong></span> <span><strong>出价了</strong> <b>' + (parseInt(bidding.price)) + '元</b></span> <span>' + (getTimeStr(bidding.createDatetime)) + '</span> </li> ';
    }
    return out;
}

//拍卖前
function getPreBottomButtonHtml(it /**/) {
    var out = '';
    if (it.step == "30") {
        out += '<div class="pm_btm_bar"> <a class="links" onclick="redirectComment(\'' + (getCurrentUserId()) + '\')" title="评论">评论</a> <a class="links" id="btn_pay" title="缴纳保证金">缴纳保证金</a></div><!--//End--底部悬浮--><div id="btn_pay_pannel" class="pm_pay_lay"> <div class="main"> <em class="close"></em> <div class="p1"> <p> <span>保证金</span><span class="price">¥' + (getDepositPrice(it.startingPrice)) + '</span> </p> </div> <div class="p2">保证金将直接从您的个人账户中冻结，若竞拍不成功在72小时之内释放保证金。</div> <div class="p3"><i id="radio" class="active"></i>竞拍需同意融艺投竞拍协议<a onclick="redirectProtocol()">《融艺投竞拍协议》</a></div> <a onclick="submitDepositPrice(\'' + (it.startingPrice) + '\')" class="submit">提交保证金</a> </div></div><!--//End--缴纳保证金--><div class="pm_dialog"> <div class="content"> <div class="close"></div> <div class="info"> <p>很遗憾地告诉您，您的个人账户余额不足。只需充值起拍金额的10 %，就可以参与拍卖了。</p> </div> <a onclick="redirectPay()" class="btn" title="去充值">去充值</a> </div></div>';
    }
    return out;
}

//拍卖中
function getBeingBottomButtonHtml(it /**/) {
    var out = '';
    if (it.step == "31") {
        out += '<div class="pm_btm_bar" style="z-index:120;"> <div class="bid"> <a id="bid-link" onclick="bid()">出价</a> <span class="num addsub" data-option=\'{"upLimit":-1,"inputName":"auctionPrice","downLimit":' + (getCurrentAuctionPrice(it.currentAuctionPrice)) + ' ,"defaultValue":' + (getCurrentAuctionPrice(it.currentAuctionPrice)) + ' }\' onload="ChooseCountComponent()"> <!--<em class="sub"></em>--> <!--<input disabled="true" type="text" value="2000">--> <!--<em class="add"></em>--> </span> <a onclick="redirectComment(\'' + (getCurrentUserId()) + '\')">评论</a> </div></div><!--//End--出价部分--><!--<<<点击出价后的提示框 出价成功和出价失败都会弹出提示框>>>--><div id="alert"></div><!--//End--点击出价后的提示框-->';
    }
    return out;
}
//拍卖后
function getAfterBottomButtonHtml(it /**/) {
    var out = '';
    if (it.step == "32" && it.winner.id == getCurrentUserId()) {
        out += '<div id="btn_pay_pannel" class="pm_pay_lay"> <div class="main"> <em class="close"></em> <div class="p1"> <p> <span>尾款金额</span><span class="price">¥' + (getCurrentFinalPrice()) + '</span> </p> </div> <div class="p2">尾款金额将直接从您的个人账户当中扣除。</div> <div class="p3"><i id="radio2" class="active"></i>竞拍需同意融艺投竞拍协议<a onclick="redirectProtocol()">《融艺投竞拍协议》</a> </div> <a onclick="redirectPay()" class="submit">去付尾款</a> </div></div>';
    }
    return out;
}