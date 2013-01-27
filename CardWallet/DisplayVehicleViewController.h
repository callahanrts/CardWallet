//
//  DisplayVehicleViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/19/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@interface DisplayVehicleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *makeLbl;
@property (strong, nonatomic) IBOutlet UILabel *modelLbl;
@property (strong, nonatomic) IBOutlet UILabel *yearLbl;
@property (strong, nonatomic) IBOutlet UILabel *vinLbl;
@property (strong, nonatomic) IBOutlet UIView *vinView;
@property (strong, nonatomic) IBOutlet UIView *vehicleView;


@property (strong, nonatomic) Vehicle *currentVehicle;

@end
