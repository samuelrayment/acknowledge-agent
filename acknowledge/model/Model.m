//
//  Model.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "Model.h"

@interface Model ()

@end

@implementation Model

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

NSString *RAGStateToString(RAGState state) {
    switch (state) {
        case Red:
            return @"Red";
        case Amber:
            return @"Amber";
        case Green:
            return @"Green";
    }
}

RAGState RAGStateFromString(NSString *stringState) {
    static NSDictionary* RAGStateLookup = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RAGStateLookup = @{
            @"Red": @(Red),
            @"Green": @(Green),
            @"Amber": @(Amber)
       };
    });
    
    return [RAGStateLookup[stringState] integerValue];
}

char RAGStateToChar(RAGState state) {
    switch (state) {
        case Red:
            return 'R';
        case Amber:
            return 'A';
        case Green:
            return 'G';
    }
}