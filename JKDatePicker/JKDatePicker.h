//
//  JKDatePicker.h
//  LawyerCard_iPhone
//
//  Created by bitzsoft_mac on 16/7/19.
//  Copyright © 2016年 JKing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JKDatePickerResult)(NSString *resultString);

@interface JKDatePicker : UIView

@property (nonatomic, copy) JKDatePickerResult resultBlock;

+ (instancetype)picker;

- (void)showWithSofar:(BOOL)sofar resultBlock:(JKDatePickerResult)resultBlock;

@end
