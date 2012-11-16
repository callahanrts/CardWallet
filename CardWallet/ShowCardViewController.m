//
//  ShowCardViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/12/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "ShowCardViewController.h"

@interface ShowCardViewController ()

@end

@implementation ShowCardViewController

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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
    //top left bottom right
    //[self.view setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
