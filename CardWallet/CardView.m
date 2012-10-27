//
//  CardView.m
//  CardWallet
//
//  Created by Cody Callahan on 10/25/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "CardView.h"

@interface CardView ()

@end

@implementation CardView

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
    [super navigationController].title = @"Gift Cards";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
