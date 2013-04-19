//
//  AddNewWingViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewWingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *wingNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dormNameTextField;
@property (nonatomic, strong) UIManagedDocument *wingsDatabase;
@end
