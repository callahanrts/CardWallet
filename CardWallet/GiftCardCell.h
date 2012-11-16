//
//  GiftCardCell.h
//  CardWallet
//
//  Created by Cody Callahan on 11/15/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCardCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *giftCardImage;
@property (strong, nonatomic) IBOutlet UIImageView *foldImage;
@property (strong, nonatomic) IBOutlet UILabel *giftCardLabel;

@end
