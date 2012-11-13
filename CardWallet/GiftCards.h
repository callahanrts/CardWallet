//
//  GiftCards.h
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GiftCards : NSManagedObject

@property (nonatomic, retain) NSString * barCode;
@property (nonatomic, retain) NSString * pin;
@property (nonatomic, retain) NSString * accountNumber;

@end
