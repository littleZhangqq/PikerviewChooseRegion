//
//  ViewController.m
//  PickerTest
//
//  Created by zhangqq on 2018/3/17.
//  Copyright © 2018年 张强. All rights reserved.
//

#import "ViewController.h"
#import "ChooseRegionView.h"

@interface ViewController ()

@property(nonatomic, strong) ChooseRegionView *chooseView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:0];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"弹出" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(CGSizeMake(100, 50));
    }];
}

-(ChooseRegionView *)chooseView{
    if (!_chooseView) {
        _chooseView = [[ChooseRegionView alloc] init];
        [self.view addSubview:_chooseView];
        
        [_chooseView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _chooseView;
}

-(void)btnClick{
    [self.chooseView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
