//
//  DisplayInsuranceViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/25/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Insurance.h"

@interface DisplayInsuranceViewController : UIViewController

@property (strong, nonatomic) Insurance *currentInsurance;

@property (strong, nonatomic) IBOutlet UILabel *typeLbl;
@property (strong, nonatomic) IBOutlet UILabel *companyLbl;
@property (strong, nonatomic) IBOutlet UILabel *companyAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *companyPhoneLbl;
@property (strong, nonatomic) IBOutlet UILabel *agentLbl;
@property (strong, nonatomic) IBOutlet UILabel *agentNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *policyNumberLbl;
@property (strong, nonatomic) IBOutlet UIView *insuranceView;
@property (strong, nonatomic) IBOutlet UIView *policyView;



@end
