//
//  Menu.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Menu.h"

@interface Menu ()

@property (strong, readonly) NSStatusItem *statusItem;
@property (strong) NSMutableArray *menuItems;

@end

@implementation Menu

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _menuItems = [[NSMutableArray alloc] init];
        _chosenState = Red;
        [self setupSystemBar];
        self.active = NO;
    }
    return self;
}

- (void)setupSystemBar {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    _statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:[NSImage imageNamed:@"acknowledge_no_network"]];
    [_statusItem setHighlightMode:YES];
    
    NSMenu *myMenu = [[NSMenu alloc] initWithTitle:@"Test"];
    [self createMenuItemForMenu:myMenu withName:@"Red" withKeyEquivilent:@"r" withChosenState:Red withIndex:0];
    [self createMenuItemForMenu:myMenu withName:@"Amber" withKeyEquivilent:@"a" withChosenState:Amber withIndex:1];
    [self createMenuItemForMenu:myMenu withName:@"Green" withKeyEquivilent:@"g" withChosenState:Green withIndex:2];
    [self createSettingsItemForMenu:myMenu atIndex:3];
    [self createQuitItemForMenu:myMenu atIndex:4];
    [_statusItem setMenu:myMenu];
}

- (void)createMenuItemForMenu:(NSMenu*)menu withName:(NSString*)aName withKeyEquivilent:(NSString*)keyEquivilent
              withChosenState:(RAGState)aChosenState withIndex:(NSUInteger)index {
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:aName action:@selector(itemSelected:) keyEquivalent:keyEquivilent];
    menuItem.tag = aChosenState;
    menuItem.enabled = NO;
    [self.menuItems addObject:menuItem];
    [menu insertItem:menuItem atIndex:index];
    if (aChosenState == self.chosenState) {
        menuItem.state = NSOnState;
    }
}

- (void)createSettingsItemForMenu:(NSMenu*)menu atIndex:(NSUInteger)index {
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Settings" action:@selector(settingsSelected) keyEquivalent:@","];
    menuItem.enabled = YES;
    menuItem.target = self;
    [menu insertItem:menuItem atIndex:index];
}

- (void)createQuitItemForMenu:(NSMenu*)menu atIndex:(NSUInteger)index {
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitSelected) keyEquivalent:@"q"];
    menuItem.enabled = YES;
    menuItem.target = self;
    [menu insertItem:menuItem atIndex:index];
}

- (void)itemSelected:(NSMenuItem*)sender {
    [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMenuItem* menuItem = (NSMenuItem*)obj;
        menuItem.state = NSOffState;
    }];
    sender.state = NSOnState;
    switch (sender.tag) {
        case Red:
            [self.delegate redClicked];
            self.chosenState = Red;
            break;
        case Amber:
            [self.delegate amberClicked];
            self.chosenState = Amber;
            break;
        case Green:
            [self.delegate greenClicked];
            self.chosenState = Green;
            break;
    }
}

- (void)settingsSelected {
    [self.delegate settingsClicked];
}

- (void)quitSelected {
    [self.delegate quitClicked];
}

- (void)setActive:(BOOL)active {
    _active = active;
    id target = (active) ? self : nil;
    [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMenuItem* menuItem = (NSMenuItem*)obj;
        [menuItem setTarget:target];
    }];
}

- (void)setNetworkState:(RAGState)networkState {
    _networkState = networkState;
    NSString *imageName;
    switch (networkState) {
        case Red:
            imageName = @"acknowledge_red";
            break;
        case Amber:
            imageName = @"acknowledge_amber";
            break;
        case Green:
            imageName = @"acknowledge_green";
            break;
    }
    [self.statusItem setImage:[NSImage imageNamed:imageName]];
}

@end
