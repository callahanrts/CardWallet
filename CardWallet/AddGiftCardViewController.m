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

@implementation AddGiftCardViewController{
    UIPickerView *picker;
    NSMutableArray *retailers;
    NSMutableArray *icons;
    UIToolbar *toolbar;
}
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
    //x y width height
    CGRect firstPos   = CGRectMake(20, 105, 280, 35);
    CGRect secondPos  = CGRectMake(20, 150, 280, 35);
    CGRect thirdPos   = CGRectMake(20, 195, 280, 35);
    CGRect fourthPos  = CGRectMake(20, 240, 280, 35);
    CGRect fifthPos   = CGRectMake(20, 285, 280, 35);
    //height is standard
    CGRect pickerRect = CGRectMake(0, 244 + 250, 320, 250);
    CGRect toolbarRect = CGRectMake(0, 244 + 250, 320, 35);
    
    _storeName     = [self makeTexfieldWithCGRect:firstPos  withPlaceholder:@"Store Name"];
    _name          = [self makeTexfieldWithCGRect:secondPos withPlaceholder:@"Gift Card Name"];
    _accountNumber = [self makeTexfieldWithCGRect:thirdPos  withPlaceholder:@"Account Number"];
    _pinNumber     = [self makeTexfieldWithCGRect:fourthPos withPlaceholder:@"Pin Number"];
    _barCode       = [self makeTexfieldWithCGRect:fifthPos  withPlaceholder:@"Bar Code"];
    if(fromInStore){
        _storeName.text = self.currentGiftCard.store.name;
        [_storeName setEnabled:NO];
        [_storeName setAlpha:0.6];
    }
    //ui toolbar on top of picker
    toolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
  
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(slidePickerDown)];
    NSMutableArray *buttons = [NSMutableArray arrayWithObjects: doneBtn, nil];
    [toolbar setItems:buttons animated:YES];
    toolbar.tintColor = [UIColor blackColor];
    
    [self.view addSubview:toolbar];
    
    //picker view
    [self initializeSupportedRetailers];
    picker = [[UIPickerView alloc] initWithFrame:pickerRect];
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    
    //initialize zbar reader
    [self initZBarReader];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(initialLoad){
        [self scan];
        initialLoad = NO;
    }
}
#pragma mark - Picker View Delegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    _storeName.text = [retailers objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [retailers count];
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [retailers objectAtIndex:row];
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
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
        [self slidePickerUp];
        [_storeName setEnabled:NO];
    }
    else {
        [self slidePickerDown];
        [_storeName setEnabled:YES];
        [self animateTextField: textField up: YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField != _storeName)
        [self animateTextField: textField up: NO];
    [_storeName setEnabled:YES];
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

-(void)slidePickerDown{
    CGPoint toolbarOrigin = toolbar.frame.origin, pickerOrigin = picker.frame.origin;
    CGSize  toolbarSize   = toolbar.frame.size,   pickerSize   = picker.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(pickerOrigin.x, pickerOrigin.y + pickerSize.height, pickerSize.width, pickerSize.height);
        toolbar.frame = CGRectMake(toolbarOrigin.x, toolbarOrigin.y + pickerSize.height + toolbarSize.height, toolbarSize.width, toolbarSize.height);
    }];
    [_storeName setEnabled:YES];
}
-(void)slidePickerUp{
    CGPoint toolbarOrigin = toolbar.frame.origin, pickerOrigin = picker.frame.origin;
    CGSize  toolbarSize   = toolbar.frame.size,   pickerSize   = picker.frame.size;
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(pickerOrigin.x, pickerOrigin.y - pickerSize.height, pickerSize.width, pickerSize.height);
        toolbar.frame = CGRectMake(toolbarOrigin.x, toolbarOrigin.y - pickerSize.height - toolbarSize.height, toolbarSize.width, toolbarSize.height);
    }];
    [_storeName setEnabled:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 90; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

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
        NSUInteger index = [retailers indexOfObject:_storeName.text];
        if(!self.currentGiftCard.store.name){
            self.currentGiftCard.store.name = _storeName.text;
            self.currentGiftCard.store.image = [icons objectAtIndex:index];
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

#pragma mark - Array of Supported Retailers

- (void)initializeSupportedRetailers{
    retailers = [[NSMutableArray alloc]initWithObjects:
                 @"711",
                 @"acehardware",
                 @"amazon",
                 @"applestore",
                 @"autozone",
                 @"barnes&noble",
                 @"bedbathandbeyond",
                 @"bestbuy",
                 @"costco",
                 @"cvs",
                 @"dillards",
                 @"familydollar",
                 @"gamestop",
                 @"gap",
                 @"homedepot",
                 @"itunes",
                 @"jcpenny",
                 @"kohls",
                 @"kroger",
                 @"lowes", 
                 @"macys", 
                 @"nordstrom", 
                 @"officedepot", 
                 @"officemax", 
                 @"oreilly", 
                 @"publix", 
                 @"riteaid", 
                 @"ross", 
                 @"safeway", 
                 @"sears", 
                 @"staples", 
                 @"starbucks", 
                 @"subway", 
                 @"target", 
                 @"tjmax", 
                 @"toysrus", 
                 @"traderjoes", 
                 @"truevalue", 
                 @"walgreens", 
                 @"walmart", 
                 @"wholefoods",  nil];
    icons = [[NSMutableArray alloc] initWithObjects:
             @"711.png",
             @"acehardware.png",
             @"amazon.png",
             @"applestore.png",
             @"autozone.png",
             @"barnes&noble.png",
             @"bedbathandbeyond.png",
             @"bestbuy.png",
             @"costco.png",
             @"cvs.png",
             @"dillards.png",
             @"familydollar.png",
             @"gamestop.png",
             @"gap.png",
             @"homedepot.png",
             @"itunes.png",
             @"jcpenny.png",
             @"kohls.png",
             @"kroger.png",
             @"lowes.png",
             @"macys.png",
             @"nordstrom.png",
             @"officedepot.png",
             @"officemax.png",
             @"oreilly.png",
             @"publix.png",
             @"riteaid.png",
             @"ross.png",
             @"safeway.png",
             @"sears.png",
             @"staples.png",
             @"starbucks.png",
             @"subway.png",
             @"target.png",
             @"tjmax.png",
             @"toysrus.png",
             @"traderjoes.png",
             @"truevalue.png",
             @"walgreens.png",
             @"walmart.png",
             @"wholefoods.png", nil];
    [retailers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [icons sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [retailers addObject:@"Other"];
    [icons addObject:@"other.png"];
}
@end














