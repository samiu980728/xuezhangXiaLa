//
//  SecondaryMessageViewController.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/10/28.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "SecondaryMessageViewController.h"

@interface SecondaryMessageViewController ()

@end

@implementation SecondaryMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建一个通知 在通知里面传值
    
    NSLog(@"_resaveIdString = %@",_resaveIdString);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Dicttongzhi1:) name:@"Dicttongzhi1" object:nil];
    _mainWebView = [[ZRBMainWKWebView alloc] init];
    
    _requestModel = [[ZRBRequestJSONModel alloc] init];
    NSInteger intEger = [_resaveIdString integerValue];
    _requestModel.idRequestStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:intEger]];
    //[_requestModel setStr];
    [_requestModel requestJSONModel];
    
    //现在连idRequestStr 都请求不来 更别说 通过idRequestStr 才能请求到 的 modelStr了
    //_mainWebView.modelStr = [NSString stringWithFormat:@"%@",_requestModel.idRequestStr];
    _mainWebView.modelStr = [NSString stringWithFormat:@"%@",_requestModel.modelStr];
    [_mainWebView createAndGetJSONModelWKWebView];
    
    [_mainWebView recieveNotification];
    [self.view addSubview:_mainWebView];
    
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //加载tabBarView
    _tabBarView = [[ZRBTabBarView alloc] init];
    [self.view addSubview:_tabBarView];
    [_tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(674);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.bounds.size.width);
        make.bottom.equalTo(self.view);
    }];
}

- (void)Dicttongzhi1:(NSNotification *)noti
{
    _mainWebView.modelStr = _requestModel.modelStr;
    NSLog(@"_mainWebView.modelStr === ----- -- -- - -- - - - - - -- - -- --- -- %@",_mainWebView.modelStr);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
