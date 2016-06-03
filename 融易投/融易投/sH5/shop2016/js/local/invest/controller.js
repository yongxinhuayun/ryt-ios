/**
 * Created by Administrator on 2016/5/31 0031.
 */
function initPage(artWorkId, currentUserId, signmsg, timestamp) {
    var param = new Object();
    param.artWorkId = artWorkId;
    param.currentUserId = currentUserId;
    param.signmsg = signmsg;
    param.timestamp = timestamp;
    PageVariable.param = param;
    refreshPageEntity();
    getArtWorkBaseInfoData(getArtWorkBaseInfo);
    getArtWorkDetailData(getArtWorkDetail);
}

function getAuctionTimeResult() {
    if (PageVariable.artWorkInfo.step == "30") {
        countDown(PageVariable.artWorkInfo.auctionStartDatetime);
    } else {
        countDown(PageVariable.artWorkInfo.auctionEndDatetime);
    }
}

//获得项目基本信息的controller
function getArtWorkBaseInfo() {
    var artWorkInfo = PageVariable.artWorkInfo;
    var artWorkProject = PageVariable.artWorkProject;
    if (!artWorkProject.messageList.length > 0) {
        $("#dt").hide();
    }
    $("#mainPicture").html(getArtWorkBaseInfoPictureHtml(artWorkInfo));
    $("#mainInfo").html(getArtWorkBaseInfoMainHtml(artWorkInfo));
    $("#rz").html(getArtWorkScheduleInvestHtml(artWorkProject));
    $("#cz").html(getArtWorkScheduleCreateHtml(artWorkProject));
    $("#pm").html(getArtWorkScheduleAuctionHtml(artWorkProject));
    $("#dt").append(getArtWorkScheduleMessageHtml(artWorkProject));
    $("#auctionMessage").html(getArtWorkBaseInfoAuctionMessageHtml(artWorkInfo));
    getBottomButton();
    getAuctionTimeResult();
    tabsHeight();
}
//获得项目详情的controller
function getArtWorkDetail() {
    var artWorkView = PageVariable.artWorkView;
    $("#artWorkView").html(getArtWorkDetailHtml(artWorkView));
    tabsHeight();
}
//获得用户评价的controller
function getArtWorkComment() {
    var artWorkComment = PageVariable.artWorkComment;
    if (pageEntity.pageIndex == 1) {
        $("#userComment").html(getArtWorkCommentHtml(artWorkComment));
    } else {
        $("#userComment").append(getArtWorkCommentHtml(artWorkComment));
    }
    pageEntity.pageIndex = pageEntity.pageIndex + 1;
    tabsHeight();
}

function getArtWorkAuctionBidding() {
    var artWorkAuction = PageVariable.artWorkAuction;
    $("#auctionNum").html(artWorkAuction.auctionNum + "人参与拍卖");
    if (pageEntity.pageIndex == 1) {
        $("#auctionList").html(getArtWorkAuctionBiddingHtml(artWorkAuction));
    } else {
        $("#auctionList").append(getArtWorkAuctionBiddingHtml(artWorkAuction));
    }
    pageEntity.pageIndex = pageEntity.pageIndex + 1;
    getArtWorkAuctionBiddingTopThree()
    tabsHeight();
}

function getArtWorkAuctionBiddingTopThree() {
    var artWorkAuction = PageVariable.artWorkAuction;
    $("#currentAuctionTopThreeRecord").html(getArtWorkAuctionBiddingTopThreeHtml(artWorkAuction))
}

function getBottomButton() {
    var artWorkBaseInfo = PageVariable.artWorkInfo;
    $("#bottomButton").append(getPreBottomButtonHtml(artWorkBaseInfo));
    $("#bottomButton").append(getBeingBottomButtonHtml(artWorkBaseInfo));
    $("#bottomButton").append(getAfterBottomButtonHtml(artWorkBaseInfo));
    ChooseCountComponent();
}


//获得项目的基本信息
function getArtWorkBaseInfoData(callback) {
    var success = function (data) {
        ajaxSuccessFunctionTemplage(function (dataTemp) {
            var obj = dataTemp;
            var msgList = obj["artWorkMessage"];
            var artWork = obj["artwork"];
            var masterLevel = "";
            var auctionStartDatetime = new Date();
            auctionStartDatetime.setTime(artWork.auctionStartDatetime);
            var auctionStartDatetimeStr = auctionStartDatetime.format("MM月dd日");
            switch (artWork.author.master.level) {
                case "1":
                    masterLevel = "国家级";
                    break;
                case "2":
                    masterLevel = "省级";
                    break;
                case "3":
                    masterLevel = "市级";
                    break;
                case "4":
                    masterLevel = "县级";
                    break;
            }
            PageVariable.artWorkInfo = new ArtWorkInfo(artWork.picture_url, artWork.author.name, artWork.brief, artWork.auctionStartDatetime, artWork.step, artWork.title, artWork.author.master.title, artWork.author.pictureUrl, artWork.author.id, artWork.startingPrice, artWork.winner, artWork.auctionEndDatetime, artWork.newBidingPrice, artWork.creationEndDatetime);
            PageVariable.artWorkProject = new ArtWorkProject(artWork.investEndDatetime, artWork.step, artWork.investNum, artWork.investStartDatetime, msgList, artWork.auctionStartDatetime, artWork.creationEndDatetime);
            PageVariable.viewNum = artWork.viewNum;
            PageVariable.auctionNum = artWork.auctionNum;
            PageVariable.startingPrice = artWork.startingPrice;
            PageVariable.isSubmitDepositPrice = obj["isSubmitDepositPrice"]
        }, data, callback);
    }
    ajaxRequest(hostName + RequestUrl.initPage, getParamObject(), success, function () {
    }, "post");
}
//获得项目详情信息数据
function getArtWorkDetailData(callback) {
    var success = function (data) {
        ajaxSuccessFunctionTemplage(function (dataTemp) {
            var obj = dataTemp["object"];
            PageVariable.artWorkView = new ArtWorkView(obj.artworkAttachmentList, obj.artWork.description, obj.artworkdirection.make_instru, obj.artworkdirection.financing_aq);
        }, data, callback);
    }
    ajaxRequest(hostName + RequestUrl.artWorkViewTab, getParamObject(), success, function () {
    }, "post");
}
//获得项目评价信息数据
function getArtWorkCommentData(callback) {
    var success = function (data) {
        ajaxSuccessFunctionTemplage(function (dataTemp) {
            var obj = dataTemp["object"];
            PageVariable.artWorkComment = new ArtWorkComment(obj.artworkCommentList);
        }, data, callback)
    };
    var param = getParamObject();
    param.pageIndex = pageEntity.pageIndex;
    param.pageSize = pageEntity.pageSize;
    param.messageId = "";
    ajaxRequest(hostName + RequestUrl.commentTab, param, success, function () {
    }, "post");
}
//拍卖纪录
function getArtWorkAuctionData(callback) {
    var success = function (data) {
        ajaxSuccessFunctionTemplage(function (dataTemp) {
            var obj = dataTemp["object"];
            PageVariable.artWorkAuction = new ArtWorkAuction(obj.artWorkBiddingList);
            PageVariable.auctionNum = obj.artWorkBiddingList.length;

        }, data, callback)
    };
    var param = getParamObject();
    param.pageIndex = pageEntity.pageIndex;
    param.pageSize = pageEntity.pageSize;
    ajaxRequest(hostName + RequestUrl.auctionTab, param, success, function () {
    }, "post");
}


function artWorkProjectPanelAction() {
    loadDataAction = function () {
        console.log("bottom");
    }
}                   //页面滑到项目进度时候的action
function artWorkCommentPanelAction() {
    //初始化页面分页信息
    getArtWorkCommentData(getArtWorkComment); //页面从新加载评论的数据
    loadDataAction = function () {
        getArtWorkCommentData(getArtWorkComment);
    }
}                   //页面滑到用户评价时候的action
function artWorkViewPanelAction() {
    loadDataAction = function () {
        console.log("bottom");
    }
}                      //页面滑到项目详情时候的action
function artWorkAuctionPanelAction() {
    //初始化页面分页信息
    getArtWorkAuctionData(getArtWorkAuctionBidding); //页面从新加载拍卖的数据
    loadDataAction = function () {
        getArtWorkAuctionData(getArtWorkAuctionBidding);
    }
}                   //页面滑到拍卖纪录时候的action

