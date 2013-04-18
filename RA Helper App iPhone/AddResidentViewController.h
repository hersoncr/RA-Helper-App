//
//  AddResidentViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
@interface AddResidentViewController : CoreDataTableViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property UIPickerView * pickerView;
@property NSArray * pickerViewDataSource;
@end
