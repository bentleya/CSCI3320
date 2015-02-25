//
//  ViewController.m
//  Calculator
//
//  Created by Andrew Bentley on 2/22/15.
//  Copyright (c) 2015 Andrew Bentley. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic) BOOL userHasEnterAPeriod;
@property (nonatomic) BOOL operationFinished;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableArray *displayOrder;
@end

@implementation ViewController

@synthesize display;
@synthesize fullDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber;
@synthesize userHasEnterAPeriod = _userHasEnterAPeriod;
@synthesize operationFinished = _operationFinished;
@synthesize brain = _brain;
@synthesize displayOrder = _displayOrder;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSMutableArray *)displayOrder
{
    if (!_displayOrder) _displayOrder =[[NSMutableArray alloc] init];
    return _displayOrder;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    if (self.operationFinished)
    {
        self.fullDisplay.text = self.display.text;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
        _operationFinished = NO;
    }
    
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:digit];
        [self.displayOrder addObject:self.display.text];
    }
    else
    {
        self.display.text = digit;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:digit];
        [self.displayOrder addObject:self.display.text];
        userIsInTheMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    _userHasEnterAPeriod = NO;
    [self.displayOrder removeAllObjects];
}


- (IBAction)operationPressed:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:operation];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"= "];
    _operationFinished = YES;
}

- (IBAction)periodPressed:(id)sender
{
    if(self.userHasEnterAPeriod)
    {
        return;
    }
    
    if (!self.userIsInTheMiddleOfEnteringNumber)
    {
        self.display.text = @"0.";
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"0."];
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
    else if (self.userIsInTheMiddleOfEnteringNumber)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"."];
    }
    
    _userHasEnterAPeriod = YES;
}

- (IBAction)trigFunctionPressed:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    
    if (self.operationFinished)
    {
        self.fullDisplay.text = self.display.text;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
        _operationFinished = NO;
    }
    
    NSString *operation = [sender currentTitle];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:operation];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
    double result = [self.brain performTrigFunction:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"= "];
    _operationFinished = YES;
}

- (IBAction)sqrtPressed:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    
    if (self.operationFinished)
    {
        self.fullDisplay.text = self.display.text;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
        _operationFinished = NO;
    }
    
    NSString *operation = [sender currentTitle];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:operation];
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
    _operationFinished = YES;
    double result = [self.brain performSQRT:operation];
    if (result == -1)
    {
        self.fullDisplay.text = @"ERR";
        self.display.text = @"ERR";
    }
    else
    {
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"= "];
    }
    
    _operationFinished = YES;
}

- (IBAction)piPressed
{
    if (self.operationFinished)
    {
        self.fullDisplay.text = self.display.text;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
        _operationFinished = NO;
    }
    
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        [self enterPressed];
    }
    
    [self.brain addPiToStack];
    
    self.display.text = @"π";
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"π "];
}

- (IBAction)clearPressed
{
    self.userIsInTheMiddleOfEnteringNumber = NO;
    _userHasEnterAPeriod = NO;
    _operationFinished = NO;
    self.display.text = @"0";
    self.fullDisplay.text = @"";
    [self.brain clearStack];
}

- (IBAction)backPressed
{
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"<-"];
    if (_displayOrder)
    {
        [self.displayOrder removeLastObject];
        self.display.text = [self.displayOrder lastObject];
    }
    else
    {
        self.display.text = @"0";
    }
}

- (IBAction)signChangePressed
{
    self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@"+/- "];
    
    if (self.operationFinished)
    {
        self.fullDisplay.text = self.display.text;
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" "];
        _operationFinished = NO;
    }
    
    if (self.userIsInTheMiddleOfEnteringNumber)
    {
        double negation;
        
        negation = [self.display.text doubleValue] * -1;
        
        self.display.text = [NSString stringWithFormat:@"%g", negation];
    }
    
    else
    {
        double negation = [self.brain negateOperand];
        self.display.text = [NSString stringWithFormat:@"%g", negation];
        self.fullDisplay.text = [self.fullDisplay.text stringByAppendingString:@" ="];
        _operationFinished = YES;
    }
}


@end
