//
//  ReadCollectionViewCell.h
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadModel.h"

@interface ReadCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UILabel *ennameL;

- (void)cellConfigureModel:(ReadModel *)model;



@end
