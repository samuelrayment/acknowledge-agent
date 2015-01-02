//
//  Network.h
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChosenState.h"

@class NetworkMessage;

@protocol NetworkMessageReceiver <NSObject>

- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage;

@end

@interface NetworkMessage : NSObject 

- (instancetype)initWithChosenState:(ChosenState)aChosenState andMessage:(NSString*)aMessage;

@property (readonly) ChosenState chosenState;
@property (strong, nonatomic) NSString *message;

@end

@interface Network : NSObject

- (instancetype)init;

@property (weak, nonatomic) id<NetworkMessageReceiver> delegate;

@end
