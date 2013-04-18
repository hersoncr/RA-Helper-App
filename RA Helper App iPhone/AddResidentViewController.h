//
//  AddResidentViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
@interface AddResidentViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameOutlet;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewOutlet;
@property (weak, nonatomic) IBOutlet UITextField *lastNameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *phoneOutlet;
@property (weak, nonatomic) IBOutlet UITextField *studentIDOutlet;
@property NSArray * pickerViewDataSource;
@end
