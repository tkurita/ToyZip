#import "AppController.h"
#import "DonationReminder/DonationReminder.h"

@interface NSString (ZipArchiver)
- (NSAppleEventDescriptor *)appleEventDescriptor;
@end

@implementation NSString (ZipArchiver)

- (NSAppleEventDescriptor *)appleEventDescriptor
{
    return [NSAppleEventDescriptor descriptorWithString:self];
}

@end

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSAppleEventDescriptor *ev = [[NSAppleEventManager sharedAppleEventManager] currentAppleEvent];
    AEEventID evid = [ev eventID];
	NSAppleEventDescriptor *prop_data;
    BOOL should_process = NO;
	switch (evid) {
		case kAEOpenDocuments:
			break;
		case kAEOpenApplication:
			prop_data = [ev paramDescriptorForKeyword: keyAEPropData];
			DescType type = prop_data ? [prop_data descriptorType] : typeNull;
			OSType value = 0;
			if(type == typeType) {
				value = [prop_data typeCodeValue];
				switch (value) {
					case keyAELaunchedAsLogInItem:
						break;
					case keyAELaunchedAsServiceItem:
						break;
				}
			} else {
				should_process = YES;
			}
			break;
	}
	
	[DonationReminder remindDonation];
    if (should_process) {
        [FileProcessor processFinderSelection];
    }
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)array
{
    [FileProcessor processFiles:array];
}
@end
