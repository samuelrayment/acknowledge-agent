//
//  AppDelegate.m
//  acknowledge
//
//  Created by Samuel Rayment on 30/12/2014.
//  Copyright (c) 2014 Samuel Rayment. All rights reserved.
//

#import "AppDelegate.h"
#import "Menu.h"
#import "Controller.h"
#import "SerialCommunication.h"
#import "Network.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) Menu *menu;
@property (strong, nonatomic) Controller *controller;
@property (strong, nonatomic) SerialCommunication *serialCommunication;
@property (strong, nonatomic) Network *network;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _menu = [[Menu alloc] init];
    _serialCommunication = [[SerialCommunication alloc] init];
    _network = [[Network alloc] init];
    _controller = [[Controller alloc] initWithMenu:_menu andSerialComms:_serialCommunication
                                        andNetwork:_network];
}

//
//- (void)sendNotification:(NetworkMessage*)aNetworkMessage {
//    NSUserNotification *notification = [[NSUserNotification alloc] init];
//    notification.title = @"Colour Change";
//    NSString *colour;
//    switch (aNetworkMessage.chosenState) {
//        case Red:
//            colour = @"Red";
//            break;
//        case Green:
//            colour = @"Green";
//            break;
//        case Amber:
//            colour = @"Amber";
//            break;
//    }
//    
//    notification.informativeText = [NSString stringWithFormat:@"Colour Changed To: %@", colour];
//    notification.soundName = NSUserNotificationDefaultSoundName;
//    
//    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
//}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
