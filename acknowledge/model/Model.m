//
//  Model.m
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import "Model.h"

@implementation Model

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