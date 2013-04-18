//
//  AddResidentViewController.m
//  RA Helper App iPhone
//
//  Created by Herson Alfaro on 4/18/13.
//  Copyright (c) 2013 Harding University CS. All rights reserved.
//

#import "AddResidentViewController.h"

@interface AddResidentViewController ()

@end

@implementation AddResidentViewController
@synthesize pickerViewOutlet = _pickerViewOutlet;
@synthesize pickerViewDataSource = _pickerViewDataSource;
@synthesize firstNameOutlet = _firstNameOutlet;
@synthesize lastNameOutlet = _lastNameOutlet;
@synthesize phoneOutlet = _phoneOutlet;
@synthesize studentIDOutlet = _studentIDOutlet;

- (void) setUp
{
    _pickerViewDataSource = [[NSArray alloc] initWithObjects:@"218",@"217",@"216", nil];
    _pickerViewOutlet.dataSource = self;
    _pickerViewOutlet.delegate = self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUp];
    }
    return self;
}
- (IBAction)addNewResidentAction {
    int selectedIndex = [self.pickerViewOutlet selectedRowInComponent:0];
    NSString *message = [NSString stringWithFormat:@"You selected: %@",[self.pickerViewDataSource objectAtIndex:selectedIndex]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
    
}
- (IBAction)cancelAddingNewResidentAction {
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewDataSource objectAtIndex:row];
}
@end
