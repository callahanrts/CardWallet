//
//  HelpViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 11/14/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController{
    UITextView *oneText;
    UITextView *twoText;
    UILabel *two;
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    CGRect frameOne = CGRectMake(20, 45, self.view.frame.size.width - 40, 36);
    
    //orientation change
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    //1. how to add a gift card label
    UILabel *one = [[UILabel alloc] initWithFrame:frameOne];
    one.font = [UIFont fontWithName:@"Noteworthy-Bold" size:23];
    one.backgroundColor = [UIColor clearColor];
    one.text = @"1. How to add a gift card";
    [self.view addSubview:one];
    
    //text for help menu 1.
    oneText = [[UITextView alloc]initWithFrame:CGRectMake(20, 36 + 45, 320 - 40, 20)];
    oneText.backgroundColor = [UIColor clearColor];
    oneText.font = [UIFont fontWithName:@"Helvetica" size:14];
    oneText.text = @"Use the + button on any screen to add a new gift card. If the gift card has a bar code, scan it to retrieve information from the gift card. Give the gift card a name and save. ";
    [self.view addSubview:oneText];
    CGRect frame = oneText.frame;
    frame.size = oneText.contentSize;
    oneText.frame = frame;
    
    //2. how to add a gift card label
    two = [[UILabel alloc] initWithFrame:CGRectMake(20, oneText.frame.size.height + oneText.frame.origin.y, 320 - 40, 20)];
    two.font = [UIFont fontWithName:@"Noteworthy-Bold" size:23];
    two.backgroundColor = [UIColor clearColor];
    two.text = @"2. How to use a gift card";
    [self.view addSubview:two];
    
    
    //text for help menu 1.
    twoText = [[UITextView alloc]initWithFrame:CGRectMake(20, two.frame.origin.y + two.frame.size.height + 5, 320 - 40, 20)];
    twoText.backgroundColor = [UIColor clearColor];
    twoText.font = [UIFont fontWithName:@"Helvetica" size:14];
    twoText.text = @"Tap on a gift card in order to bring up the gift card's information. If your gift card had a common bar code it may be scanned at the store. Otherwise, the account number can still be used for purchases both in store and online. ";
    [self.view addSubview:twoText];
    frame = twoText.frame;
    frame.size = twoText.contentSize;
    twoText.frame = frame;
    
}

-(void)deviceOrientationDidChange: (NSNotification *)notification {
    //Obtaining the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        oneText.frame = CGRectMake(20, 36 + 45, 480 - 40, 30);
        CGRect frame = oneText.frame;
        frame.size = oneText.contentSize;
        oneText.frame = frame;
        
        //update label one
        two = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height + oneText.frame.origin.y, 480 - 40, 20)];
        
        twoText.frame = CGRectMake(20, two.frame.origin.y + two.frame.size.height + 20, 480 - 40, 30);
        frame = twoText.frame;
        frame.size = twoText.contentSize;
        twoText.frame = frame;
    }
    else if(orientation == UIDeviceOrientationPortrait)
    {
        oneText.frame = CGRectMake(20, 36 + 45, 320 - 40, 30);
        CGRect frame = oneText.frame;
        frame.size = oneText.contentSize;
        oneText.frame = frame;
        
        //update label two
        two = [[UILabel alloc] initWithFrame:CGRectMake(20, oneText.frame.size.height + oneText.frame.origin.y, 320 - 40, 20)];
        
        twoText.frame = CGRectMake(20, two.frame.origin.y + two.frame.size.height + 5, 320 - 40, 30);
        frame = twoText.frame;
        frame.size = twoText.contentSize;
        twoText.frame = frame;
    }
    else 
        return;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
