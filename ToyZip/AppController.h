#import <Foundation/Foundation.h>

@interface FileProcessor : NSObject
- (void)processFinderSelection;
- (void)processFiles:(NSArray *)array;
@end

@interface AppController : NSObject <NSUserNotificationCenterDelegate>{
    IBOutlet FileProcessor *fileProcessorInstance;
}

@end
