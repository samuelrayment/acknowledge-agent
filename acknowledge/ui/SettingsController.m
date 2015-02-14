//
//  SettingsController.m
//  View controller for the settings view.
//
//  Created by Samuel Rayment on 05/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController () <NSWindowDelegate>

@property (weak) IBOutlet NSButtonCell *notificationUpdatedField;
@property (weak) IBOutlet NSTextField *addressField;
- (IBAction)addressFieldUpdated:(id)sender;
- (IBAction)notificationEnabledUpdated:(id)sender;

@end

@implementation SettingsController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
    
    [self.addressField setStringValue:self.settings.address];
    [self.notificationUpdatedField setState:self.settings.notificationsEnabled];
}

- (void)windowWillClose:(NSNotification *)notification {
    self.settings.address = self.addressField.stringValue;
    self.settings.notificationsEnabled = self.notificationUpdatedField.state;
}

- (IBAction)addressFieldUpdated:(id)sender {
    self.settings.address = self.addressField.stringValue;
}

- (IBAction)notificationEnabledUpdated:(id)sender {
    self.settings.notificationsEnabled = self.notificationUpdatedField.state;
}

@end
