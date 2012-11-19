//
//  BarcodeManager.h
//  Tech Wallet
//
//  Created by Daniel Lu on 6/7/11.
//  Copyright 2011 Exigen Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NKDBarcode;

typedef enum {
	CodeAuto,
	Code128,
	Code39,
	EAN13,
	EAN8,
	ExtendedCode39,
	IndustrialTwoOfFive,
	InterleavedTwoOfFive,
	ModifiedPlessey,
	ModifiedPlesseyHex,
	Planet,
	Postnet,
	RoyalMail,
	UPCA,
	UPCE
} BarcodeType;

@interface BarcodeManager : NSObject {

}

+ (NKDBarcode *) generateBarcodeWithContent: (NSString *) codeData type: (BarcodeType) type size: (CGSize) size;
+ (NKDBarcode *) generateBarcodeWithContent: (NSString *) codeData type: (BarcodeType) type;
+ (UIImage *)    generateBarcodeImageWithContent: (NSString *) codeData type: (BarcodeType) type size: (CGSize) size;
+ (NSData *)     generateBarcodePDFWithContent:   (NSString *) codeData type: (BarcodeType) type size: (CGSize) size;

@end
