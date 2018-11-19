//
//  ZRBTabBarView.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/11/19.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "ZRBTabBarView.h"
#import <Masonry.h>
@implementation ZRBTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shareNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.giveApproveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.goNextNewsViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.returnMainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:_shareNewsButton];
        [self addSubview:_commentNewsButton];
        [self addSubview:_giveApproveButton];
        [self addSubview:_goNextNewsViewButton];
        [self addSubview:_returnMainViewButton];
    }
    return self;
}

- (void)layoutSubviews
{
    NSInteger padding = 40;
    self.backgroundColor = [UIColor whiteColor];
    [_returnMainViewButton setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [_goNextNewsViewButton setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    [_giveApproveButton setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    [_shareNewsButton setImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
    [_commentNewsButton setImage:[UIImage imageNamed:@"7.png"] forState:UIControlStateNormal];
    
    [@[_returnMainViewButton,_goNextNewsViewButton,_giveApproveButton,_shareNewsButton,_commentNewsButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:20 tailSpacing:20];
    [@[_returnMainViewButton,_goNextNewsViewButton,_giveApproveButton,_shareNewsButton,_commentNewsButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
}

- (void)initCommentView
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
