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
    
    self.title = [NSString stringWithFormat:@"%@ comments",[NSNumber numberWithInteger:_allCommentsNumInteger]];
    [self fenethLongCommentsFromJSONModel];
    self.commentView = [[ZRBCommentView alloc] init];
//    _commentView.tableView.delegate = self;
//    _commentView.tableView.dataSource = self;
    [self.view addSubview:_commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)fenethLongCommentsFromJSONModel
{
    [[ZRBCommentManager sharedManager] fetchCommentsNumDataFormNewsViewWithIdString:_secondResaveIdString Succeed:^(ZRBNewsAdditionalJSONModel *additionalJSONModel) {
        if ( additionalJSONModel.long_comments != 0 ){
            //执行长评论网络请求
            [[ZRBCommentManager sharedManager] fetchLongLongCommentsDataFromNewsViewWith:_secondResaveIdString Succeed:^(ZRBLongCommentsJSONModel *longCommentsJSONModel) {
                NSLog(@"longCommentsJSONModel = %@",longCommentsJSONModel);
                NSLog(@"longCommentsJSONModel.comments.count = %li",longCommentsJSONModel.comments.count);
                NSArray * array = [NSArray arrayWithObject:longCommentsJSONModel.comments[0]];
                NSLog(@"array = %@",array);
            } error:^(NSError *error) {
                NSLog(@"网络请求出错： %@",error);
            }];
        }
    } error:^(NSError *error) {
        NSLog(@"网络请求失败：原因  %@",error);
    }];
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
