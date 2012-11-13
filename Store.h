//
//  Store.h
//  CardWallet
//
//  Created by Cody Callahan on 11/10/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GiftCards;

@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * barCodeType;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *giftCard;
@end

@interface Store (CoreDataGeneratedAccessors)

- (void)addGiftCardObject:(GiftCards *)value;
- (void)removeGiftCardObject:(GiftCards *)value;
- (void)addGiftCard:(NSSet *)values;
- (void)removeGiftCard:(NSSet *)values;

@end
