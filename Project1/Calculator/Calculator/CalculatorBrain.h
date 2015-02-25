//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Andrew Bentley on 2/23/15.
//  Copyright (c) 2015 Andrew Bentley. All rights reserved.
//

#import "Foundation/Foundation.h"

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (double)performTrigFunction:(NSString *)operation;
- (double)performSQRT:(NSString *)operation;
- (void)addPiToStack;
- (double)negateOperand;
- (void)clearStack;

@end
