//
//  DisplayVehicleViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/19/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "DisplayVehicleViewController.h"

@interface DisplayVehicleViewController ()

@end

@implementation DisplayVehicleViewController

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    
    _vehicleView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    _vinView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    
    _makeLbl.text  = _currentVehicle.make;
    _modelLbl.text = _currentVehicle.model;
    _yearLbl.text  = _currentVehicle.year;
    _vinLbl.text   = _currentVehicle.vinNum;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
