//
//  Network.h
//  Handles all networking logic including connecting to the upstream acknowledge server
//  and parsing messages.
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@class NetworkMessage;

/*
 * Delegate for listening to Network changes and messages.
 */
@protocol NetworkDelegate <NSObject>

- (void)networkMessageReceived:(NetworkMessage*)aNetworkMessage;

@end

/*
 * A message received over the network from the upstream acknowledge server.
 */
@interface NetworkMessage : NSObject 

- (instancetype)initWithChosenState:(RAGState)aChosenState andMessage:(NSString*)aMessage;

@property (readonly) RAGState state;
@property (strong, nonatomic) NSString *message;

@end

/*
 * The Network managing class.
 */
@interface Network : NSObject

- (instancetype)init;

@property (weak, nonatomic) id<NetworkDelegate> delegate;

@end
