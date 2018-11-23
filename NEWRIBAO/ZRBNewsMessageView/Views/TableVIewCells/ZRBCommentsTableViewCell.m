//
//  ZRBCommentsTableViewCell.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/11/22.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "ZRBCommentsTableViewCell.h"
#import <Masonry.h>

@interface ZRBCommentsTableViewCell ()

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UILabel * avatarImageLabel;

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) UILabel * approvalLabel;

@property (nonatomic, strong) UIButton * approvalButton;

@property (nonatomic, strong) UIImageView * avatarImage;

@end

@implementation ZRBCommentsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self == [super initWithStyle:style reuseIdentifier:reuseIdentifier] ){
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.timeLabel = [[UILabel alloc] init];
    self.contentLabel = [[UILabel alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.avatarImageLabel = [[UILabel alloc] init];
    self.approvalLabel = [[UILabel alloc] init];
    self.approvalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarImage = [[UIImageView alloc] init];
    
    self.avatarImage.layer.cornerRadius = 25;
    self.avatarImage.layer.masksToBounds = YES;
//    setenv(, <#const char *__value#>, <#int __overwrite#>)
    
    [self.approvalButton setImage:[UIImage imageNamed:@"8.png"] forState:UIControlStateNormal];
    
    self.timeLabel.numberOfLines = 0;
    self.contentLabel.numberOfLines = 0;
//    self.nameLabel.numberOfLines = 1;
    self.avatarImageLabel.numberOfLines = 0;
    self.approvalLabel.numberOfLines = 0;
    
    self.timeLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width ;
    self.nameLabel.preferredMaxLayoutWidth = 60;
    self.avatarImageLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width ;
    self.approvalLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width ;
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width ;
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.approvalButton];
    [self.contentView addSubview:self.avatarImage];
    
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
        make.right.mas_equalTo(self.contentView.mas_left).offset(58);
        make.bottom.mas_equalTo(self.contentView.mas_top).offset(65);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImage.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-150);
        make.bottom.mas_equalTo(self.contentView.mas_top).offset(30);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.contentLabel.mas_left);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10).offset(-20);
    }];
    
    [self.approvalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel.mas_right).offset(-40);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_top).offset(30);
    }];
    //下一步  照片网络请求错误  看看到底咋回事
}

- (void)setMessage:(ZRBCommentsJSONModel *)message
{
    //NSLog(@"message = %@",message);
    NSMutableAttributedString * finalContentStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString * contentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[message valueForKey:@"content"]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    [finalContentStr appendAttributedString:contentString];
    self.contentLabel.attributedText = finalContentStr;
    
    NSMutableAttributedString * finalNameStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString * nameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[message valueForKey:@"author"]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [finalNameStr appendAttributedString:nameString];
    self.contentLabel.attributedText = finalNameStr;
    
    NSMutableAttributedString * finalTimeStr = [[NSMutableAttributedString alloc] init];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString * realTimeStr = [NSString stringWithFormat:@"%@",[message valueForKey:@"time"]];
    NSTimeInterval time = [realTimeStr doubleValue];
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //时间戳转时间
    NSString * confromTimespStr = [formatter stringFromDate:detailDate];
    NSLog(@"confromTimespStr = %@",confromTimespStr);
    
    
//    NSAttributedString * timeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[message valueForKey:@"time"]] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor grayColor]}];
    NSAttributedString * timeString = [[NSAttributedString alloc] initWithString:confromTimespStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor grayColor]}];
    [finalTimeStr appendAttributedString:timeString];
    [finalNameStr appendAttributedString:nameString];
    [finalContentStr appendAttributedString:contentString];
    
    self.contentLabel.attributedText = finalContentStr;
    self.nameLabel.attributedText = finalNameStr;
    self.timeLabel.attributedText = finalTimeStr;
    
    NSLog(@"avatar = %@",[message valueForKey:@"avatar"]);
    NSString * urlStr = [NSString stringWithFormat:@"%@",[message valueForKey:@"avatar"]];
    [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    UIImage * avatarImage = [UIImage imageWithData:imageData];
    self.avatarImage.image = avatarImage;
    
    self.approvalButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.approvalButton setTitle:[NSString stringWithFormat:@"%@",[message valueForKey:@"likes"]] forState:UIControlStateNormal];
    [self.approvalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
   // NSLog(@"likes = %@",[message valueForKey:@"likes"]);
    NSLog(@"self.avatarImage.image = %@",self.avatarImage.image);

}

- (CGFloat)heightForModel:(ZRBCommentsJSONModel *)message
{
    [self setMessage:message];
    [self layoutIfNeeded];
    
    CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return cellHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
