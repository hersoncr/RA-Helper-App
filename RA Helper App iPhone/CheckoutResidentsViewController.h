//
//  CheckoutResidentsViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/13/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutResidentsViewController : UITableViewController
@property NSArray * residents;
@property (nonatomic, strong) UIManagedDocument *statusDatabase;
+ (NSArray *) getStatus ;
@end

