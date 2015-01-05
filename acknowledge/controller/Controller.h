//
//  Controller.h
//  The central controller for Acknowledge responsible for dispatching messages between the various
//  components.
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
#import "SerialCommunication.h"
#import "Network.h"

@interface Controller : NSObject <MenuDelegate, SerialCommunicationDelegate, NetworkDelegate>

- (instancetype)initWithMenu:(Menu *)menu
              andSerialComms:(SerialCommunication*)aSerialCommunication
                  andNetwork:(Network*)aNetwork;
- (void)connectionStateChanged:(BOOL)connected;
- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage;

@end