//
//  Vehicle.h
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * vinNum;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSManagedObject *insurance;

@end
