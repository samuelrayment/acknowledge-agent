//
//  SettingsController.m
//  View controller for the settings view.
//
//  Created by Samuel Rayment on 05/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *addressField;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
- (IBAction)addressFieldUpdated:(id)sender;
- (IBAction)usernameFieldUpdated:(id)sender;
- (IBAction)passwordFieldUpdated:(id)sender;

@end

@implementation SettingsController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
    
    [self.addressField setStringValue:self.settings.address];
    [self.usernameField setStringValue:self.settings.username];
    [self.passwordField setStringValue:self.settings.password];
}

- (void)windowWillClose:(NSNotification *)notification {
    self.settings.address = self.addressField.stringValue;
    self.settings.username = self.usernameField.stringValue;
    self.settings.password = self.passwordField.stringValue;
}

- (IBAction)addressFieldUpdated:(id)sender {
    self.settings.address = self.addressField.stringValue;
}

- (IBAction)usernameFieldUpdated:(id)sender {
    self.settings.username = self.usernameField.stringValue;
}

- (IBAction)passwordFieldUpdated:(id)sender {
    self.settings.password = self.passwordField.stringValue;
}

@end
