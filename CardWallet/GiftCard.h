//
//  GiftCards.h
//  CardWallet
//
//  Created by Cody Callahan on 11/18/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Store;

@interface GiftCard : NSManagedObject

@property (nonatomic, retain) NSString * accountNumber;
@property (nonatomic, retain) NSString * barCode;
@property (nonatomic, retain) NSString * balance;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pin;
@property (nonatomic, retain) NSNumber * zbarCodeType;
@property (nonatomic, retain) Store *store;

@end
