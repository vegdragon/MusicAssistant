//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import <Foundation/Foundation.h>

@interface AQRecorderObjC : NSObject
+ (void) initRecorder;
+ (void) startRecord;
+ (void) stopRecord;
@end

void RegisterCallBack(void (^cbCppToSwift)(double));
