//
//  SerialCommunication.h
//  Handles all communication with the Arduino peripheral
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@protocol SerialCommunicationDelegate

- (void)serialConnectionStateChanged:(BOOL)connected;

@end

/**
 * The serial communication handler responsible for sending messages to the Arduino
 * acknowledge notifier.
 */
@interface SerialCommunication : NSObject

- (NSString*)connectToDevice:(NSString*)deviceName;
- (void)discover;
- (void)sendColor:(RAGState)state;

@property (weak, nonatomic) id<SerialCommunicationDelegate> delegate;
@property (readonly) BOOL connected;

@end