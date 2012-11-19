//
//  BarcodeManager.m
//  Tech Wallet
//
//  Created by Daniel Lu on 6/7/11.
//  Copyright 2011 Exigen Services. All rights reserved.
//

#import "BarcodeManager.h"
#import "NKDBarcodeFramework.h"


@implementation BarcodeManager

+ (NKDBarcode *) generateBarcodeWithContent: (NSString *) codeData type: (BarcodeType) type size: (CGSize) size
{
	NSString *barcodeClassName;
	NSString *classNameTpl = @"NKD%@Barcode";
	
	switch (type) {
		case Code39:
			barcodeClassName  = [NSString stringWithFormat: classNameTpl, @"Code39"];
			break;
		case Code128:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"Code128"];
			break;
		case EAN13:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"EAN13"];
			break;
		case EAN8:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"EAN8"];
			break;
		case ExtendedCode39:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"ExtendedCode39"];
			break;
		case IndustrialTwoOfFive:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"IndustrialTwoOfFive"];
			break;
		case InterleavedTwoOfFive:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"InterleavedTwoOfFive"];
			break;
		case ModifiedPlessey:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"ModifiedPlessey"];
			break;
		case ModifiedPlesseyHex:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"ModifiedPlesseyHex"];
			break;
		case Planet:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"Planet"];
			break;
		case Postnet:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"Postnet"];
			break;
		case RoyalMail:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"RoyaMail"];
			break;
		case UPCA:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"UPCA"];
			break;
		case UPCE:
			barcodeClassName = [NSString stringWithFormat: classNameTpl, @"UPCE"];
			break;
		default:
			barcodeClassName = @"NKDBarcode";
			break;
	}
	
	NKDBarcode *barcode = [[[NSClassFromString(barcodeClassName) alloc] 
													 initWithContent: codeData] autorelease];
	
	if (size.width > 0) {
		[barcode setWidth: size.width];
	}
	
	if (size.height > 0) {
		[barcode setHeight: size.height];
	}
	
	return barcode;
}

+ (NKDBarcode *) generateBarcodeWithContent:(NSString *)codeData type:(BarcodeType)type
{
	return [BarcodeManager generateBarcodeWithContent: codeData type: type size: CGSizeMake(0.0, 0.0)];
}

+ (UIImage *) generateBarcodeImageWithContent:(NSString *)codeData type:(BarcodeType)type size:(CGSize)size
{
	NKDBarcode *barcode = [BarcodeManager generateBarcodeWithContent: codeData type: type size: size];
	return [UIImage imageFromBarcode: barcode];
}

+ (NSData *) generateBarcodePDFWithContent:(NSString *)codeData type:(BarcodeType)type size:(CGSize)size
{
	NKDBarcode *barcode = [BarcodeManager generateBarcodeWithContent: codeData type: type size: size];
	return [UIImage pdfFromBarcode: barcode];
}

@end
