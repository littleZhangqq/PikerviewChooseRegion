//
//  ChooseRegionView.m
//  NewXDYClient
//
//  Created by zhangqq on 2018/3/14.
//  Copyright © 2018年 张强. All rights reserved.
//

#import "ChooseRegionView.h"
#import "RegionRecord.h"

#define W(x) (SCREEN_WIDTH*(x))/375.0
#define H(y) (SCREEN_HEIGHT*(y))/667.0
#define COLOR(Costom)         ([UIColor Costom])
#define ColorRGB(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define ColorRGBA(R,G,B,A)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
// 获取屏幕宽度
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
// 获取屏幕高度
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

@interface ChooseRegionView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, unsafe_unretained) NSInteger selectProvinceIndex;
@property (nonatomic, unsafe_unretained) NSInteger selectCityIndex;
@property (nonatomic, unsafe_unretained) NSInteger selectRegionIndex;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *region;
@end

@implementation ChooseRegionView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.selectRegionIndex = 0;
        self.selectCityIndex = 0;
        self.selectProvinceIndex = 00;
        [self createMainView];
    }
    return self;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path1];
        NSArray *arr = [NSMutableArray arrayWithArray:dic[@"address"]];
        _dataArray = [RegionRecord mj_objectArrayWithKeyValuesArray:arr];
        
        for (NSInteger i = 3; i<_dataArray.count; i++) {
            RegionRecord *record = _dataArray[i];
            NSDictionary *dic = arr[i];
            for (NSInteger j = 0;j<record.sub.count ; j++) {
                NSDictionary *cityinfo = dic[@"sub"][j];
                CityRecord *crecord = record.sub[j];
                crecord.sub = [NSMutableArray arrayWithArray:cityinfo[@"sub"]];
            }
        }
    }
    return _dataArray;
}

-(void)createMainView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR(whiteColor);
    [self addSubview:bottomView];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(H(265));
    }];
    
    UIView *chooseView = [[UIView alloc] init];
    chooseView.backgroundColor = ColorRGB(245, 245, 245);
    [bottomView addSubview:chooseView];
    
    [chooseView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bottomView);
        make.height.equalTo(H(50));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorRGB(245, 245, 245);
    [bottomView addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(chooseView);
        make.height.equalTo(H(0.8));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"请选择";
    title.textColor = ColorRGB(180, 180, 180);
    [chooseView addSubview:title];
    
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView);
        make.left.equalTo(chooseView.left).offset(W(15));
    }];
    
    UIButton *consure = [UIButton buttonWithType:0];
    [consure setTitle:@"确定" forState:0];
    [consure setTitleColor:COLOR(whiteColor) forState:0];
    consure.backgroundColor = ColorRGB(0, 136, 255);
    consure.titleLabel.font = title.font = [UIFont systemFontOfSize:14];;
    consure.layer.cornerRadius = 3;
    consure.layer.masksToBounds = YES;
    [consure addTarget:self action:@selector(consureClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:consure];
    
    [consure makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView);
        make.right.equalTo(chooseView.right).offset(-W(15));
        make.size.equalTo(CGSizeMake(W(60), H(30)));
    }];
    
    _picker = [[UIPickerView alloc] init];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    [bottomView addSubview:_picker];
    
    [_picker makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.top.equalTo(line.bottom);
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dataArray.count;
    }else if (component == 1){
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        return record.sub.count;
    }else{
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        // 这个判断很重要，快速滑动左右时候，右边切换的速度快，左边慢，就会导致右边的selectindex可能很大，而左边切换的目标里面的城市数组如果数量小，就会使用selectindex造成数组越界，这里要判断一下， 直接让他归零就好使了。比如选择黑龙江，右边的城市滑动的时候，左边滑动到了上海，这时候右边滑动还没结束，左边开始重新刷piker了，上海的市的数量不够右边的index来调用刷新就会崩溃
        if (self.selectCityIndex >= record.sub.count) {
            self.selectCityIndex = 0;
        }
        CityRecord *crecord = record.sub[self.selectCityIndex];
        return crecord.sub.count;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pikerLabel = (UILabel *)view;
    if (!pikerLabel){
        pikerLabel = [[UILabel alloc] init];
        pikerLabel.adjustsFontSizeToFitWidth = YES;
        [pikerLabel setTextAlignment:NSTextAlignmentCenter];
        [pikerLabel setBackgroundColor:[UIColor clearColor]];
        pikerLabel.font = [UIFont systemFontOfSize:15];
    }
    pikerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pikerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        RegionRecord *record = self.dataArray[row];
        return record.name;
    }else if (component == 1){
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        CityRecord *crecord = record.sub[row];
        return crecord.name;
    }else{
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        CityRecord *crecord = record.sub[self.selectCityIndex];
        return crecord.sub[row];
    }
    return @"";
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH/3;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return H(40);
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectProvinceIndex = row;
    }else if (component == 1){
        self.selectCityIndex = row;
    }else{
        self.selectRegionIndex = row;
    }
    [pickerView reloadAllComponents];
    NSString *p = nil;
    NSString *c = nil;
    NSString *n = nil;
    if (component == 0) {
        RegionRecord *record = self.dataArray[row];
        _province = record.name;
    }else if (component == 1){
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        CityRecord *crecord = record.sub[row];
        _city = crecord.name;
    }else{
        RegionRecord *record = self.dataArray[self.selectProvinceIndex];
        CityRecord *crecord = record.sub[self.selectCityIndex];
        _region = crecord.sub[row];
    }
}

-(void)consureClick{
    [self hidden];
    NSLog(@"选择地址是%@-%@-%@",_province,_city,_region);
    if (self.chooseBlock) {
        self.chooseBlock([NSString stringWithFormat:@"%@-%@-%@",_province,_city,_region]);
    }
}

-(void)show{
    self.hidden = NO;
}

-(void)hidden{
    self.hidden = YES;
}
@end
