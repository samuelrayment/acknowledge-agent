//
//  Menu.h
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@protocol MenuDelegate

- (void)redClicked;
- (void)amberClicked;
- (void)greenClicked;

@end

@interface Menu : NSObject

- (instancetype)init;

@property (weak) id<MenuDelegate>delegate;
@property (nonatomic) RAGState chosenState;
@property (nonatomic) BOOL active;

@end