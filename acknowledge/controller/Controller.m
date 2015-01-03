//
//  Controller.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "Controller.h"

@interface Controller ()

@property (strong, readonly) Menu *menu;
@property (strong, readonly) SerialCommunication *serialCommunication;
@property (strong, readonly) Network *network;

@end

@implementation Controller

- (instancetype)initWithMenu:(Menu *)menu
              andSerialComms:(SerialCommunication*)aSerialCommunication
                  andNetwork:(Network*)aNetwork {
    self = [super init];
    if (self != nil) {
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

- (void)connectionStateChanged:(BOOL)connected {
    if (connected) {
        NSLog(@"Connected");
        [_serialCommunication sendColor: _menu.chosenState];
        [_menu setActive:YES];
    } else {
        NSLog(@"Disconnected");
        [_menu setActive:NO];
    }
}

- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage {
    NSLog(@"Network Message: %@", aNetworkMessage);
    [_serialCommunication sendColor:aNetworkMessage.state];
}

@end
