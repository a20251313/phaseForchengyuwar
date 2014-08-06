//
//  JFSQLManger.m
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFSQLManger.h"
#import "SQLOperation.h"

static JFSQLManger  *shareManger = nil;
@implementation JFSQLManger

+(id)shareInstance
{
    if (!shareManger)
    {
        shareManger = [[JFSQLManger alloc] init];
        [shareManger createTable];
    }
    return shareManger;
}


-(void)createTable
{
    [[SQLOperation sharedSQLOperation] createTable];
}

+(void)closeDB
{
    [SQLOperation closeOperation];
}
+(void)insertToSql:(NSString*)strQuestion answer:(NSString*)strAnswer maintype:(int)mainType subType:(int)subType levelType:(int)leveltype  index:(int)index  typeString:(NSString*)typeString isAnswer:(int)isAnswer
{
    
    JFSQLManger  *instance = [JFSQLManger shareInstance];
    [instance insertToSql:strQuestion answer:strAnswer maintype:mainType subType:subType levelType:leveltype index:index typeString:typeString isAnswer:isAnswer];
}

-(void)insertToSql:(NSString*)strQuestion answer:(NSString*)strAnswer maintype:(int)mainType subType:(int)subType levelType:(int)leveltype  index:(int)index  typeString:(NSString*)typeString isAnswer:(int)isAnswer
{
    [[SQLOperation sharedSQLOperation] insertPuzzleTabel:strQuestion Answer:strAnswer mainType:mainType subType:subType TextType:typeString puzzleIndex:index levelType:leveltype isAnswer:isAnswer];
}


+(int)getMaxIndexFromTablePuzzleTable
{
    return [[JFSQLManger shareInstance] getMaxIndexFromTablePuzzleTable];
}
-(int)getMaxIndexFromTablePuzzleTable
{
    return [[SQLOperation sharedSQLOperation] getMaxIndexINTablePUZZLEINFO];
}

+(BOOL)isHasSameQuestion:(NSString*)strQuestion
{
    return [[JFSQLManger shareInstance] isHasSameQuestion:strQuestion];
}
-(BOOL)isHasSameQuestion:(NSString*)strQuestion
{
    return [[SQLOperation sharedSQLOperation] getIsHasSameQuestion:strQuestion];
}

@end
