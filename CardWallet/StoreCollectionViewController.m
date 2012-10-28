//
//  StoreCollectionViewController.m
//  CardWallet
//
//  Created by Cody Callahan on 10/28/12.
//  Copyright (c) 2012 RCM. All rights reserved.
//

#import "StoreCollectionViewController.h"

@interface StoreCollectionViewController ()

@end

@implementation StoreCollectionViewController
@synthesize icons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [icons addObject:@"costco.jpg"];
    return self;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;//later return the length of the object holding all of the stores;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
