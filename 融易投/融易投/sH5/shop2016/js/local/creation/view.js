/**
 * Created by Administrator on 2016/5/31 0031.
 */
//获得项目基本信息轮播图的view
function getArtWorkBaseInfoPictureHtml(it) {
    return '<div class="swiper-slide"><a><img class="itam-img" src="' + it.picture_url + '" alt=""><span>' + it.name + '</span></a> </div>'
}
//获得项目基本信息的view
function getArtWorkBaseInfoMainHtml(it /**/) {
    var out = ' <div class="bd"> <div class="page"> <div class="mp"> <div class="pic"><a onclick="redirectUser(\'' + it.masterId + '\')"><img src="' + (it.headUrl) + '" alt=""></a></div> <div class="n-page"><span class="name">' + (it.masterName) + '</span><strong></strong><span class="rank">' + (it.title) + '</span></div> </div> <div class="t-page"> <div class="wh"> <i></i> <span>' + (it.brief) + '</span> <em></em> </div> </div> </div> </div> <div style="border-bottom-width: 0" class="bd"> ';
    if (it.step == 22) {
        out += ' <div class="predict"><span>延迟至：</span><span>' + (it.auctionStartDatetime) + '</span></div> ';
    } else {
        out += ' <div class="predict"><span>预计完成时间：</span><span>' + (it.auctionStartDatetime) + '</span><span>敬请期待</span> </div> ';
    }
    out += ' </div>';
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
//获得项目投资记录（排行榜）的view
function getArtWorkInvestRecordTopHtml(it /**/) {
    var out = ' ';
    var invest1 = it.topThreeList[1];
    out += ' <li class="no2" id="N2"><a onclick="redirectUser(\'' + invest1.creator.id + '\')"> <p class="img"><img src="' + (invest1.creator.pictureUrl) + '" alt=""></p></a><p class="name">' + (invest1.creator.name) + '</p> <p class="time">' + (getTimeStr(invest1.createDatetime)) + '</p> <p class="info">投资了</p> <p class="price">¥ ' + (parseInt(invest1.price)) + '</p> </li> ';
    var invest0 = it.topThreeList[0];
    out += ' <li class="no1" id="N1"><a onclick="redirectUser(\'' + invest1.creator.id + '\')"> <p class="img"><img src="' + (invest0.creator.pictureUrl) + '" alt=""></p> <p class="name">' + (invest0.creator.name) + '</p> <p class="time">' + (getTimeStr(invest0.createDatetime)) + '</p> <p class="info">投资了</p> <p class="price">¥ ' + (parseInt(invest0.price)) + '</p> </li> ';
    var invest2 = it.topThreeList[2];
    out += ' <li class="no3" id="N3"> <p class="img"><img src="' + (invest2.creator.pictureUrl) + '" alt=""></p> <p class="name">' + (invest2.creator.name) + '</p> <p class="time">' + (getTimeStr(invest2.createDatetime)) + '</p> <p class="info">投资了</p> <p class="price">¥ ' + (parseInt(invest2.price)) + '</p> </li>';
    return out;
}
//获得项目投资记录（列表）的view
function getArtWorkInvestRecordListHtml(it /**/) {
    var out = ' ';
    for (var i = 0; i < it.investList; i++) {
        var investTemp = it.investList[i];
        out += ' <li> <span><img src="' + (investTemp.creator.pictureUrl) + '" alt=""><strong>' + (dealUsername(investTemp.creator.username, 3, 4)) + '</strong></span> <span><strong>投资了</strong> <b>' + (parseInt(investTemp.price)) + '元</b></span> <span>' + (getTimeStr(investTemp.createDatetime)) + '</span> </li> ';
    }
    return out;
}
