//
//  Controller.h
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
#import "SerialCommunication.h"
#import "Network.h"

@interface Controller : NSObject <MenuDelegate, SerialCommunicationDelegate, NetworkMessageReceiver>

- (instancetype)initWithMenu:(Menu *)menu
              andSerialComms:(SerialCommunication*)aSerialCommunication
                  andNetwork:(Network*)aNetwork;
- (void)redClicked;
- (void)amberClicked;
- (void)greenClicked;
- (void)connectionStateChanged:(BOOL)connected;
- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage;

@end