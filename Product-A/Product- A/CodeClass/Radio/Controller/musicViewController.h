//
//  musicViewController.h
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SecondViewController.h"
#import "DetailModel.h"

@interface musicViewController : SecondViewController

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UIButton *heartBtn;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)UIButton *downLoadBtn;
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)UILabel *allTimeL;
@property(nonatomic,strong)UIView *pagOne;
@property(nonatomic,strong)UIView *pagTwo;
@property(nonatomic,strong)UIView *pagThree;
@property(nonatomic,strong)UIView *bassView;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)UIButton *next;
@property(nonatomic,strong)UIButton *playAndPause;

@property(nonatomic,strong)UIButton *roundBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *collectionBtn;


@end
