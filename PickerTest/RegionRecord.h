//
//  RegionModel.h
//  NewXDYClient
//
//  Created by zhangqq on 2018/3/14.
//  Copyright © 2018年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityRecord :NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *sub;
@property (nonatomic, strong) NSString *zipcode;

@end

@interface RegionRecord : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *sub;

@end
