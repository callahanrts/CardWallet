
//
//  DisplayInsuranceViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/25/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "DisplayInsuranceViewController.h"

@interface DisplayInsuranceViewController ()

@end

@implementation DisplayInsuranceViewController

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
    
    _insuranceView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    _policyView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    
    //_typeLbl.text           = _currentInsurance.type;
    _companyLbl.text        = _currentInsurance.company;
    _companyAddressLbl.text = _currentInsurance.address;
    _companyPhoneLbl.text   = _currentInsurance.phone;
    _agentLbl.text          = _currentInsurance.agent;
    _agentNumberLbl.text    = _currentInsurance.agentNum;
    _policyNumberLbl.text   = _currentInsurance.policyNum;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
