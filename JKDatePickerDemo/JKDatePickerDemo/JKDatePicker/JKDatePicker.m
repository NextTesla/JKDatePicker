//
//  JKDatePicker.m
//  LawyerCard_iPhone
//
//  Created by bitzsoft_mac on 16/7/19.
//  Copyright © 2016年 JKing. All rights reserved.
//

#define kPickerViewHeight 216
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "JKDatePicker.h"

@interface JKDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, weak)UIView *contentView;
@property(nonatomic, weak)UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, copy) NSString *selectedDateString;
@property (nonatomic, assign) BOOL showSofar;
@end

@implementation JKDatePicker

+ (instancetype)picker
{
    return [[self alloc] init];
    
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 初始化设置
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    // contentView
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kPickerViewHeight+44)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = 60;
    CGFloat btnH = 44;
    
    // 取消按钮
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 确认按钮
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-btnW, 0, btnW, btnH)];
    [confirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:RGB(130, 201, 47) forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [contentView addSubview:cancel];
    [contentView addSubview:confirm];
    
    [self addSubview:contentView];
    self.contentView = contentView;
    
    // 选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenW, kPickerViewHeight)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [contentView addSubview:pickerView];
    self.pickerView = pickerView;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger nowMonth = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    [pickerView selectRow:[self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld",nowYear]] inComponent:0 animated:YES];
    [pickerView selectRow:[self.monthArray indexOfObject:[NSString stringWithFormat:@"%ld",nowMonth]] inComponent:1 animated:YES];
    _selectedDateString = [NSString stringWithFormat:@"%ld-%ld", nowYear, nowMonth];
}

#pragma mark - <ClickAction>

/**
 * 确认选择
 */
- (void)confirmClick
{
    NSString *dateStr = _selectedDateString;
    if (![_selectedDateString isEqualToString:@"至今"]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSDate *date = [formatter dateFromString:_selectedDateString];
        dateStr = [formatter stringFromDate:date];
    }
    
    self.resultBlock(dateStr);
    
    [self dismiss];
}

/**
 * show方法
 */
- (void)showWithSofar:(BOOL)sofar resultBlock:(JKDatePickerResult)resultBlock
{
    self.showSofar = sofar;
    if (sofar) {
        if (![self.yearArray containsObject:@"至今"]) {
            [self.yearArray addObject:@"至今"];
        }
    } else {
        if ([self.yearArray containsObject:@"至今"]) {
            [self.yearArray removeObject:@"至今"];
        }
    }

    [self.pickerView reloadAllComponents];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = self.contentView.frame;
        rect.origin.y = kScreenH - (kPickerViewHeight+44);
        self.contentView.frame = rect;
        self.resultBlock = resultBlock;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

/**
 * 消失
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        CGRect rect = self.contentView.frame;
        rect.origin.y = kScreenH;
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - <UIPickerViewDataSource>

/**
 *  列数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

/**
 *  行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {
        return self.yearArray.count;
    } else {
        NSInteger row = [pickerView selectedRowInComponent:0];
        if ([self.yearArray[row] isEqualToString:@"至今"]) {
            return 0;
        } else {
            return self.monthArray.count;
        }
    }
}

/**
 *  标题
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        return self.yearArray[row];
    }
    
    if (self.showSofar && (row == self.yearArray.count)) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@月", self.monthArray[row]];
}

/**
 *  行宽
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 120;
}

#pragma mark - <UIPickerViewDelegate>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component) {
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
    }
    NSInteger yearIndex = [pickerView selectedRowInComponent:0];
    NSInteger monthIndex = [pickerView selectedRowInComponent:1];
    NSString *yearStr = self.yearArray[yearIndex];
    NSMutableString *monthStr = [NSMutableString stringWithString:self.monthArray[monthIndex]];
    if ([yearStr isEqualToString:@"至今"]) {
        _selectedDateString = yearStr;
    } else {
        _selectedDateString = [NSString stringWithFormat:@"%@-%@", yearStr, monthStr];
    }
}

#pragma mark - <LazyMethod>

- (NSMutableArray *)yearArray
{
    if (!_yearArray) {
        // 获取当前年
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
        _yearArray = [NSMutableArray array];
        
        for (NSInteger i = 1950; i<=nowYear; i ++) {
            [_yearArray addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }
    return _yearArray;
}

- (NSArray *)monthArray
{
    return @[@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
}

@end
