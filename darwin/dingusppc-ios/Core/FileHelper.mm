//
//  documentsdir.mm
//  dingusppc-ios
//
//  Created by Stossy11 on 08/01/2025.
//

#import "FileHelper.h"
#import <Foundation/Foundation.h>

const char* getDocumentsDirectory() {
    // Access the Documents directory using NSFileManager
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Convert NSString to const char*
    return [documentsDirectory UTF8String];
}
