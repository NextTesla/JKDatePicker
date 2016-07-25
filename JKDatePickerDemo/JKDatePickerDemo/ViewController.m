//
//  ViewController.m
//  JKDatePickerDemo
//
//  Created by bitzsoft_mac on 16/7/25.
//  Copyright © 2016年 JKing. All rights reserved.
//

#import "ViewController.h"
#import "JKDatePicker.h"

@interface ViewController ()
@property (nonatomic, strong) JKDatePicker *datePicker;
@end

@implementation ViewController

- (JKDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [JKDatePicker picker];
    }
    return _datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(UIButton *)sender {
    [self.datePicker showWithSofar:YES resultBlock:^(NSString *resultString) {
        [sender setTitle:resultString forState:UIControlStateNormal];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
