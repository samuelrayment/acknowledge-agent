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
        _settings.delegate = self;
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
    [self.network connectWithServerAddress:self.settings.address];
    [self.serialCommunication discover];
}

- (void)redClicked {
    NSLog(@"Red");
    [self.serialCommunication sendColor:Red];
}

- (void)amberClicked {
    NSLog(@"Amber");
    [self.serialCommunication sendColor:Amber];
}

- (void)greenClicked {
    NSLog(@"Green");
    [self.serialCommunication sendColor:Green];
}

- (void)openDashboardClicked {
    NSString *serverSetting = self.settings.address;
    NSString *serverURL = [NSString stringWithFormat:@"http://%@/", serverSetting];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:serverURL]];
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

- (void)settingsUpdated {
    NSLog(@"Settings Updated");
    [self.network close];
    [self.network connectWithServerAddress:self.settings.address];
}

@end
