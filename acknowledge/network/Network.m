//
//  Network.m
//  Handles all networking logic including connecting to the upstream acknowledge server
//  and parsing messages.
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
@property (nonatomic) int retries;
@property (nonatomic) float backOffRate;
@property (nonatomic) float maxBackOff;

@end

@implementation Network

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNetwork];
        _connected = NO;
        _backOffRate = 1;
        _maxBackOff = 20;
        _retries = 0;
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
    self.retries = 0;
    [self.delegate connectionStateChanged:self.connected];
    NSData *responseTerminatorData = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    [self.asyncSocket readDataToData:responseTerminatorData withTimeout:1000 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Disconnected");
    self.connected = NO;
    [self.delegate connectionStateChanged:self.connected];
    self.retries++;
    NSLog(@"Retries: %d", self.retries);
    int retryTime = MIN(self.retries * self.backOffRate, self.maxBackOff);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, retryTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self setupNetwork];
    });
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
        
        NetworkMessage *message = [[NetworkMessage alloc] initFromBuildInfo:json];
        [self.delegate networkMessageReceived:message];
    }
    
    NSData *responseTerminatorData = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    [self.asyncSocket readDataToData:responseTerminatorData withTimeout:1000 tag:0];
}

@end

@interface NetworkMessage ()

@property (strong, nonatomic) NSDictionary *failingBuilds;
@property (strong, nonatomic) NSDictionary *acknowledgedBuilds;
@property (strong, nonatomic) NSDictionary *healthyBuilds;

@end

@implementation NetworkMessage

- (instancetype)initFromBuildInfo:(NSDictionary *)buildInfo {
    self = [super init];
    if (self) {
        _failingBuilds = buildInfo[@"failing"];
        _acknowledgedBuilds = buildInfo[@"acknowledged"];
        _healthyBuilds = buildInfo[@"healthy"];
    }
    return self;
}

- (RAGState)state {
    if ([self.failingBuilds count] > 0) {
        return Red;
    } else if ([self.acknowledgedBuilds count] > 0) {
        return Amber;
    } else {
        return Green;
    }
}

@end

