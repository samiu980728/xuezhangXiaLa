//
//  ZRBCoordinateMananger.m
//  NEWRIBAO
//
//  Created by 萨缪 on 2018/11/6.
//  Copyright © 2018年 萨缪. All rights reserved.
//

#import "ZRBCoordinateMananger.h"

@interface ZRBCoordinateMananger()

@property (atomic, strong) NSMutableArray * dataMutArray;
@property (nonatomic, copy) NSString * lateseDate;
@property (nonatomic, strong) NSLock * lock;

@end

@implementation ZRBCoordinateMananger
static ZRBCoordinateMananger * manager = nil;

//单例创建仅仅执行一次 随时取用相关方法
+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.lock = [[NSLock alloc] init];
        manager.dataMutArray = [[NSMutableArray alloc] init];
    });
    return manager;
}

- (void)requestNewDateSucceed:(ZRBGetNewJSONModelHandle)succeedBlock error:(ErrorHandle)errorBlock
{
    //在这里 
    
    
    
    _testUrlStr = @"https://news-at.zhihu.com/api/4/news/latest";
    _testUrlStr = [_testUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _testUrl = [NSURL URLWithString:_testUrlStr];
    _testRequest = [NSURLRequest requestWithURL:_testUrl];
    _testSession = [NSURLSession sharedSession];
    _testDataTask = [_testSession dataTaskWithRequest:_testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ( error == nil ){
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            TotalJSONModel * model = [[TotalJSONModel alloc] initWithDictionary:dic error:nil];
            succeedBlock(model);
        }else{
            if ( error ){
                errorBlock(error);
            }
        }
    }];
    [_testDataTask resume];
}

- (void)requestDate:(NSString *)dateStr Succeed:(ZRBGetNewJSONModelHandle)succeedBlock ErrBlock:(ErrorHandle)errorBlock
{
    
        _testUrlStr = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/before/%@",[NSString stringWithFormat:@"%@",dateStr]];
        _testUrlStr = [_testUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        
        _testUrl = [NSURL URLWithString:_testUrlStr];
                        
        _testRequest = [NSURLRequest requestWithURL:_testUrl];
    
        _testSession = [NSURLSession sharedSession];
                        
        _testDataTask = [_testSession dataTaskWithRequest:_testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ( error == nil ){
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                TotalJSONModel * beforeOnecUponDataJSONModel = [[TotalJSONModel alloc] initWithDictionary:dict error:nil];
                succeedBlock(beforeOnecUponDataJSONModel);
            }else{
                if (error) {
                    errorBlock(error);
                }
            }
        }];
        [_testDataTask resume];
    
        NSLog(@"一口气四个日期  _dateMutArra.count = %li",_dateMutArray.count);
        NSLog(@"一口气四个日期  _dateMutArray = %@",_dateMutArray);
    
}

- (void)fetchDataFromNetisReferesh:(BOOL)isRefresh Succeed:(ZRBNSArrayBlock)succeedBlock error:(ErrorHandle)errorBlock{
    if ( !isRefresh ){
        [self requestNewDateSucceed:^(TotalJSONModel *mainMessageJSONModel) {
            NSArray * data = mainMessageJSONModel.stories;
            self.lateseDate = mainMessageJSONModel.date;
            succeedBlock(data);
        } error:[errorBlock copy]];
    }else{
       __block NSInteger i = 0;
        
        
        [self requestDate:[NSString stringWithFormat:@"%ld",self.lateseDate.integerValue] Succeed:^(TotalJSONModel *mainMessageJSONModel) {
            [self.lock lock];
            [self.dataMutArray addObject:mainMessageJSONModel];
            i++;
            if ( i == 5 ){
                [self dadadad:[succeedBlock copy]];
            }
            [self.lock unlock];
        } ErrBlock:[errorBlock copy]];
        
        
            [self requestDate:[NSString stringWithFormat:@"%ld",self.lateseDate.integerValue - 1] Succeed:^(TotalJSONModel *mainMessageJSONModel) {
                [self.lock lock];
                [self.dataMutArray addObject:mainMessageJSONModel];
                i++;
                if ( i == 5 ){
                    [self dadadad:[succeedBlock copy]];
                }
                [self.lock unlock];
            } ErrBlock:[errorBlock copy]];
        
        
            [self requestDate:[NSString stringWithFormat:@"%ld",self.lateseDate.integerValue - 2] Succeed:^(TotalJSONModel *mainMessageJSONModel) {
                [self.lock lock];
                [self.dataMutArray addObject:mainMessageJSONModel];
                i++;
                if ( i == 5 ){
                    [self dadadad:[succeedBlock copy]];
                }
                [self.lock unlock];
            } ErrBlock:[errorBlock copy]];
   
        
            [self requestDate:[NSString stringWithFormat:@"%ld",self.lateseDate.integerValue - 3] Succeed:^(TotalJSONModel *mainMessageJSONModel) {
                [self.lock lock];
                [self.dataMutArray addObject:mainMessageJSONModel];
                i++;
                if ( i == 5 ){
                    [self dadadad:[succeedBlock copy]];
                }
                [self.lock unlock];
            } ErrBlock:[errorBlock copy]];
  
            [self requestDate:[NSString stringWithFormat:@"%ld",self.lateseDate.integerValue - 4] Succeed:^(TotalJSONModel *mainMessageJSONModel) {
                [self.lock lock];
                [self.dataMutArray addObject:mainMessageJSONModel];
                i++;
                if ( i == 5 ){
                    [self dadadad:[succeedBlock copy]];
                }
                [self.lock unlock];
            } ErrBlock:[errorBlock copy]];
        
    }
}

- (void)dadadad:(ZRBNSArrayBlock)block{
    //在这里进行数据整理排序
    
    
    
    
    
    NSLog(@"_dataMutArray = %@",_dataMutArray);
    
}

@end
