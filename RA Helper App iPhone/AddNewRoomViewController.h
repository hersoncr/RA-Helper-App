//
//  AddNewRoomViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewRoomViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewOutlet;
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *wingsPickerViewOutlet;
@property (nonatomic, strong) UIManagedDocument *roomsDatabase;
@property NSArray * wingsArray;
@end
