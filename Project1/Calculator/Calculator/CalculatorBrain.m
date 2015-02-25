//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andrew Bentley on 2/22/15.
//  Copyright (c) 2015 Andrew Bentley. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@property (nonatomic, strong) NSMutableArray * cleanStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;
@synthesize cleanStack = _cleanStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack)
    {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([@"*" isEqualToString:operation])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"])
    {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    else if ([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    
    [self pushOperand:result];
    
    return result;
}

- (double)performTrigFunction:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"SIN"])
    {
        result = sin([self popOperand]);
    }
    else if ([operation isEqualToString:@"COS"])
    {
        result = cos([self popOperand]);
    }
    
    [self pushOperand:result];
    
    return result;
}

- (double)performSQRT:(NSString *)operation
{
    double result = 0;
    double numberToRoot = [self popOperand];
    
    if (numberToRoot < 0)
    {
        return -1;
    }
    else
    {
        result = sqrt(numberToRoot);
    }
    
    [self pushOperand:result];
    
    return result;
}

- (void)addPiToStack
{
    double PI = 3.1415926535;
    
    [self pushOperand:PI];
}

-(double)negateOperand
{
    double result;
    
    result = [self popOperand] * -1;
    
    [self pushOperand:result];
    
    return result;
}

- (void)clearStack
{
    _cleanStack = NULL;
    _operandStack = _cleanStack;
}

@end
