//
//  AddVehicleViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "AddInsuranceViewController.h"

@interface AddInsuranceViewController ()

@end

@implementation AddInsuranceViewController{
    
}

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
    CGRect firstPos   = CGRectMake(10, 50,  290, 35);
    CGRect secondPos  = CGRectMake(10, 95,  290, 35);
    CGRect thirdPos   = CGRectMake(10, 140, 290, 35);
    CGRect fourthPos  = CGRectMake(10, 185, 290, 35);
    CGRect fifthPos   = CGRectMake(10, 230, 290, 35);
    CGRect sixthPos   = CGRectMake(10, 275, 290, 35);
    CGRect seventhPos = CGRectMake(10, 320, 290, 35);
    
    _insuranceField   = [self makeTexfieldWithCGRect:firstPos   withPlaceholder:@"Insurance Company"              usesNumbers: NO];
    _addressField     = [self makeTexfieldWithCGRect:secondPos  withPlaceholder:@"Insurance Company's Address"    usesNumbers: NO];
    _phoneField       = [self makeTexfieldWithCGRect:thirdPos   withPlaceholder:@"Company's Office Phone Number"  usesNumbers: NO];
    _agentField       = [self makeTexfieldWithCGRect:fourthPos  withPlaceholder:@"Insurance Agent"                usesNumbers: NO];
    _agentNumberField = [self makeTexfieldWithCGRect:fifthPos   withPlaceholder:@"Agent's Phone Number"           usesNumbers: NO];
    _policyField      = [self makeTexfieldWithCGRect:sixthPos   withPlaceholder:@"Insurance Policy Number"        usesNumbers: NO];
    _typeField        = [self makeTexfieldWithCGRect:seventhPos withPlaceholder:@"Insurance for . . ." usesNumbers: NO];
}

-(UITextField*)makeTexfieldWithCGRect:(CGRect)cgrect withPlaceholder:(NSString*)placeholder usesNumbers:(BOOL)numberKeyboard
{
    UITextField* textField = [[UITextField alloc] initWithFrame:cgrect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    if(numberKeyboard)
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:textField];
    return textField;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [_delegate addInsuranceViewControllerDidCancel:_currentInsurance];
}

- (IBAction)save:(id)sender {
    _currentInsurance.address = _addressField.text;
    _currentInsurance.agent = _agentField.text;
    _currentInsurance.agentNum = _agentNumberField.text;
    _currentInsurance.company = _insuranceField.text;
    _currentInsurance.phone = _phoneField.text;
    _currentInsurance.policyNum = _policyField.text;
    _currentInsurance.type = _typeField.text;
    [_delegate addInsuranceViewControllerDidSave:_currentInsurance];
}


#pragma mark - Text Field Delegate Functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.frame.origin.y > ( self.view.frame.size.height - 200 - 71 ) ){
        [self animateTextField:textField up:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.frame.origin.y > ( self.view.frame.size.height - 200 - 71 ) ){
        [self animateTextField:textField up:NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y - ( 200 - 45 ); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
