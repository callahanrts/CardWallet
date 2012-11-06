//
//  Store.h
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * barCodeType;

@end
