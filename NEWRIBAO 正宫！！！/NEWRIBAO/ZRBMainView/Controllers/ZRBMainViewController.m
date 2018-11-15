//
//  ZRBMainViewController.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/10/28.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "ZRBMainViewController.h"

@interface ZRBMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ZRBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _refreshNumInteger = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTongZhiController:) name:@"reloadDataTongZhiController" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"今日新闻";
    
    _refresh = YES;
    _mainAnalyisMutArray = [[NSMutableArray alloc] init];
    
    _allDateMutArray = [[NSMutableArray alloc] init];
    
    _mainCellJSONModel = [[ZRBCellModel alloc] init];
    [_mainCellJSONModel giveCellJSONModel];
    _mainCellJSONModel.delegateCell = self;

    //开启滑动返回功能代码
    if ( [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _scrollView.contentSize = CGSizeMake(0, 900);

    _scrollView.delegate = self;
    
    
    _messageView = [[ZRBMessageVView alloc] init];
    
    [_messageView initTableView];
    
    [_scrollView addSubview:_messageView];
    
    _MainView = [[ZRBMainVIew alloc] init];
    
    [_MainView initMainTableView];
    
    [_MainView.leftNavigationButton addTarget:self action:@selector(pressLeftBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _MainView.delegate = self;
    
    [_scrollView addSubview:_MainView];
    
    _MainView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    _MainView.mainMessageTableView.delegate = self;
    _MainView.mainMessageTableView.dataSource = self;
    [self.view addSubview:_scrollView];
    
    [self fenethMessageFromManagerBlock:NO];
}

//manager类网络请求

//给这加个参数 BOOL 类型 判断是否上拉 传参数进行以下两种判断即可
- (void)fenethMessageFromManagerBlock:(BOOL)isRefresh
{
    _mainImageMutArray1 = [[NSMutableArray alloc] init];
    _mainTitleMutArray1 = [[NSMutableArray alloc] init];
    _titleMutArray1 = [[NSMutableArray alloc] init];
    _imageMutArray1 = [[NSMutableArray alloc] init];
    
    NSMutableArray * mainImageMutArray = [[NSMutableArray alloc] init];
    NSMutableArray * mainTitleMutArray = [[NSMutableArray alloc] init];
    //测试
    NSString * mainTestStr = [[NSString alloc] init];
    if ( isRefresh == NO ){
        [[ZRBCoordinateMananger sharedManager] fetchDataFromNetisReferesh:NO Succeed:^(NSArray *array) {
            NSLog(@"array = %@",array);
        } error:^(NSError *error) {
            NSLog(@"网络请求错误");
        }];
    
    }else{
        [[ZRBCoordinateMananger sharedManager] fetchDataFromNetisReferesh:YES Succeed:^(NSArray *array) {
            NSLog(@"多次之后的 array = %@",array);
            //传cell的方法
            // 把stories部分数据解析之后
            //1.把文字和照片分别存入 二维数组中
            
            for (int i = 0; i < array.count; i++) {
                TotalJSONModel * totalJSONModel = array[i];
                //现在这里面有一天的数据
                NSLog(@"totalJSONModel.stories = %@",totalJSONModel.stories);
                //一天的数据
                NSMutableArray * titleMutArray = [[NSMutableArray alloc] init];
                NSMutableArray * imageMutArray = [[NSMutableArray alloc] init];
                [_allDateMutArray addObject:totalJSONModel.date];
                NSArray * data = totalJSONModel.stories;
                NSLog(@"data.count = %li - -- - - - - - -- - - ",data.count);
                    for (int i = 0; i < data.count; i++) {
                        StoriesJSONModel * storJSONMOdel = data[i];
                        [titleMutArray addObject:storJSONMOdel.title];
                        NSURL * JSONUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",storJSONMOdel.images[0]]];
                        NSData * imageData = [NSData dataWithContentsOfURL:JSONUrl];
                        UIImage * image = [UIImage imageWithData:imageData];
                        if ( image ){
                            [imageMutArray addObject:image];
                        }
                        
                    }
                [_titleMutArray1 addObject:titleMutArray];
                [_imageMutArray1 addObject:imageMutArray];
                //刚把数组成功变成二维数组 下面只需要按[indepath.section][indexPath.row]赋值即可
                
            }
            
            NSLog(@"_titleMutArray1 = %@",_titleMutArray1);
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_MainView.mainMessageTableView reloadData];
//            });
            
            NSNotification * reloadDateNotification = [NSNotification notificationWithName:@"reloadDataTongZhiController" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:reloadDateNotification];
        } error:^(NSError *error) {
            NSLog(@"网络请求错误");
        }];
        
    }
    

}

- (void)reloadDataTongZhiController:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_MainView.mainMessageTableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"_allDateMutArray.count = %li",_allDateMutArray.count);
    return _allDateMutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ( cell == nil ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section = %li",section);
    NSArray * array = [NSArray arrayWithObject:_imageMutArray1[section]];
    NSInteger i = 0;
    for (NSString * images in array[0]) {
        i++;
    }
    return i;
}

// 行数 和 列数 全部设置完毕
//下面开始显示数据
//cellForRowAtIndexPath 方法！！！








- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"发起上拉加载12321312321");
    if (scrollView.bounds.size.height + scrollView.contentOffset.y >scrollView.contentSize.height) {
        
        [UIView animateWithDuration:1.0 animations:^{
            
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            
        } completion:^(BOOL finished) {
            
            NSLog(@"发起上拉加载");
            if ( _refresh ){
                NSLog(@"发起上拉加载assdasdasdsa");
            _MainView.testStr = @"你好,我是中国人";
                ZRBCoordinateMananger * manager = [ZRBCoordinateMananger sharedManager];
                manager.ifAdoultRefreshStr = @"用户已经刷新过一次";
                NSLog(@"manager.ifAdoultRefreshStr = == == = = %@",manager.ifAdoultRefreshStr);
                [self fenethMessageFromManagerBlock:YES];
                _refresh = NO;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:1.0 animations:^{
                    
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    
                }];
            });
        }];
        
        
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadDataTongZhiController" object:nil];
}

- (void)giveCellJSONModelToMainView:(NSMutableArray *)imaMutArray andTitle:(NSMutableArray *)titMutArray
{

    NSLog(@"****************    imaMutArray = == = = =%@",imaMutArray);
    NSLog(@"****************Controlller代理协议里的  _imageMutArray = == = = = = == = %@",_mainImageMutArray1);
}



- (void)pushToWKWebView
{

    //现在的问题是 在这里设置断点  但是 不走 SecondaryMessageViewController.m文件中的viewDidLoad方法
    SecondaryMessageViewController * secondMessageViewController = [[SecondaryMessageViewController alloc] init];
    
    [self.navigationController pushViewController:secondMessageViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"每日新闻";

    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pressLeftBarButton:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)pressLeftBarButton:(UIBarButtonItem *)leftBtn
{
    NSLog(@"666666");
    if ( _iNum == 0 ){
        [_MainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //        make.height.mas_equalTo(self.view.bounds.size.height);
            //        make.width.mas_equalTo(
            make.left.equalTo(self.view).offset(250);
            make.top.equalTo(self.view).offset(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-250);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
            
            //创建另一个controller
            
            
            
            [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.top.equalTo(self.view).offset(50);
                make.bottom.equalTo(self.view).offset(-50);
                make.width.mas_equalTo(250);
                make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-100);
            }];
            
            //make.edges.equalTo(self.view);
        }];
        //在这里new 一个新的视图！
        
        //[_aView initScrollView];
        _iNum++;
    }
    
    
    else{
        [_MainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        //在这里new出来的新视图 坐标改变！
        _iNum--;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
