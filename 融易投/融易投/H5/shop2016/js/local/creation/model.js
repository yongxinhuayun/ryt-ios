/**
 * Created by Administrator on 2016/5/31 0031.
 */
//页面上需要的数据
var ArtWorkInfo = function (picture_url, masterName, brief, auctionStartDatetime, step, name, title, headUrl, masterId) {
    this.picture_url = picture_url;   //主图
    this.masterName = masterName;       //大师名称
    this.brief = brief;                 //项目简介
    this.auctionStartDatetime = auctionStartDatetime; //预计完成时间，拍卖事件
    this.step = step;     //项目阶段
    this.name = name;       //项目名称
    this.title = title;     //大师头衔
    this.headUrl = headUrl; //头像图片链接
    this.masterId = masterId; //大师的id
}
//项目主要信息（项目进度专用）
var ArtWorkProject = function (investEndDatetime, step, artworkInvestsSize, investStartDatetime, messageList, auctionStartDatetime) {
    this.investEndDatetime = investEndDatetime;   //融资结束时间
    this.step = step;                             //项目审核状态
    this.artworkInvestsSize = artworkInvestsSize;  //项目投资人数
    this.investStartDatetime = investStartDatetime; //投资开始时间
    this.messageList = messageList;           //状态列表
    this.auctionStartDatetime = auctionStartDatetime; //创作开始时间
}
//项目详情（项目详情tab页专用）
var ArtWorkView = function (artworkAttachmentList, description, make_instru, financing_aq) {
    this.artworkAttachmentList = artworkAttachmentList;//1.图片列表
    this.description = description;//2.项目描述
    this.make_instru = make_instru;//3.项目制作说明
    this.financing_aq = financing_aq//4.项目融资答疑
}
//用户评价
var ArtWorkComment = function (commentList) {
    this.commentList = commentList;//1.用户评价列表
}
//投资记录（投资记录tab页专用）
var ArtWorkInvestRecord = function (investList, topThreeList) {
    this.investList = investList;//1.投资记录列表
    this.topThreeList = topThreeList;
}

var PageVariable = {
    artWorkId: "",          //当前项目的id
    artWorkInfo: "",        //当前项目的基本信息对象
    artWorkProject: "",     //当先项目的项目进度以及动态对象
    artWorkView: "",        //当前项目详情的对象
    artWorkComment: "",     //当前项目的用户评价对象
    artWorkInvestRecord: "" //当前项目投资记录对象
};    //页面中主要的全局变量