//
//  SecondaryMessageViewController.h
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/10/28.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRBMainWKWebView.h"
#import <Masonry.h>
#import "ZRBRequestJSONModel.h"
#import "ZRBTabBarView.h"
#import "ZRBCommentManager.h"
#import "ZRBCoordinateMananger.h"
#import "ZRBCommentViewController.h"
//代理传值 COntroller层 传值给View层 网络中的信息
@protocol ZRBGiveJSONModelMessageToViewDelegate <NSObject>

- (void) giveJSONModelMessageToView;

@end

@interface SecondaryMessageViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZRBMainWKWebView * mainWebView;

@property (nonatomic, strong) ZRBRequestJSONModel * requestModel;

@property (nonatomic, weak) id <ZRBGiveJSONModelMessageToViewDelegate> delegate;

@property (nonatomic, copy) NSString * resaveIdString;

@property (nonatomic, strong) ZRBTabBarView * tabBarView;

//总评论数量与点赞数量
@property (nonatomic, assign) NSInteger allsApprovalInteger;

@property (nonatomic, assign) NSInteger allsCommentsInteger;

@property (nonatomic, strong) ZRBCommentViewController * commentVIewController;

- (void)fenethCommentsNumFromCommentManagerBlock;
@end
