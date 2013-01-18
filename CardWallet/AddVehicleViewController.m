//
//  AddVehicleViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "AddVehicleViewController.h"

@interface AddVehicleViewController ()

@end

@implementation AddVehicleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
}
@end
