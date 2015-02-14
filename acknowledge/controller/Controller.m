//
//  Controller.m
//  The central controller for Acknowledge responsible for dispatching
//  messages between the various components.
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
@property (strong, nonatomic) SettingsController* settingsController;

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


- (SettingsController*)settingsController {
    if (_settingsController == nil) {
        _settingsController = [[SettingsController alloc] initWithWindowNibName:@"SettingsController"];
        _settingsController.settings = self.settings;
    }
    return _settingsController;
}

#pragma - mark Menu Delegate

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
    [self.settingsController.window makeKeyAndOrderFront:nil];
    [self.settingsController showWindow:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)quitClicked {
    exit(0);
}

#pragma mark - SerialCommunicationDelegate

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

#pragma mark - NetworkDelegate

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

#pragma mark - UserSettingsDelegate 

- (void)addressUpdated {
    [self.network close];
    [self.network connectWithServerAddress:self.settings.address];
}

- (void)notificationsEnabledUpdated {
    NSLog(@"Notifications Enabled Updated");
}

#pragma mark - Notifications

- (void)sendNotification:(NetworkMessage*)aNetworkMessage {
    if (self.settings.notificationsEnabled) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Acknowledge Status Update";
        NSString *colour = RAGStateToString(aNetworkMessage.state);
        
        notification.informativeText = [NSString stringWithFormat:@"Status Changed To: %@", colour];
        notification.soundName = NSUserNotificationDefaultSoundName;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

@end
