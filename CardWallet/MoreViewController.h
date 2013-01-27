//
//  MoreViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/25/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
<UITextViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) UIWebView *webView;

- (IBAction)rateUsBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)submitBtn:(id)sender;

@end
