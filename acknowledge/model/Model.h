//
//  Model.h
//  acknowledge
//
//  Created by Samuel Rayment on 02/01/2015.
//  Copyright (c) 2015 Samuel Rayment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@end

typedef NS_ENUM(NSInteger, RAGState) {
    Red,
    Amber,
    Green,
    Disconnected
};

NSString *RAGStateToString(RAGState state);
RAGState RAGStateFromString(NSString *stringState);

char RAGStateToChar(RAGState state);