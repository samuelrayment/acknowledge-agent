//
//  UserSettings.m
//  Handles persisting user settings to the NSUserDefaults.
//
//  Created by Samuel Rayment on 06/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

@import Foundation;
#import "UserSettings.h"

@interface UserSettings ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation UserSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSString*)address {
    NSString *val = [self.userDefaults stringForKey:@"address"];
    return val;
}

- (void)setAddress:(NSString *)address {
    [self.userDefaults setObject:address forKey:@"address"];
    [self.userDefaults synchronize];
    [self.delegate addressUpdated];
}

- (BOOL)notificationsEnabled {
    return [self.userDefaults boolForKey:@"notificationsEnabled"];
}

- (void)setNotificationsEnabled:(BOOL)notificationsEnabled {
    [self.userDefaults setBool:notificationsEnabled forKey:@"notificationsEnabled"];
    [self.userDefaults synchronize];
    [self.delegate notificationsEnabledUpdated];
}

@end
