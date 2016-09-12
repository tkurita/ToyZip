#import "AppController.h"
#import "DonationReminder/DonationReminder.h"

#define useLog 0

@implementation AppController

/*
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}
 */

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserNotificationCenter *user_notification_center = [NSUserNotificationCenter defaultUserNotificationCenter];
    [user_notification_center setDelegate:self];
	[DonationReminder remindDonation];

    NSDictionary *user_info = aNotification.userInfo;
    NSUserNotification *user_notification = [user_info objectForKey:NSApplicationLaunchUserNotificationKey];
    if (user_notification) {
#if useLog
        NSLog(@"UserNotification : %@", user_notification);
        NSLog(@"userInfo : %@", user_notification.userInfo);
#endif
        //[user_notification_center removeDeliveredNotification:user_notification];
        [[NSWorkspace sharedWorkspace] selectFile:user_notification.userInfo[@"path"] inFileViewerRootedAtPath:@""];
        [NSApp terminate:self];
        return;
    }
    
    if ([[user_info objectForKey:NSApplicationLaunchIsDefaultLaunchKey] boolValue]) {
         [fileProcessorInstance processFinderSelection];
    } else {
        // launched to open or print a file, to perform a Service action
        NSAppleEventDescriptor *ev = [[NSAppleEventManager sharedAppleEventManager] currentAppleEvent];
        NSAppleEventDescriptor *prop_data;
        switch ([ev eventID]) {
                case kAEOpenDocuments:
#if useLog
                    NSLog(@"kAEOpenDocuments");
#endif
                    break;
                case kAEOpenApplication:
#if useLog
                    NSLog(@"kAEOpenApplication : %@", [ev paramDescriptorForKeyword:keyAEPropData]);
#endif
                    prop_data = [ev paramDescriptorForKeyword:keyAEPropData];
                    if (prop_data) {
                        switch([prop_data enumCodeValue]) {
                                case keyAELaunchedAsLogInItem:
                                case keyAELaunchedAsServiceItem:
                                    return;
                        }
                    } else {
                        [fileProcessorInstance processFinderSelection];
                    }
                    break;
        }
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
#if useLog
    NSLog(@"start didActivateNotification");
    NSLog(@"path : %@", notification.userInfo[@"path"]);
#endif
    [[NSWorkspace sharedWorkspace] selectFile:notification.userInfo[@"path"] inFileViewerRootedAtPath:@""];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)array
{
    [fileProcessorInstance processFiles:array];
}
@end
