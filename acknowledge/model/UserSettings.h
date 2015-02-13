//
//  UserSettings.h
//  Handles persisting user settings to the NSUserDefaults.
//
//  Created by Samuel Rayment on 06/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSettingsDelegate

- (void)settingsUpdated;

@end

@interface UserSettings : NSObject

@property (weak, nonatomic) id<UserSettingsDelegate> delegate;
@property NSString *address;
@property NSString *username;
@property NSString *password;

@end
