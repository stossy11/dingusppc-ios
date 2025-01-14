//
//  Main2Wrapper.m
//  dingusppc-ios
//
//  Created by Stossy11 on 07/01/2025.
//


#import "dingusppcWrapper.h"
#import "main.h" // Include the C++ header where main2 is declared.

@implementation dingusppcWrapper

+ (int)runWithArguments:(NSArray<NSString *> *)arguments {
    // Convert NSArray<NSString *> to C-style argc and argv
    int argc = (int)arguments.count;
    char **argv = (char **)malloc(sizeof(char *) * argc);
    
    for (int i = 0; i < argc; i++) {
        NSString *arg = arguments[i];
        argv[i] = strdup(arg.UTF8String); // Convert NSString to C string
    }

    // Call the main2 function
    int result = main2(argc, argv);

    // Free allocated memory
    for (int i = 0; i < argc; i++) {
        free(argv[i]);
    }
    free(argv);

    return result;
}

+ (void) startDebugger {
    startDebugger();
}

+ (void) initSDL {
    init();
}

@end
