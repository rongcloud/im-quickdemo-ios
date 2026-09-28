#import "RCDemoIMLibCoreFeature.h"

@interface RCDemoIMLibCoreFeature ()
@property (nonatomic, assign, readwrite) RCDemoIMLibCoreFeatureAction action;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *api;
@property (nonatomic, copy, readwrite) NSString *note;
@property (nonatomic, copy, readwrite) NSArray<NSString *> *parameterKeys;
@property (nonatomic, assign, readwrite, getter=isDangerous) BOOL dangerous;
@end

@implementation RCDemoIMLibCoreFeature

+ (instancetype)featureWithAction:(RCDemoIMLibCoreFeatureAction)action
                            title:(NSString *)title
                              api:(NSString *)api
                    parameterKeys:(NSArray<NSString *> *)parameterKeys
                        dangerous:(BOOL)dangerous
                             note:(NSString *)note {
    RCDemoIMLibCoreFeature *feature = [[self alloc] init];
    feature.action = action;
    feature.title = title;
    feature.api = api;
    feature.parameterKeys = parameterKeys ?: @[];
    feature.dangerous = dangerous;
    feature.note = note ?: @"";
    return feature;
}

@end

@interface RCDemoIMLibCoreFeatureGroup ()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray<RCDemoIMLibCoreFeature *> *features;
@end


@implementation RCDemoIMLibCoreFeatureGroup

+ (instancetype)groupWithTitle:(NSString *)title features:(NSArray<RCDemoIMLibCoreFeature *> *)features {
    RCDemoIMLibCoreFeatureGroup *group = [[self alloc] init];
    group.title = title;
    group.features = features;
    return group;
}

@end

