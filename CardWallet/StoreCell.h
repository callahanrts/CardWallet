//
//  StoreCell.h
//  CardWallet
//
//  Created by Cody Callahan on 11/4/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) IBOutlet UILabel *storeLabel;
@end
