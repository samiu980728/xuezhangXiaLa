//
//  ZRBCommentViewController.h
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/11/19.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRBCommentView.h"
#import "ZRBCommentManager.h"
@interface ZRBCommentViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ZRBCommentView * commentView;

@property (nonatomic, strong) NSString * secondResaveIdString;

@property (nonatomic, assign) NSInteger allCommentsNumInteger;
- (void)fenethLongCommentsFromJSONModel;

@end
