//
//  AddGiftCardViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/9/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "AddGiftCardViewController.h"

@interface AddGiftCardViewController ()

@end

@implementation AddGiftCardViewController
@synthesize reader;
@synthesize initialLoad;
@synthesize fromInStore;
BOOL stayup;

#pragma mark - Generated Functions

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
    
    CGRect firstPos  = CGRectMake(20, 105, 280, 35);
    CGRect secondPos = CGRectMake(20, 150, 280, 35);
    CGRect thirdPos  = CGRectMake(20, 195, 280, 35);
    CGRect fourthPos = CGRectMake(20, 240, 280, 35);
    CGRect fifthPos  = CGRectMake(20, 285, 280, 35);
    
    _storeName     = [self makeTexfieldWithCGRect:firstPos  withPlaceholder:@"Store Name"];
    _name          = [self makeTexfieldWithCGRect:secondPos withPlaceholder:@"Gift Card Name"];
    _accountNumber = [self makeTexfieldWithCGRect:thirdPos  withPlaceholder:@"Account Number"];
    _pinNumber     = [self makeTexfieldWithCGRect:fourthPos withPlaceholder:@"Pin Number"];
    _barCode       = [self makeTexfieldWithCGRect:fifthPos  withPlaceholder:@"Bar Code"];
    if(fromInStore){
        _storeName.text = self.currentGiftCard.store.name;
        [_storeName setEnabled:NO];
        [_storeName setAlpha:0.6];
        //UIColor *color = [UIColor grayColor];
        //[_storeName setTextColor:color];
    }
    
    [self initZBarReader];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(initialLoad){
        [self scan];
        initialLoad = NO;
    }
}

#pragma mark - Text Field Delegate Functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _storeName){
        //[_storeName setEnabled:NO];
        //[_storeName setAlpha:.7];
        //[_storePicker setHidden:NO];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([_storeName.text length] > 0 && [_name.text length] > 0 && [_accountNumber.text length] > 0
       && [_pinNumber.text length] > 0 && [_barCode.text length] > 0)
    {
        [_saveBtn setEnabled:YES];
        return YES;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Functions

- (void)initZBarReader
{
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    reader.readerView.zoom = 1.0;
}

-(UITextField*)makeTexfieldWithCGRect:(CGRect)cgrect withPlaceholder:(NSString*)placeholder
{
    UITextField* textField = [[UITextField alloc] initWithFrame:cgrect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    return textField;
}



#pragma mark - IBActions

- (IBAction)scanAgain:(id)sender {
    [self scan];
}

- (IBAction)cancel:(id)sender {
    [self.delegate AddGiftCardViewControllerDidCancel:self.currentGiftCard];
}

- (IBAction)save:(id)sender {
    if([_storeName.text length] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Name?" message:@"Don't forget to assign your gift card to a store!" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(!self.currentGiftCard.store.name){
            self.currentGiftCard.store.name = _storeName.text;
            self.currentGiftCard.store.image = @"kohls.png";
        }
        self.currentGiftCard.name = _name.text;
        self.currentGiftCard.accountNumber = _accountNumber.text;
        self.currentGiftCard.pin = _pinNumber.text;
        self.currentGiftCard.barCode = _barCode.text;
        [self.delegate AddGiftCardViewControllerDidSave];
    }
}



#pragma mark - ZBar Functions

- (void)scan {
    reader.readerView.showsFPS = YES;
    reader.readerView.zoom = 1.0;
    reader.supportedOrientationsMask = (reader.showsZBarControls)
    ? ZBarOrientationMaskAll
    : ZBarOrientationMask(UIInterfaceOrientationPortrait); // tmp disable
    
    [self presentViewController:reader animated:YES completion:nil];
}


- (void) imagePickerController: (UIImagePickerController*) localReader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    assert(results);
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    assert(image);
    
    //if(image)
    //    imageView.image = image;
    
    int quality = 0;
    ZBarSymbol *bestResult = nil;
    for(ZBarSymbol *sym in results) {
        int q = sym.quality;
        if(quality < q) {
            quality = q;
            bestResult = sym;
        }
    }
    
    [self performSelector: @selector(presentResult:)
               withObject: bestResult
               afterDelay: .001];
    
    [localReader dismissViewControllerAnimated:YES completion:nil];
}


- (void) presentResult: (ZBarSymbol*) sym
{
    NSString *typeName = @"";
    NSString *data = @"";
    if(sym) {
        typeName = sym.typeName;
        data = sym.data;
    }
    _barCode.text = typeName;
    _accountNumber.text = data;
    if(typeName){
        [_barCode setEnabled:NO];
        [_barCode setOpaque:0.7];
    }
    if(data){
        [_accountNumber setEnabled:NO];
        [_accountNumber setOpaque:0.7];
    }
}
@end
