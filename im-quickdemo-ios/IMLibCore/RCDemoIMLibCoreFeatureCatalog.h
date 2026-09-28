#import <Foundation/Foundation.h>

@class RCDemoIMLibCoreFeatureGroup;

NS_ASSUME_NONNULL_BEGIN

/// 将当前已实现的公开 API 按能力域转换为 IMLibCore Tab 可展示的数据。
@interface RCDemoIMLibCoreFeatureCatalog : NSObject

+ (NSArray<RCDemoIMLibCoreFeatureGroup *> *)allGroups;

@end

NS_ASSUME_NONNULL_END

