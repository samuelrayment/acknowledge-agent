//
//  SettingsController.h
//  View controller for the settings view.
//
//  Created by Samuel Rayment on 05/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserSettings.h"

@interface SettingsController : NSWindowController

@property (strong, nonatomic) UserSettings *settings;

@end
