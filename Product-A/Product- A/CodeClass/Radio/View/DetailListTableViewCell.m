//
//  DetailListTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailListTableViewCell.h"
#import "MusicDownloadTable.h"

@implementation DetailListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellConfigureModel:(DetailModel *)model{
    self.titleL.text = model.title;
    self.unameL.text = model.uname;
    
    if (model.downloadType == UnDownload) {
        self.downLoadBtn.tintColor = PKCOLOR(210, 210, 210);
    } else if(model.downloadType == Downloadimg && self.isFirst == YES){
        self.downLoadBtn.tintColor = [UIColor greenColor];
        [self.downLoadBtn setImage:[UIImage imageNamed:@"downloading_updates"] forState:(UIControlStateNormal)];
    } else if (model.downloadType == Downloadimg && self.isFirst == NO){
        self.isFirst = YES;
        self.downLoadBtn.tintColor = [UIColor greenColor];
    }
    else if (model.downloadType == DiDdwonload){
        self.downLoadBtn.tintColor = [UIColor redColor];
    } else if(model.downloadType == DownloadPause){
       [self.downLoadBtn setImage:[UIImage imageNamed:@"play_filled"] forState:(UIControlStateNormal)];
        self.downLoadBtn.tintColor = [UIColor greenColor];
    }
    if (model.isPlay) {
        self.flag.hidden = NO;
    } else{
        self.flag.hidden = YES;
    }
}




@end
