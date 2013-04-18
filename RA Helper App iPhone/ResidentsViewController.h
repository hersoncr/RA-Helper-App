//
//  ResidentsViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/17/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//


#import "CoreDataTableViewController.h"

@interface ResidentsViewController : CoreDataTableViewController
@property NSArray * residents;
@property (nonatomic, strong) UIManagedDocument *residentsDatabase;

@end
