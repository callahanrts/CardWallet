//
//  StoreCollection.m
//  CardWallet
//
//  Created by Cody Callahan on 10/25/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "StoreCollection.h"

@interface StoreCollection ()

@end

@implementation StoreCollection

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
/*
- (IBAction)toCardsView:(id)sender {
    CardView *cardView= [self.storyboard instantiateViewControllerWithIdentifier:@"CardView"];
    [[self navigationController ] pushViewController:cardView animated:YES];
}*/


@end
