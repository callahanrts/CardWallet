//
//  AddInsuranceViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/22/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insurance.h"

@protocol AddInsuranceViewControllerDelegate;
@interface AddInsuranceViewController : UIViewController
<UITextFieldDelegate>

@property (nonatomic, weak) id <AddInsuranceViewControllerDelegate> delegate;

@property (strong, nonatomic) Insurance *currentInsurance;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UITextField *insuranceField;
@property (strong, nonatomic) IBOutlet UITextField *agentField;
@property (strong, nonatomic) IBOutlet UITextField *agentNumberField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *policyField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end


@protocol AddInsuranceViewControllerDelegate

-(void)addInsuranceViewControllerDidSave:(Insurance*)currentInsurance;
-(void)addInsuranceViewControllerDidCancel:(Insurance*)insuranceToDelete;

@end