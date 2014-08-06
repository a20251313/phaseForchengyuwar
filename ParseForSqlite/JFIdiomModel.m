//
//  JFIdiomModel.m
//  chengyuwar
//
//  Created by ran on 13-12-13.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFIdiomModel.h"
@implementation JFIdiomModel
@synthesize packageIndex;
@synthesize isUnlocked;
@synthesize index;
@synthesize isAnswed;
@synthesize hardType;
@synthesize idiomAnswer;
@synthesize idiomDespcription;
@synthesize idiomImageName;
@synthesize idiomOptionstr;
@synthesize idiomlevelString;
@synthesize idiomExplain;
@synthesize idiomFrom;
@synthesize type;



-(void)dealloc
{
    self.idiomAnswer = nil;
    self.idiomDespcription = nil;
    self.idiomImageName = nil;
    self.idiomlevelString = nil;
    self.idiomOptionstr= nil;
    self.idiomFrom = nil;
    self.idiomExplain = nil;
    [super dealloc];
}

/*
-(NSString*)description
{
    return @"";//[UtilitiesFunction getdescriptionOfobject:self];
}*/
@end
