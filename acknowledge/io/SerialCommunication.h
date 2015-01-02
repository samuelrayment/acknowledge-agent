//
//  SerialCommunication.h
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChosenState.h"

@protocol SerialCommunicationDelegate

- (void)connectionStateChanged:(BOOL)connected;

@end

@interface SerialCommunication : NSObject

- (NSString*)connectToDevice:(NSString*)deviceName;
- (void)discover;
- (void)sendColor:(ChosenState)state;

@property (weak, nonatomic) id<SerialCommunicationDelegate> delegate;
@property (readonly) BOOL connected;

@end