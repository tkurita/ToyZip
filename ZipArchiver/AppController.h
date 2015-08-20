#import <Foundation/Foundation.h>

@interface FileProcessor : NSObject
- (void)processFinderSelection;
- (void)processFiles:(NSArray *)array;
@end

@interface AppController : NSObject {
    IBOutlet FileProcessor *fileProcessorInstance;
}

@end
