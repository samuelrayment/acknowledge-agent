//
//  Controller.m
//  The central controller for Acknowledge responsible for dispatching messages between the various
//  components.
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Controller.h"
#import "SettingsController.h"

@interface Controller ()

@property (strong, readonly) Menu *menu;
@property (strong, readonly) SerialCommunication *serialCommunication;
@property (strong, readonly) Network *network;
@property (strong, readonly) UserSettings *settings;
@property (strong, nonatomic) SettingsController* previewWindow;

@end

@implementation Controller

- (instancetype)initWithMenu:(Menu *)menu
              andSerialComms:(SerialCommunication*)aSerialCommunication
                  andNetwork:(Network*)aNetwork andUserSettings:(UserSettings*)aSettings{
    self = [super init];
    if (self != nil) {
        _settings = aSettings;
        _menu = menu;
        _menu.delegate = self;
        _serialCommunication = aSerialCommunication;
        _serialCommunication.delegate = self;
        _network = aNetwork;
        _network.delegate = self;
        [self initComms];
    }
    return self;
}

- (void)initComms {
    [_serialCommunication discover];
}

- (void)redClicked {
    NSLog(@"Red");
    [_serialCommunication sendColor:Red];
}

- (void)amberClicked {
    NSLog(@"Amber");
    [_serialCommunication sendColor:Amber];
}

- (void)greenClicked {
    NSLog(@"Green");
    [_serialCommunication sendColor:Green];
}

- (void)openDashboardClicked {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://10.73.146.15/" ]];
}

- (void)settingsClicked {
    NSLog(@"Settings");
    [self.previewWindow.window makeKeyAndOrderFront:nil];
    [self.previewWindow showWindow:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)quitClicked {
    exit(0);
}

- (SettingsController*)previewWindow {
    if (_previewWindow == nil) {
        _previewWindow = [[SettingsController alloc] initWithWindowNibName:@"SettingsController"];
        _previewWindow.settings = self.settings;
    }
    return _previewWindow;
}

- (void)serialConnectionStateChanged:(BOOL)connected {
    if (connected) {
        NSLog(@"Connected");
        [_serialCommunication sendColor: _menu.chosenState];
        [_menu setActive:YES];
    } else {
        NSLog(@"Disconnected");
        [_menu setActive:NO];
    }
}

- (void)connectionStateChanged:(BOOL)connected {
    if (connected) {
        NSLog(@"Network Connected");
    } else {
        NSLog(@"Network Disconnected");
        _menu.networkState = Disconnected;
    }
}

- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage {
    [_serialCommunication sendColor:aNetworkMessage.state];
    _menu.networkState = aNetworkMessage.state;
    [self sendNotification:aNetworkMessage];
}

- (void)sendNotification:(NetworkMessage*)aNetworkMessage {
//    NSUserNotification *notification = [[NSUserNotification alloc] init];
//    notification.title = @"Colour Change";
//    NSString *colour = RAGStateToString(aNetworkMessage.state);
//    
//    notification.informativeText = [NSString stringWithFormat:@"Colour Changed To: %@", colour];
//    notification.soundName = NSUserNotificationDefaultSoundName;
//    
//    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
