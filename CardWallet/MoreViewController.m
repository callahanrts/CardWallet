//
//  MoreViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 1/25/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import "MoreViewController.h"
#import "Appirater.h"
#import "QuartzCore/QuartzCore.h"

@interface MoreViewController ()

@end

@implementation MoreViewController{
    UIToolbar *toolbar;
    UIActivityIndicatorView *spinner;
    UIView *overlay;
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
    [Appirater setAppId:@"583253138"];
    
    /*_webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 55, self.view.frame.size.width,self.view.frame.size.height - 55)];
    NSString *url=@"http://codycallahan.com";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
    [self.view addSubview:_webView];*/
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    UIView *mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mask.backgroundColor = [UIColor colorWithWhite:255 alpha:0.9];
    [self.view addSubview:mask];
    [self.view sendSubviewToBack:mask];
    
    
    _emailField.delegate = self;
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 15, 320, 35)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(done:)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    NSArray *buttons = [NSArray arrayWithObjects: item1, nil];
    [toolbar setItems: buttons animated:NO];
    
    [self.view addSubview:toolbar];
    
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 5.0f;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)rateUsBtn:(id)sender {
    [Appirater rateApp];
}

#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 145,
                                 self.view.frame.size.width, self.view.frame.size.height);
    
    CGRect frame = toolbar.frame;
    frame.origin.y -= 121.0;
    toolbar.frame = frame;
    
    
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 145,
                                 self.view.frame.size.width, self.view.frame.size.height);
    
    CGRect frame = toolbar.frame;
    frame.origin.y += 121.0;
    toolbar.frame = frame;
    
    [UIView commitAnimations];    
}

-(void)done:(id)sender {
    [_textView resignFirstResponder];
}
/*

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = toolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    toolbar.frame = frame;
    
    [UIView commitAnimations];
}
*/
- (IBAction)submitBtn:(id)sender {
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    overlay.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.7];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    
    
    NSString *url = [NSString stringWithFormat:@"http://codycallahan.com/cwallet.php?page=1&email=%@&suggestion=%@",
                     _emailField.text,
                     _textView.text];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    [[NSURLConnection alloc] initWithRequest:nsrequest delegate:self];
    
    [spinner startAnimating];
    
    [self.view addSubview:overlay];
    [overlay addSubview:spinner];
    
}

#pragma mark - Connection Delegate Methods

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [spinner stopAnimating];
    [overlay removeFromSuperview];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                      message:@"Thank you for your suggestion!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    _emailField.text = @"";
    _textView.text = @"";
}

@end
