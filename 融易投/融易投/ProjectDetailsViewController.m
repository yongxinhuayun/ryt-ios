//
//  ProjectDetailsViewController.m
//  融易投
//
//  Created by efeiyi on 16/4/20.
//  Copyright © 2016年 dongxin. All rights reserved.
//

#import "ProjectDetailsViewController.h"

#import "ProjectDetailsCell1.h"

#import <MJExtension.h>

#import "ProjectDetailsResultModel.h"
#import "ProjectDetailsModel.h"

#import "ImageCollectionViewCell.h"


@interface ProjectDetailsViewController () //<UICollectionViewDataSource,UICollectionViewDelegate>

//存放模型的数组
@property (nonatomic, strong) NSMutableArray *models;

//存放模型的字典
@property (nonatomic, strong) ProjectDetailsResultModel *dict;

/** 所有照片 */
@property (nonatomic ,strong) NSMutableArray *imagesList;

@end

@implementation ProjectDetailsViewController

static NSString *ID1 = @"projectDetailsCell1";

static NSString *ID4 = @"imageCell";

//static NSInteger const cols = 4;
//static CGFloat const margin = 10;

#define  cellWH  ((SSScreenW - (cols - 1) * margin) / cols)


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     [self loadData];
    
    [ProjectDetailsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"descriptions":@"description",
                 };
    }];
    
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceprArtWorkID:) name:ProjectDetailsArtWorkIdNotification object:nil];
    
    //注册创建cell ,这样注册就不用在XIB设置ID
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectDetailsCell1" bundle:nil] forCellReuseIdentifier:ID1];
}

//-(void)acceprArtWorkID:(NSNotification *)note {
//    
//    NSLog(@"%@",note.userInfo[@"artWordID"]);
//    
//    
//}

//加载数据
-(void)loadData
{
    //参数
    NSString *artWorkId = [[NSUserDefaults standardUserDefaults] objectForKey:@"artWorkId"];
    
    NSLog(@"-----%@",artWorkId); //imyuxey8ze7lp8h5 ---in5z7r5f2w2f73so
    
    
    NSString *currentUserId = @"imhipoyk18s4k52u";
    
    NSString *timestamp = [MyMD5 timestamp];
    NSString *appkey = MD5key;
    
    NSString *signmsg = [NSString stringWithFormat:@"artWorkId=%@&currentUserId=%@&timestamp=%@&key=%@",artWorkId,currentUserId,timestamp,appkey];
    
    NSLog(@"%@",signmsg);
    
    NSString *signmsgMD5 = [MyMD5 md5:signmsg];
    
    // 1.创建请求 http://j.efeiyi.com:8080/app-wikiServer/
    NSString *url = @"http://192.168.1.69:8001/app/investorArtWorkView.do";
    
    // 3.设置请求体
    NSDictionary *json = @{
                           @"artWorkId" : artWorkId,
                           @"currentUserId":currentUserId,
                           @"timestamp" : timestamp,
                           @"signmsg"   : signmsgMD5
                           };
    
    [[HttpRequstTool shareInstance] handlerNetworkingPOSTRequstWithServerUrl:url Parameters:json showHUDView:self.view success:^(id respondObj) {
        
        
//        NSString *jsonStr=[[NSString alloc] initWithData:respondObj encoding:NSUTF8StringEncoding];
//        NSLog(@"返回结果:%@",jsonStr);
        
        /*
         {"resultCode":"0",
         "resultMsg":"成功",
         "object":{
                "artworkAttachmentList":[],
                "artWork":{
                        "id":"qydeyugqqiugd7","title":"测试6","brief":"这是一个","description":null,"status":"1","investGoalMoney":1.00,"investStartDatetime":1455005261000,"investEndDatetime":1454314064000,"auctionStartDatetime":1454400455000,"auctionEndDatetime":1462003649000,
                        "author":{
                             "id":"icjxkedl0000b6i0","username":"123123","name":"魏立中","pictureUrl":"http://tenant.efeiyi.com/background/蔡水况.jpg","cityId":null,"status":"0","createDatetime":null,"type":"10000",
                              "master":
                                  {"id":"icjxkedl0000b6i0","brief":"版画家，他使得业已消失数百年的明代印刷业老字号十竹斋重新恢复并焕发生机，成为杭州市文化产业传承创新的亮点。","title":"国家级传承人","favicon":"http://tenant.efeiyi.com/background/蔡水况.jpg","birthday":"1968年","level":"1","content":null,"presentAddress":"浙江","backgroundUrl":"background/魏立中.jpg","provinceName":"浙江","theStatus":"1","logoUrl":"logo/魏立中.jpg","masterSpeech":null,"artCategory":null,"titleCertificate":null,"feedback":null,"identityFront":null,"identityBack":null}},
                    "createDatetime":1454314046000,"picture_url":"http://tenant.efeiyi.com/background/蔡水况.jpg","step":"31","investsMoney":0,"creationEndDatetime":1458285492000,"type":"3","newCreationDate":null,"auctionNum":null,"newBidingPrice":500.00,"newBiddingDate":null,"sorts":"6","winner":null,"feedback":null,"duration":null,"startingPrice":1000},
         "investNum":0,
         "artworkdirection":null,
         "isPraise":false,
         "time":"70日22时56分57秒"}}
        */
        
        NSDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:respondObj options:kNilOptions error:nil];
        
//        NSLog(@"%@",modelDict);

        //字典数组 -> 模型数组
        ProjectDetailsResultModel *dict = [ProjectDetailsResultModel mj_objectWithKeyValues:modelDict];

        self.dict = dict;
        
//        NSLog(@"%@",self.dict);
//        
//        self.imagesList = dict.object.artworkAttachmentList;
//        
//        NSLog(@"%ld",self.imagesList.count);
        
        
        //在主线程刷新UI数据
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ProjectDetailsCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:ID1];
    
    ProjectDetailsResultModel *model = self.dict;
    
    
    
    cell1.model = model;
    
    /*
    //设置cell中每个按钮的此存
    cell1.collectionViewFlowLayout.itemSize = CGSizeMake(cellWH, cellWH);
    
    //设置cell之间的间距
    cell1.collectionViewFlowLayout.minimumInteritemSpacing = margin;
    cell1.collectionViewFlowLayout.minimumLineSpacing = margin;
    
    
    //设置UICollectionView的数据源,设置数据
    cell1.collectionView.dataSource = self;
    
    //14. 处理点击方块的业务逻辑,实现点击方块,跳转到网页界面
    //设置点击方块代理
    cell1.collectionView.delegate = self;
    
    
    [cell1.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID4];
    
    //10. 因为UICollectionView作为控制器的tableView的footerView,所以我们不能让UICollectionView视线自己滚动,而是跟着控制器的tableView的滚动而滚动
    //取消collectionView的弹簧效果,还是不行
    //        self.collectionView.bounces = NO;
    //设置collectionView不能滚动 ---- 直接跳进collectionView的头文件搜索scroll,发现并没有相关属性,跳进父类UIScrollView中搜素发现scrollEnabled属性
    cell1.collectionView.scrollEnabled = NO;
     */

   
    return cell1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{

//    BSTopic *topic = self.topics[indexPath.row];
//    
//    //    BSLog(@"%zd  ======  %zd---%zd",indexPath.row,topic.height,topic.width);
//    
//    return topic.cellHeight;
    
    
    return 650;
        
}

/********************************UICollectionView*******************************************/

/*
//实现UICollectionView数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    
    return 8;
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell,并且一看到方法中含有forIndexPath参数一定是要使用注册来创建的
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID4 forIndexPath:indexPath];
    
    //    cell.backgroundColor = [UIColor redColor];
    
    //6. 设置cell的数据---因为原图现实的cell是上下结构的,所以我们还得需要自定义cell
    //7. 因为要给cell设置数据,所以cell中应该有个属性,然后在cell中实现数据的set方法
    
    //取出数据
    ArtworkAttachmentListModel *model = self.imagesList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}
*/


@end
