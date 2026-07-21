//
//  RCDemoPopoverAction.m
//  im-quickdemo-ios
//
//  Created by pengwenxin on 2022/7/27.
//

#import "RCDemoPopoverAction.h"

@interface  RCDemoPopoverAction ()

@property (nonatomic, strong, readwrite, nullable) UIImage *image;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) void(^handler)(RCDemoPopoverAction *action);

@end

@implementation RCDemoPopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(RCDemoPopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(nullable UIImage *)image title:(NSString *)title handler:(void (^)(RCDemoPopoverAction *action))handler {
    RCDemoPopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}

@end
