#import <Foundation/Foundation.h>

@class RCDemoIMLibCoreFeature;

NS_ASSUME_NONNULL_BEGIN

typedef void (^RCDemoIMLibCoreExecutionCompletion)(NSString *result, BOOL success);

/// 按功能动作执行真实 SDK 调用，并集中持有需要持续存在的 Delegate。
@interface RCDemoIMLibCoreFeatureExecutor : NSObject

+ (instancetype)sharedExecutor;

- (void)executeFeature:(RCDemoIMLibCoreFeature *)feature
             parameters:(NSDictionary<NSString *, id> *)parameters
              completion:(RCDemoIMLibCoreExecutionCompletion)completion;

@end

@interface RCDemoIMLibCoreFeatureExecutor (MessageSendControl)
- (void)cancelCurrentMediaMessageWithCompletion:(RCDemoIMLibCoreExecutionCompletion)completion;
@end

NS_ASSUME_NONNULL_END

