//
//  RCDemoCustomMediaMessageCell.m
//  im-quickdemo-ios
//
//  Created by 于艳平 on 2022/7/31.
//

#import "RCDemoCustomMediaMessageCell.h"
#import "RCDemoCustomMediaMessage.h"
static CGFloat const RCDemoCustomMediaMessageHeight = 147;
static CGFloat const RCDemoCustomMediaMessageWidth = 240;


@implementation RCDemoCustomMediaMessageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self showBubbleBackgroundView:YES];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.messageContentView addSubview:self.imageView];

}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, extraHeight + RCDemoCustomMediaMessageHeight);
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}

- (void)setAutoLayout {
    RCDemoCustomMediaMessage *mediaMessage = (RCDemoCustomMediaMessage *)self.model.content;
    CGSize bubbleBackgroundViewSize = CGSizeMake(RCDemoCustomMediaMessageWidth + 5, RCDemoCustomMediaMessageHeight + 5);
    self.imageView.frame = CGRectMake(2.5, 2.5, RCDemoCustomMediaMessageWidth, RCDemoCustomMediaMessageHeight);
    self.messageContentView.contentSize = bubbleBackgroundViewSize;
    self.imageView.image = mediaMessage.thumbnailImage;
}
@end
