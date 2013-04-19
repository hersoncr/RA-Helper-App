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
@synthesize scrollViewOutlet = _scrollViewOutlet;
@synthesize pickerViewOutlet = _pickerViewOutlet;
@synthesize pickerViewDataSource = _pickerViewDataSource;
@synthesize firstNameOutlet = _firstNameOutlet;
@synthesize lastNameOutlet = _lastNameOutlet;
@synthesize phoneOutlet = _phoneOutlet;
@synthesize studentIDOutlet = _studentIDOutlet;

- (void) setUp
{
    _pickerViewDataSource = [[NSArray alloc] initWithObjects:@"218",@"217",@"216",@"318", nil];
    _pickerViewOutlet.dataSource = self;
    _pickerViewOutlet.delegate = self;
    UIView * subView = [self.scrollViewOutlet.subviews objectAtIndex:0];
    self.scrollViewOutlet.contentSize = CGSizeMake(subView.bounds.size.width, subView.bounds.size.height);
    NSLog(@"height = %g, width = %g ",subView.bounds.size.height, subView.bounds.size.width);
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
	// Do any additional setup after loading the view.
}
- (IBAction)addNewResidentAction:(id)sender {
    int selectedIndex = [self.pickerViewOutlet selectedRowInComponent:0];
    NSString *message = [NSString stringWithFormat:@"You selected: %@",[self.pickerViewDataSource objectAtIndex:selectedIndex]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
    [alert show];
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
