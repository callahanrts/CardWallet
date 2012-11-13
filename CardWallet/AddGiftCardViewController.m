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
    if(_currentGiftCard.store.name){
        _storeName.text = self.currentGiftCard.store.name;
        [_storeName setEnabled:NO];
        [_storeName setAlpha:0.7];
    }
    _accountNumber.text = self.currentGiftCard.accountNumber;
    _barCode.text = self.currentGiftCard.barCode;
    _pinNumber.text = self.currentGiftCard.pin;
    _name.text  = self.currentGiftCard.name;
    
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    reader.readerView.zoom = 1.0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(initialLoad){
        [self scan];
        initialLoad = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate AddGiftCardViewControllerDidCancel:self.currentGiftCard];
}

- (IBAction)save:(id)sender {
    if(!self.currentGiftCard.store.name){
        self.currentGiftCard.store.name = _storeName.text;
        self.currentGiftCard.store.image = @"costcoIcon.png";
    }
    self.currentGiftCard.name = _name.text;
    self.currentGiftCard.accountNumber = _accountNumber.text;
    self.currentGiftCard.pin = _pinNumber.text;
    self.currentGiftCard.barCode = _barCode.text;
    [self.delegate AddGiftCardViewControllerDidSave];
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
