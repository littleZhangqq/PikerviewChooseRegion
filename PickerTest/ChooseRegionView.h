//
//  ChooseRegionView.h
//  NewXDYClient
//
//  Created by zhangqq on 2018/3/14.
//  Copyright © 2018年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseRegionView : UIView

@property (nonatomic, copy) void(^chooseBlock)(NSString *region);

-(void)show;
-(void)hidden;

@end
