//
//  AddVehicleViewController.h
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@protocol AddVehicleViewControllerDelegate;

@interface AddVehicleViewController : UIViewController
<UITextFieldDelegate>

@property (nonatomic, weak) id <AddVehicleViewControllerDelegate> delegate;

@property (nonatomic, strong) Vehicle *currentVehicle;
@property (strong, nonatomic) IBOutlet UITextField *makeTF;
@property (strong, nonatomic) IBOutlet UITextField *modelTF;
@property (strong, nonatomic) IBOutlet UITextField *yearTF;
@property (strong, nonatomic) IBOutlet UITextField *vinTF;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end


@protocol AddVehicleViewControllerDelegate

-(void)addVehicleViewControllerDidSave:(Vehicle*)currentVehicle;
-(void)addVehicleViewControllerDidCancel:(Vehicle*)vehicleToDelete;

@end
