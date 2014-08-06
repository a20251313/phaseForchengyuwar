//
//  JFSQLManger.h
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFSQLManger : NSObject


+(void)insertToSql:(NSString*)strQuestion answer:(NSString*)strAnswer maintype:(int)mainType subType:(int)subType levelType:(int)leveltype  index:(int)index  typeString:(NSString*)typeString isAnswer:(int)isAnswer;
+(int)getMaxIndexFromTablePuzzleTable;
+(BOOL)isHasSameQuestion:(NSString*)strQuestion;
+(void)closeDB;
@end
