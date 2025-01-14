//
//  Main2Wrapper.h
//  dingusppc-ios
//
//  Created by Stossy11 on 07/01/2025.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface dingusppcWrapper : NSObject

/// Runs the main2 function with the provided arguments.
/// @param arguments An array of NSString objects representing the arguments.
/// @return The exit code of the main2 function.
+ (int)runWithArguments:(NSArray<NSString *> *)arguments;

+ (void)startDebugger;

+ (void)initSDL;

@end

NS_ASSUME_NONNULL_END
