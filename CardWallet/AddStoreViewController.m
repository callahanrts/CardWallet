//
//  AddStoreViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/5/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "AddStoreViewController.h"

@interface AddStoreViewController ()

@end

@implementation AddStoreViewController
@synthesize  nameField;

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
    nameField.text = self.currentStore.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate addStoreViewControllerDidCancel:self.currentStore];
}

- (IBAction)save:(id)sender {
    self.currentStore.name = nameField.text;
    self.currentStore.image = @"costcoIcon.png";
    [self.delegate addStoreViewControllerDidSave];
}
@end
