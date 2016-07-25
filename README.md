# JKDatePicker
A simple pickerView just like the app lagou.

![image](https://github.com/JKingX/JKDatePicker/blob/master/demo.gif)

# usage
## Copy the JKDatePicker folder to your project

  [self.datePicker showWithSofar:YES resultBlock:^(NSString *resultString) {
       [sender setTitle:resultString forState:UIControlStateNormal];
   }];
