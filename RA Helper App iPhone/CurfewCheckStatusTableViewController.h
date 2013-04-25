//
//  CurfewCheckStatusTableViewController.h
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/20/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Resident+Create.h"
#import "CurfewCheck+Create.h"
#import "Status+Status_Create.h"

@interface CurfewCheckStatusTableViewController : CoreDataTableViewController
@property (nonatomic, weak) CurfewCheck * curfewCheck;
@property (nonatomic, strong) UIManagedDocument *statusDatabase;

@end
