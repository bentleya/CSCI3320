//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Bentley, Andrew on 1/29/15.
//  Copyright (c) 2015 Andrew Bentley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;

@end
