//
//  Network.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import <GCDAsyncSocket.h>

@interface Network ()

@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;
@property (nonatomic) bool connected;

@end

@implementation Network

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNetwork];
        _connected = NO;
    }
    return self;
}

- (void)setupNetwork {
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                  delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    
    uint16_t port = 9988;
    
    if (![self.asyncSocket connectToHost:@"localhost" onPort:port error:&error])
    {
        NSLog(@"Unable to connect to due to invalid configuration: %@", error);
    }
    else
    {
        NSLog(@"Connecting to \"%@\" on port %hu...", @"localhost", port);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    self.connected = YES;
    [self.delegate connectionStateChanged:self.connected];
    NSData *responseTerminatorData = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    [self.asyncSocket readDataToData:responseTerminatorData withTimeout:1000 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    self.connected = NO;
    [self.delegate connectionStateChanged:self.connected];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSError *e = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSLog(@"Dict: %@", json);
        
        RAGState state;
        if ([json[@"status"] isEqualToString:@"R"]) {
            state = Red;
        } else if ([json[@"status"] isEqualToString:@"A"]) {
            state = Amber;
        } else {
            state = Green;
        }
        
        NetworkMessage *message = [[NetworkMessage alloc]
                                   initWithChosenState:state andMessage:@"Test"];
        [self.delegate networkMessageReceived:message];
    }
    
    NSData *responseTerminatorData = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    [self.asyncSocket readDataToData:responseTerminatorData withTimeout:1000 tag:0];
}

@end

@implementation NetworkMessage

- (instancetype)initWithChosenState:(RAGState)aChosenState andMessage:(NSString*)aMessage {
    self = [super init];
    if (self) {
        _state = aChosenState;
        _message = aMessage;
    }
    return self;
}

@end

