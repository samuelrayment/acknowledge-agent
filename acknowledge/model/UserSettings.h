//
//  UserSettings.h
//  Handles persisting user settings to the NSUserDefaults.
//
//  Created by Samuel Rayment on 06/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettings : NSObject

@property NSString *address;
@property NSString *username;
@property NSString *password;

@end
