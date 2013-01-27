//
//  Insurance.h
//  CardWallet
//
//  Created by Cody Callahan on 1/18/13.
//  Copyright (c) 2013 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface Insurance : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * agent;
@property (nonatomic, retain) NSString * agentNum;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * policyNum;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Vehicle  * vehicle;
@property (nonatomic, retain) NSDate   * effectiveDate;
@property (nonatomic, retain) NSDate   * expDate;
@end
