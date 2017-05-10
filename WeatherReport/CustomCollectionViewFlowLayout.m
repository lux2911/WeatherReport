//
//  CustomCollectionViewFlowLayout.m
//  Weather
//
//  Created by Tomislav Luketic on 5/7/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout



-(void)prepareLayout
{
    
    CGFloat w = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right -
    self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    
    self.itemSize = CGSizeMake(w, 80);
    
    [super prepareLayout];
}


@end
