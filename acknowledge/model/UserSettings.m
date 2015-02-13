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
    [self.delegate settingsUpdated];
}

- (NSString*)username {
    NSString *val = [self.userDefaults stringForKey:@"username"];
    return val;
}

- (void)setUsername:(NSString *)username {
    [self.userDefaults setObject:username forKey:@"username"];
    [self.userDefaults synchronize];
    [self.delegate settingsUpdated];
}

- (NSString*)password {
    NSString *val = [self.userDefaults stringForKey:@"password"];
    return val;
}

- (void)setPassword:(NSString *)password {
    [self.userDefaults setObject:password forKey:@"password"];
    [self.userDefaults synchronize];
    [self.delegate settingsUpdated];
}

@end
