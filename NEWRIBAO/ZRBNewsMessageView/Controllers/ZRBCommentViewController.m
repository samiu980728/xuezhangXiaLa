//
//  ZRBCommentViewController.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/11/19.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "ZRBCommentViewController.h"
#import <Masonry.h>
@interface ZRBCommentViewController ()

@end

@implementation ZRBCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _authorMutArray = [[NSMutableArray alloc] init];
    _contentMMutArray = [[NSMutableArray alloc] init];
    _avatorMutArray = [[NSMutableArray alloc] init];
    _timeMutArray = [[NSMutableArray alloc] init];
    _reply_toMutArray = [[NSMutableArray alloc] init];
    _onlyIdMutArray = [[NSMutableArray alloc] init];
    _likesMutArray = [[NSMutableArray alloc] init];
    _longCommentsNumInteger = 0;
    
    self.title = [NSString stringWithFormat:@"%@ comments",[NSNumber numberWithInteger:_allCommentsNumInteger]];
    [self fenethLongCommentsFromJSONModel];
    self.commentView = [[ZRBCommentView alloc] init];
    _commentView.tableView.delegate = self;
    _commentView.tableView.dataSource = self;
    _commentView.tableView.estimatedRowHeight = 100;
    _commentView.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 && _longCommentsNumInteger == 0 ){
        return 1;
    }
    if ( section == 0 && _longCommentsNumInteger != 0 ){
        return _longCommentsNumInteger;
    }
    //第一组存在 第二组数量总是1 Row 第一组那种存在 第一组数量为1；
        return 1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //分这么几种可能 1.如果没有长评论
//    UITableViewCell * cell = nil;

//CELL自适应高度















//
//}



-(void)fenethLongCommentsFromJSONModel
{
    [[ZRBCommentManager sharedManager] fetchCommentsNumDataFormNewsViewWithIdString:_secondResaveIdString Succeed:^(ZRBNewsAdditionalJSONModel *additionalJSONModel) {
        _longCommentsNumInteger = 0;
        if ( additionalJSONModel.long_comments != 0 ){
            //执行长评论网络请求
            [[ZRBCommentManager sharedManager] fetchLongLongCommentsDataFromNewsViewWith:_secondResaveIdString Succeed:^(ZRBLongCommentsJSONModel *longCommentsJSONModel) {
                _longCommentsNumInteger = additionalJSONModel.long_comments;
                //1.创建一个数组接收 author
                [_authorMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"author"]];
                [_contentMMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"content"]];
                [_avatorMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"avatar"]];
                [_onlyIdMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"id"]];
                [_likesMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"likes"]];
                [_timeMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"time"]];
                ZRBReplyToJSONModel * replyJSONModel = [[ZRBReplyToJSONModel alloc] init];
                replyJSONModel = [longCommentsJSONModel.comments valueForKey:@"reply_to"];
                NSString * replyStr = [NSString stringWithFormat:@"%@",replyJSONModel];
                NSLog(@"replyStr = %@",replyStr);
                if ( ![replyStr isEqualToString:@"(\n    \"<null>\",\n    \"<null>\",\n    \"<null>\"\n)"]){
                [_reply_toMutArray addObject:[longCommentsJSONModel.comments valueForKey:@"reply_to"]];
                }
            } error:^(NSError *error) {
                NSLog(@"网络请求出错： %@",error);
            }];
        }else{
            _longCommentsNumInteger = 0;
        }
    } error:^(NSError *error) {
        NSLog(@"网络请求失败：原因  %@",error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationItem.leftBarButtonItem = nil;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

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
