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

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) Menu *menu;
@property (strong, nonatomic) Controller *controller;
@property (strong, nonatomic) SerialCommunication *serialCommunication;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _menu = [[Menu alloc] init];
    _serialCommunication = [[SerialCommunication alloc] init];
    _controller = [[Controller alloc] initWithMenu:_menu andSerialComms:_serialCommunication];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
