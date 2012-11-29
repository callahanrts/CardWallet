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
    CGRect fourthPos  = CGRectMake(20, 240, 130, 35);
    CGRect fifthPos   = CGRectMake(170, 240, 130, 35);
    //CGRect sixthPos   = CGRectMake(20, 8, 280, 35);
    //height is standard
    CGRect pickerRect = CGRectMake(0, 480, 320, 236);
    CGRect toolbarRect = CGRectMake(0, 480, 320, 35);
    
    _storeName     = [self makeTexfieldWithCGRect:firstPos  withPlaceholder:@"Store Name" usesNumbers: NO];
    _name          = [self makeTexfieldWithCGRect:secondPos withPlaceholder:@"Gift Card Name" usesNumbers: NO];
    _accountNumber = [self makeTexfieldWithCGRect:thirdPos  withPlaceholder:@"Account Number" usesNumbers: NO];
    _pinNumber     = [self makeTexfieldWithCGRect:fourthPos withPlaceholder:@"Pin Number" usesNumbers: YES];
    //_barCode       = [self makeTexfieldWithCGRect:fifthPos  withPlaceholder:@"Bar Code"];
    _balance       = [self makeTexfieldWithCGRect:fifthPos  withPlaceholder:@"Balance" usesNumbers: YES];
    
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
    toolbar.barStyle = UIBarStyleBlackOpaque;
    
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
// Handle the selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    _storeName.text = [retailers objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [retailers count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [retailers objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
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
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(0, 480, 320, 236);
        toolbar.frame = CGRectMake(0, 480, 320, 35);
    }];
    [_storeName setEnabled:YES];
}
-(void)slidePickerUp{
    [UIView animateWithDuration:0.3 animations:^{
        picker.frame = CGRectMake(0, 480 - 236, 320, 236);
        toolbar.frame = CGRectMake(0, 480 - 236 - 35, 320, 35);
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
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationMaskPortrait);
    reader.showsZBarControls = NO;
    reader.cameraOverlayView = [self getCameraOverlay:YES];
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    reader.readerView.zoom = 1.0;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            reader.cameraOverlayView = [self getCameraOverlay:YES];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            reader.cameraOverlayView = [self getCameraOverlay:NO];
            /* start special animation */
            break;
            
        default:
            break;
    };
}

-(UIView*)getCameraOverlay:(BOOL)isPortrait{
    int width, height;
    if(isPortrait){
        width = 320;
        height = 480;
    } else {
        width = 480;
        height = 320;
    }
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    //instructions label 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    label.text = @"Align barcode to scan gift card.";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.5]];
    [overlay addSubview:label];
    
    //reader toolbar menu
    UIToolbar *readerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, height - 45, width, 45)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelReader)];
    NSMutableArray *readerToolbarButtons = [NSMutableArray arrayWithObjects: cancelBtn, nil];
    [readerToolbar setItems:readerToolbarButtons animated:YES];
    readerToolbar.barStyle = UIBarStyleBlackOpaque;
    [overlay addSubview:readerToolbar];
    int offset;
    if(!isPortrait)
        offset = 30;
    else
        offset = 0;
    //images for brackets
    //top left
    UIImageView *bl = [[UIImageView alloc]initWithFrame:CGRectMake(10, (2 * height / 3), 30, 30)];
    bl.image = [UIImage imageNamed:@"bl.png"];
    
    //bottom left
    UIImageView *tl = [[UIImageView alloc]initWithFrame:CGRectMake(10, (height / 3) - offset, 30, 30)];
    tl.image = [UIImage imageNamed:@"tl.png"];
    
    //top right
    UIImageView *br = [[UIImageView alloc]initWithFrame:CGRectMake(width - 10 - 30, (2 * height / 3), 30, 30)];
    br.image = [UIImage imageNamed:@"br.png"];
    
    //bottom right
    UIImageView *tr = [[UIImageView alloc]initWithFrame:CGRectMake(width - 10 - 30, (height / 3) - offset, 30, 30)];
    tr.image = [UIImage imageNamed:@"tr.png"];
    
    //add subviews
    [overlay addSubview:tl];
    [overlay addSubview:bl];
    [overlay addSubview:tr];
    [overlay addSubview:br];
    
    //return camera overlay view
    return overlay;
}


-(void)cancelReader{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    else if([_name.text length] < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Name?" message:@"Don't forget to give a name to your gift card!" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil];
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
        self.currentGiftCard.balance = _balance.text;
        [self.delegate AddGiftCardViewControllerDidSave:self.currentGiftCard];
    }
}



#pragma mark - ZBar Functions

- (void)scan {
    reader.readerView.showsFPS = NO;
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
    NSLog(@"Sym type:%d",[sym type]);
    _barCode.text = typeName;
    _accountNumber.text = data;
    _currentGiftCard.zbarCodeType = [NSNumber numberWithInt:[sym type]];
    if(typeName){
        [_barCode setEnabled:NO];
        [_barCode setOpaque:0.7];
    }
    if(data){
        [_accountNumber setEnabled:NO];
        [_accountNumber setOpaque:0.7];
    }
}

#pragma mark - Auto Rotate Functions

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//for prior ios support
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Array of Supported Retailers

- (void)initializeSupportedRetailers{
    retailers = [[NSMutableArray alloc]initWithObjects:
                 @"", 
                 @"Abercrombie & Fitch",
                 @"Addidas",
                 @"Aeropostale",
                 @"American Eagle",
                 @"Ann Taylor",
                 @"Banana Republic",
                 @"Barneys",
                 @"Ben Franklin",
                 @"Bergners",
                 @"Big Lots",
                 @"Bloomingdales",
                 @"Buckle",
                 @"Burlington Coat Factory",
                 @"Calvin Klein",
                 @"Giorgio Armani",
                 @"Gucci",
                 @"Guess",
                 @"Holister",
                 @"Hugo Boss",
                 @"Kmart",
                 @"Levis",
                 @"Lord & Taylor",
                 @"Louis Vuitton",
                 @"Nike",
                 @"Payless",
                 @"Petco",
                 @"PetSmart",
                 @"Pier One",
                 @"Ralph Lauren",
                 @"Reebok",
                 @"Sams Club",
                 @"Shopko",
                 @"Sports Authority",
                 @"Tommy Hilfiger",
                 @"Vans",
                 @"Victoria's Secret",
                 @"RC Willy",
                 @"Ikea",
                 @"Circuit City",
                 @"RadioShack",
                 @"711",
                 @"Ace Hardware",
                 @"Amazon",
                 @"Apple Store",
                 @"Autozone",
                 @"Barnes & Noble",
                 @"Bed Bath & Beyond",
                 @"Best Buy",
                 @"Costco",
                 @"CVS",
                 @"Dillards",
                 @"Family Dollar",
                 @"Game Stop",
                 @"Gap",
                 @"Home Depot",
                 @"ITunes",
                 @"JCPenny",
                 @"Kohls",
                 @"Kroger",
                 @"Lowes",
                 @"Macys",
                 @"Nordstrom",
                 @"Office Depot",
                 @"Office Max",
                 @"O'Reilly",
                 @"Publix",
                 @"Rite Aid",
                 @"Ross",
                 @"Safeway",
                 @"Sears",
                 @"Staples",
                 @"Starbucks",
                 @"Subway",
                 @"Target",
                 @"TJMax",
                 @"Toys R Us",
                 @"Trader Joes",
                 @"True Value",
                 @"Walgreens",
                 @"Walmart",
                 @"Whole Foods",
                 nil];
    
    icons = [[NSMutableArray alloc] initWithObjects:
             @"",
             @"abercrombie.png",
             @"addidas.png",
             @"aeropostale.png",
             @"americaneagle.png",
             @"ann-taylor.png",
             @"bananarepublic.png",
             @"barneys.png",
             @"benfranklin.png",
             @"bergners.png",
             @"biglots.png",
             @"bloomingdales.png",
             @"buckle.png",
             @"burlington.png",
             @"calvinklein.png",
             @"giorgioarmani.png",
             @"gucci.png",
             @"guess.png",
             @"holister.png",
             @"hugoboss.png",
             @"kmart.png",
             @"levis.png",
             @"lord&taylor.png",
             @"louisvuitton.png",
             @"nike.png",
             @"payless.png",
             @"petco.png",
             @"petsmart-logo.png",
             @"pierone.png",
             @"ralphlauren.png",
             @"reebok.png",
             @"samsclub.png",
             @"shopko.png",
             @"SportsAuthority.png",
             @"tommyhilfiger.png",
             @"vans.png",
             @"victoriassecret.png",
             @"rcwilly.png",
             @"circuitcity.png",
             @"radioshack.png",
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
             @"ikea.png",
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
             @"wholefoods.png",
             nil];
    [retailers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [icons sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [retailers addObject:@"Other"];
    [icons addObject:@"other.png"];
    [self removeUsedStoresFromList];
}

-(void)removeUsedStoresFromList
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Store" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //Search predicate
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableIndexSet *toDelete = [NSMutableIndexSet indexSet];
    
    for(Store *store in results)
    {
        for(NSString *name in retailers)
        {
            if([store.name isEqualToString:name])
            {
                [toDelete addIndex:[retailers indexOfObject:name]];
            }//if
        }//for
    }//for
    [retailers removeObjectsAtIndexes:toDelete];
    [icons     removeObjectsAtIndexes:toDelete];
}
@end














