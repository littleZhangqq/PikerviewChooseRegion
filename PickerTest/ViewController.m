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
@property(nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _button = [UIButton buttonWithType:0];
    _button.backgroundColor = [UIColor purpleColor];
    [_button setTitle:@"弹出" forState:0];
    [_button setTitleColor:[UIColor blackColor] forState:0];
    _button.titleLabel.font = [UIFont systemFontOfSize:10];
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    [_button makeConstraints:^(MASConstraintMaker *make) {
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
        
        __weak  typeof(self) weakSelf = self;
        _chooseView.chooseBlock = ^(NSString *region) {
            [weakSelf.button setTitle:region forState:0];
        };
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
