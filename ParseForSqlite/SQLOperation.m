//
//  SQLOperation.m
//  I366_V1_4
//
//  Created by  on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SQLOperation.h"

#define kDatabaseName @"idiomInfo.db"

@implementation SQLOperation
@synthesize dbQueue = _dbQueue;

static SQLOperation *operation = nil;

- (NSString *)databaseFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString    *strFilePath =  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strFilePath])
    {
       BOOL bsuc =  [[NSFileManager defaultManager] createFileAtPath:strFilePath contents:nil attributes:nil];
        if (!bsuc)
        {
            DLOG(@"databaseFilePath create fail:%@",strFilePath);
        }
    }
	return strFilePath;
}

- (void)openDatabase
{
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
}

- (void)closeDatabase
{
    
}

- (id)init
{
    if (operation) {
        return operation;
    }else {
        
        self = [super init];
        
        if (self) {
            
        }
        
        return self;
    }
    
}

+ (SQLOperation *)sharedSQLOperation
{
    if (!operation)
    {
        operation = [[SQLOperation alloc] init];
        [operation openDatabase];
    }
    
    return operation;
}

+ (void)closeOperation
{
    if (operation) {
        [operation closeDatabase];
        [operation dealloc];
        operation = nil;
    }
}

- (void)dealloc
{
    database = NULL;
    self.dbQueue = nil;
    
    [super dealloc];
}


- (void)createTable
{
//    [self createUserInfoTabel];
//    [self createIdiomInfoTabel];
//    [self createGameCenterAndUserIDtable];
//    [self createRoleLockInfoTable];
//    [self createChargeUnDealTable];
//    [self createUnlockPurchaseTable];
    [self createPuzzleTabel];
    [self createIdiomTabel];
}


#pragma mark puzzles

- (void)createPuzzleTabel
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createPuzzleTabel  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS PUZZLEINFO(ID INTEGER PRIMARY KEY, QUESTION TEXT,ANSWER TEXT,PUZZLEMAINTYPE INT,PUZZLESUBTYPE INT,PUZZLETEXTTYPE TEXT,PUZZLEINDEX INT,LEVELTYPE INT,ISANSWER INT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createPuzzleTabel fail:%@",createSQL);
         };
         if (![db close])
         {
             
             DLOG(@"createPuzzleTabel  close fail");
         }
         
         
     }];
}
- (void)createIdiomTabel
{
    return;
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createIdiomTabel  open fail");
         }

         
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS IDIOMINFOTABLE(ID INTEGER PRIMARY KEY, IDIOMINDEX INT,HARDTYPE INT,IMAGEPATH TEXT,ANSWER TEXT,OPTIONSTR TEXT,IDIOMFROM TEXT,EXPLAIN TEXT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createIdiomTabel fail:%@",createSQL);
         };
         if (![db close])
         {
             
             DLOG(@"createIdiomTabel  close fail");
         }
         
         
     }];
}
-(void)insertIdiomTabelTabel:(int)index hardType:(int)hardType imagePath:(NSString*)imagePath Answer:(NSString*)answer optionStr:(NSString*)optionStr from:(NSString*)strFrom
                     Explain:(NSString*)explain
{
    

    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertPuzzleTabel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into IDIOMINFOTABLE(IDIOMINDEX, HARDTYPE, IMAGEPATH, ANSWER, OPTIONSTR, IDIOMFROM,EXPLAIN) values('%d','%d','%@', '%@', '%@', '%@','%@')",index,hardType,imagePath,answer,optionStr,strFrom,explain];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"insertIdiomTabelTabel:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToUSERINFO  close fail");
        }
        
    }];
    
}



-(void)insertPuzzleTabel:(NSString*)strQuestion Answer:(NSString*)strAnswer mainType:(int)mainType subType:(int)subType
                TextType:(NSString*)strTextType puzzleIndex:(int)index levelType:(int)leveltype isAnswer:(int)isAnswer
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertPuzzleTabel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into PUZZLEINFO(QUESTION, ANSWER, PUZZLEMAINTYPE, PUZZLESUBTYPE, PUZZLETEXTTYPE, PUZZLEINDEX,LEVELTYPE,ISANSWER) values('%@','%@','%d', '%d', '%@', %d,%d,%d)",strQuestion,strAnswer,mainType,subType,strTextType,index,leveltype,isAnswer];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"executeUpdate:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToUSERINFO  close fail");
        }
        
    }];
    
}


-(int)getMaxIndexINTablePUZZLEINFO
{


    __block int maxIndex = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select MAX(PUZZLEINDEX) from PUZZLEINFO"];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
   
            maxIndex = [rs intForColumnIndex:0];
         
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return maxIndex;

}


-(BOOL)getIsHasSameQuestion:(NSString*)strQuestion
{
    
    
    __block int maxIndex = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select count from PUZZLEINFO where QUESTION='%@'",strQuestion];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            maxIndex = [rs intForColumnIndex:0];
            
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return maxIndex;
    
}


#pragma mark  UserInfo  table
/**********************用户信息表*********************************/
- (void)createUserInfoTabel
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createUserInfoTabel  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS USERINFO(ID INTEGER PRIMARY KEY, USERID TEXT,USERIDTYPE INT,LASTLOGINTIME TEXT, USERNICKNAME TEXT,ROLETYPE INT,WINCOUNT INT,LOSECOUNT INT,GOLDNUMBER INT,SCORE INT,MAXCONWINNUMBER INT,GAMECENTERID TEXT,GAMECENTERDISPLAYNAME TEXT,LASTBEATLEVEL INT,ISPAYEDUSER  INT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createUserInfoTabel fail");
         };
         if (![db close])
         {
             
             DLOG(@"createUserInfoTabel  close fail");
         }
         
         
     }];
}

-(void)insertToUSERINFO:(NSString*)userID userIDType:(int)userIDType lastLogintime:(NSString*)timeInter nickName:(NSString*)nickName roletype:(int)roleType winConut:(int)wincount
              losecount:(int)loseCount goldNumber:(int)goldNumber score:(int)score maxconwinnumber:(int)maxconnumber gamecenterID:(NSString*)gamecenterID gameCenterDisplayName:(NSString*)gamedisplayname LastBeatleatLevel:(int)lastBeatleatLevel ispayedUser:(int)isPayed
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToUSERINFO  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into USERINFO(USERID, USERIDTYPE, LASTLOGINTIME, USERNICKNAME, ROLETYPE, WINCOUNT, LOSECOUNT, GOLDNUMBER, SCORE,MAXCONWINNUMBER, GAMECENTERID, GAMECENTERDISPLAYNAME, LASTBEATLEVEL,ISPAYEDUSER) values('%@', %d, '%@', '%@', %d, %d, %d, %d, %d, %d,'%@','%@',%d,%d)",userID,userIDType,timeInter,nickName,roleType,wincount,loseCount,goldNumber,score,maxconnumber,gamecenterID,gamedisplayname,lastBeatleatLevel,isPayed];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"executeUpdate:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToUSERINFO  close fail");
        }
        
    }];
    
}



- (NSMutableArray *)queryAllUserInfo
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from USERINFO"];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            NSString    *userID = [rs stringForColumnIndex:1];
            int userIDType = [rs intForColumnIndex:2];
            NSString *lastLogintime = [rs stringForColumnIndex:3];
            NSString *nickName = [rs stringForColumnIndex:4];
            int roleType = [rs intForColumnIndex:5];
            int wincount = [rs intForColumnIndex:6];
            int losecount = [rs intForColumnIndex:7];
            int goldnumber = [rs intForColumnIndex:8];
            int score = [rs intForColumnIndex:9];
            int  maxconwinnumber = [rs intForColumnIndex:10];
            NSString  *GameCenterID = [rs stringForColumnIndex:11];
            NSString  *gamedisplayname = [rs stringForColumnIndex:12];
            int lastBeatLevel = [rs intForColumnIndex:13];
            int ispayed = [rs intForColumnIndex:14];
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(userIDType),@"userIDType",lastLogintime,@"lastLogintime",nickName,@"nickName",@(roleType),@"roleType",@(wincount),@"wincount",@(losecount),@"losecount",@(goldnumber),@"goldnumber",@(score),@"score",@(maxconwinnumber),@"maxconwinnumber",GameCenterID,@"GameCenterID",gamedisplayname,@"gamedisplayname",@(lastBeatLevel),@"lastBeatLevel",userID,@"userID",@(ispayed),@"ispayed",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}


- (NSMutableArray *)queryUserInfoByUserID:(int)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from USERINFO where USERID='%@'",[NSString stringWithFormat:@"%d",userID]];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            int userIDType = [rs intForColumnIndex:2];
            NSString *lastLogintime = [rs stringForColumnIndex:3];
            NSString *nickName = [rs stringForColumnIndex:4];
            int roleType = [rs intForColumnIndex:5];
            int wincount = [rs intForColumnIndex:6];
            int losecount = [rs intForColumnIndex:7];
            int goldnumber = [rs intForColumnIndex:8];
            int score = [rs intForColumnIndex:9];
            int  maxconwinnumber = [rs intForColumnIndex:10];
            NSString  *GameCenterID = [rs stringForColumnIndex:11];
            NSString  *gamedisplayname = [rs stringForColumnIndex:12];
            int lastBeatLevel = [rs intForColumnIndex:13];
            int isPayed = [rs intForColumnIndex:14];
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(userIDType),@"userIDType",lastLogintime,@"lastLogintime",nickName,@"nickName",@(roleType),@"roleType",@(wincount),@"wincount",@(losecount),@"losecount",@(goldnumber),@"goldnumber",@(score),@"score",@(maxconwinnumber),@"maxconwinnumber",GameCenterID,@"GameCenterID",gamedisplayname,@"gamedisplayname",@(lastBeatLevel),@"lastBeatLevel",@(isPayed),@"ispayed",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}




// NSString *createSQL = @"CREATE TABLE IF NOT EXISTS USERINFO(ID INTEGER PRIMARY KEY, USERID TEXT,USERIDTYPE INT,LASTLOGINTIME TEXT, USERNICKNAME TEXT,ROLETYPE INT,WINCOUNT INT,LOSECOUNT INT,GOLDNUMBER INT,SCORE INT,MAXCONWINNUMBER INT,GAMECENTERID TEXT,GAMECENTERDISPLAYNAME TEXT,LASTBEATLEVEL INT,ISPAYEDUSER  INT)";
-(void)UpdateUSERINFO:(NSString*)userID userIDType:(int)userIDType lastLogintime:(NSString*)timeInter nickName:(NSString*)nickName roletype:(int)roleType winConut:(int)wincount
            losecount:(int)loseCount goldNumber:(int)goldNumber score:(int)score maxconwinnumber:(int)maxconnumber gamecenterID:(NSString*)gamecenterID gameCenterDisplayName:(NSString*)gamedisplayname LastBeatleatLevel:(int)lastBeatleatLevel isPayed:(int)isPayed
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateUSERINFO  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update USERINFO set USERIDTYPE='%d',LASTLOGINTIME='%@',USERNICKNAME='%@',ROLETYPE='%d',WINCOUNT='%d',LOSECOUNT='%d',GOLDNUMBER='%d',SCORE='%d',MAXCONWINNUMBER='%d',GAMECENTERID='%@',GAMECENTERDISPLAYNAME='%@',LASTBEATLEVEL=%d,ISPAYEDUSER=%d  WHERE USERID='%@';",userIDType,timeInter,nickName,roleType,wincount,loseCount,goldNumber,score,maxconnumber,gamecenterID,gamedisplayname,lastBeatleatLevel,isPayed,userID];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             DLOG(@"UpdateUSERINFO success");
         }else
         {
             DLOG(@"UpdateUSERINFO fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             DLOG(@"insertToUSERINFO  close fail");
         }
     }];
    
}

-(void)UpdateUSERINFO:(NSString*)userID GoldNumber:(int)goldnumber
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateUSERINFO  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update USERINFO set GOLDNUMBER='%d' WHERE USERID='%@';",goldnumber,userID];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             DLOG(@"UpdateUSERINFO success");
         }else
         {
             DLOG(@"UpdateUSERINFO fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"insertToUSERINFO  close fail");
         }
     }];
    
}
-(void)UpdateUSERINFO:(NSString*)userID levelNumber:(int)levelnumber
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateUSERINFO  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update USERINFO set LASTBEATLEVEL='%d' WHERE USERID='%@';",levelnumber,userID];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             DLOG(@"UpdateUSERINFO success");
         }else
         {
             DLOG(@"UpdateUSERINFO fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"insertToUSERINFO  close fail");
         }
     }];
    
}



/**********************成语题目表*********************************/
- (void)createIdiomInfoTabel
{
    
    //IDIOMTYPE 1 为闯关类型题目       2为竞赛题目类型
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createIdiomInfoTabel  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS  IDIOMINFO(ID INTEGER PRIMARY KEY, PACKAGEINDEX INT,SECONDINDEX INT,LEVELINDEX INT, IDIOMANSWER TEXT,IDIOMOPTIONSTR TEXT,ISANSWERED INT,IDIOMTYPE INT,IDIOMEXPLAIN TEXT,IDIOMSOURCE  TEXT,IDIOMPICNAME TEXT,ISUNLOCKED  INT,USERID TEXT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createIdiomInfoTabel fail");
         };
         if (![db close])
         {
             
             DLOG(@"createIdiomInfoTabel  close fail");
         }
         
         
     }];
}

-(void)insertToIdiom:(int)packageindex secondIndex:(int)index levelIndex:(int)levelIndex answer:(NSString*)strAnswer optionStr:(NSString*)optionStr IsAnswer:(int)isAnswer
                Type:(int)type explain:(NSString*)explain source:(NSString*)source picName:(NSString*)picName isUnlock:(BOOL)isUnlocked userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToIdiom  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into IDIOMINFO(ID, PACKAGEINDEX, SECONDINDEX, LEVELINDEX, IDIOMANSWER, IDIOMOPTIONSTR, ISANSWERED, IDIOMTYPE, IDIOMEXPLAIN,IDIOMSOURCE,IDIOMPICNAME,ISUNLOCKED,USERID) values(NULL,%d, %d, %d, '%@', '%@', %d, %d, '%@', '%@','%@',%d,'%@')",packageindex,index,levelIndex,strAnswer,optionStr,isAnswer,type,explain,source,picName,isUnlocked,userID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"insertToIdiom:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToIdiom  close fail");
        }
        
    }];
    
}






-(void)UpdateIdiom:(int)packageindex secondIndex:(int)index levelIndex:(int)levelIndex answer:(NSString*)strAnswer optionStr:(NSString*)optionStr IsAnswer:(int)isAnswer
              Type:(int)type explain:(NSString*)explain source:(NSString*)source picName:(NSString*)picName isUnlock:(BOOL)isUnlocked userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [self.dbQueue inDatabase:^(FMDatabase *db)
         {
             
             if (![db open])
             {
                 DLOG(@"UpdateIdiom  open fail");
             }
             
             NSString *updateSql = [[NSString alloc] initWithFormat:@"update IDIOMINFO set PACKAGEINDEX='%d',SECONDINDEX =%d,IDIOMANSWER='%@',IDIOMOPTIONSTR='%@',ISANSWERED=%d,IDIOMTYPE='%d',IDIOMEXPLAIN='%@',IDIOMSOURCE='%@' IDIOMPICNAME='%@' ISUNLOCKED=%d,WHERE LEVELINDEX=%d and userID='%@';",packageindex,index,strAnswer,optionStr,isAnswer,type,explain,source,picName,isUnlocked,levelIndex,userID];
             
             [db beginTransaction];
             
             
             if ([db executeUpdate:updateSql])
             {
                 DLOG(@"UpdateIdiom success");
             }else
             {
                 DLOG(@"UpdateIdiom fail:%@",updateSql);
             }
             
             
             [db commit];
             
             [updateSql release];
             
             if (![db close])
             {
                 DLOG(@"UpdateIdiom  close fail");
             }
         }];
        
    }];
    
}


/**
 *
 *
 *  @param type 1 为闯关类型 2为竞赛
 *
 *  @return 查询到的题目
 */
- (NSMutableArray *)queryIdiomInfoAccordType:(int)type userID:(NSString*)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = nil;
        
        if (type == 1)
        {
            query =  [[NSString alloc] initWithFormat: @"select * from IDIOMINFO WHERE IDIOMTYPE=%d and  userID='%@'",type,userID];
        }else if (type == 2)
        {
            query =  [[NSString alloc] initWithFormat: @"select * from IDIOMINFO WHERE IDIOMTYPE=%d",type];
        }
        
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            int packgeindex = [rs intForColumnIndex:1];
            int secondIndex = [rs intForColumnIndex:2];
            int levelIndex = [rs intForColumnIndex:3];
            NSString  *idiomAnswer = [rs stringForColumnIndex:4];
            NSString  *idiomOptstr = [rs stringForColumnIndex:5];
            int  isAnswer = [rs intForColumnIndex:6];
            int  ididomType = [rs intForColumnIndex:7];
            NSString  *idiomExplain = [rs stringForColumnIndex:8];
            NSString  *idiomSorce = [rs stringForColumnIndex:9];
            NSString  *idiomPicName = [rs stringForColumnIndex:10];
            int     isUnlocked = [rs intForColumnIndex:11];
            
            
            
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(packgeindex),@"packgeindex",@(secondIndex),@"secondIndex",@(levelIndex),@"levelIndex",idiomAnswer,@"idiomAnswer",idiomOptstr,@"idiomOptstr",@(isAnswer),@"isAnswer",@(ididomType),@"ididomType",idiomExplain,@"idiomExplain",idiomSorce,@"idiomSorce",idiomPicName,@"idiomPicName",@(isUnlocked),@"isUnlocked",idiomSorce,@"idiomFrom",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return array;
}




/**
 *
 *
 *  @param type 1 为闯关类型 2为竞赛
 *
 *  @return 查询到的题目总数
 */
- (int )queryIdiomCountAccordType:(int)type userID:(NSString*)userID  index:(int)index packageIndex:(int)packageindex
{
    __block int count = 0;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = nil;
        
        if (type == 1)
        {
            query =  [[NSString alloc] initWithFormat: @"select count(*) from IDIOMINFO WHERE IDIOMTYPE=%d and  userID='%@' and SECONDINDEX=%d and PACKAGEINDEX=%d",type,userID,index,packageindex];
        }else if (type == 2)
        {
            query =  [[NSString alloc] initWithFormat: @"select count(*) from IDIOMINFO WHERE IDIOMTYPE=%d and SECONDINDEX=%d and PACKAGEINDEX=%d",type,index,packageindex];
        }
        
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            count = [rs intForColumnIndex:0];
            DLOG(@"queryIdiomCountAccordType:%d",count);
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return count;
}

/**
 *
 *
 *  @param type 1 为闯关类型 2为竞赛
 *
 *  @return 查询到的题目总数
 */
- (int )queryIdiomCountAccordType:(int)type userID:(NSString*)userID
{
    __block int count = 0;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = nil;
        
        if (type == 1)
        {
            query =  [[NSString alloc] initWithFormat: @"select count(*) from IDIOMINFO WHERE IDIOMTYPE=%d and  userID='%@'",type,userID];
        }else if (type == 2)
        {
            query =  [[NSString alloc] initWithFormat: @"select count(*) from IDIOMINFO WHERE IDIOMTYPE=%d",type];
        }
        
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            count = [rs intForColumnIndex:0];
            DLOG(@"queryIdiomCountAccordType:%d",count);
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    return count;
}


- (NSMutableArray *)queryIdiomInfoAccordLevelIndex:(int)llevelIndex userID:(NSString*)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from IDIOMINFO WHERE PACKAGEINDEX=%d and USERID='%@'",llevelIndex,userID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             int packgeindex = [rs intForColumnIndex:1];
             int secondIndex = [rs intForColumnIndex:2];
             int levelIndex = [rs intForColumnIndex:3];
             NSString  *idiomAnswer = [rs stringForColumnIndex:4];
             NSString  *idiomOptstr = [rs stringForColumnIndex:5];
             int  isAnswer = [rs intForColumnIndex:6];
             int  ididomType = [rs intForColumnIndex:7];
             NSString  *idiomExplain = [rs stringForColumnIndex:8];
             NSString  *idiomSorce = [rs stringForColumnIndex:9];
             NSString  *idiomPicName = [rs stringForColumnIndex:10];
             int     isUnlocked = [rs intForColumnIndex:11];
             
             
             
             
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(packgeindex),@"packgeindex",@(secondIndex),@"secondIndex",@(levelIndex),@"levelIndex",idiomAnswer,@"idiomAnswer",idiomOptstr,@"idiomOptstr",@(isAnswer),@"isAnswer",@(ididomType),@"ididomType",idiomExplain,@"idiomExplain",idiomSorce,@"idiomSorce",idiomPicName,@"idiomPicName",@(isUnlocked),@"isUnlocked",idiomSorce,@"idiomFrom",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    return array;
}

- (NSMutableArray *)queryIdiomInfoAccordpackageIndex:(int)packageindex secondIndex:(int)secondIndex
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from IDIOMINFO WHERE PACKAGEINDEX=%d and SECONDINDEX=%d and IDIOMTYPE=2",packageindex,secondIndex];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         while (rs.next)
         {
             
             int packgeindex = [rs intForColumnIndex:1];
             int secondIndex = [rs intForColumnIndex:2];
             int levelIndex = [rs intForColumnIndex:3];
             NSString  *idiomAnswer = [rs stringForColumnIndex:4];
             NSString  *idiomOptstr = [rs stringForColumnIndex:5];
             int  isAnswer = [rs intForColumnIndex:6];
             int  ididomType = [rs intForColumnIndex:7];
             NSString  *idiomExplain = [rs stringForColumnIndex:8];
             NSString  *idiomSorce = [rs stringForColumnIndex:9];
             NSString  *idiomPicName = [rs stringForColumnIndex:10];
             int     isUnlocked = [rs intForColumnIndex:11];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(packgeindex),@"packgeindex",@(secondIndex),@"secondIndex",@(levelIndex),@"levelIndex",idiomAnswer,@"idiomAnswer",idiomOptstr,@"idiomOptstr",@(isAnswer),@"isAnswer",@(ididomType),@"ididomType",idiomExplain,@"idiomExplain",idiomSorce,@"idiomSorce",idiomPicName,@"idiomPicName",@(isUnlocked),@"isUnlocked",idiomSorce,@"idiomFrom",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    return array;
}


-(void)DeleteAllIdiomAccorduserID:(NSString*)userID type:(int)type
{
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         NSString *sqlStr = [[NSString alloc] initWithFormat:@"delete from IDIOMINFO where USERID='%@' and IDIOMTYPE=%d;", userID,type];
         if([db executeUpdate:sqlStr])
         {
             //  DLOG(@"DeleteIdiomAccordLevel suc");
         }else
         {
             DLOG(@"DeleteIdiomAccordLevel fail:%@",sqlStr);
         }
         
         
         [sqlStr release];
         
         [db close];
         
     }];
    
    
    
}
-(void)DeleteIdiomAccordLevel:(int)levelIndex userID:(NSString*)userID type:(int)type
{
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *sqlStr = [[NSString alloc] initWithFormat:@"delete from IDIOMINFO where USERID='%@' and LEVELINDEX=%d and IDIOMTYPE=%d;", userID,levelIndex,type];
         
         
         if([db executeUpdate:sqlStr])
         {
             //  DLOG(@"DeleteIdiomAccordLevel suc");
         }else
         {
             DLOG(@"DeleteIdiomAccordLevel fail:%@",sqlStr);
         }
         
         
         [sqlStr release];
         
         [db close];
         
     }];
    
    
    
}

-(void)UpdateIdiomLevel:(int)levelIndex isAnswer:(int)isAnswer isunlock:(int)isunlock userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateIdiomLevel  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update IDIOMINFO set ISANSWERED='%d',ISUNLOCKED='%d' WHERE LEVELINDEX='%d' and USERID='%@';",isAnswer,isunlock,levelIndex,userID];
         
         [db beginTransaction];
         if ([db executeUpdate:updateSql])
         {
             //DLOG(@"UpdateIdiomLevel success updateSql:%@",updateSql);
         }else
         {
             DLOG(@"UpdateIdiomLevel fail:%@",updateSql);
         }
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"UpdateIdiomLevel  close fail");
         }
     }];
    
}



-(void)UpdateIdiomLevel:(int)levelIndex isAnswer:(int)isAnswer userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateIdiomLevel  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update IDIOMINFO set ISANSWERED='%d',ISUNLOCKED=%d WHERE LEVELINDEX=%d and USERID='%@';",isAnswer,1,levelIndex,userID];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             // DLOG(@"UpdateIdiomLevel success updateSql:%@",updateSql);
         }else
         {
             DLOG(@"UpdateIdiomLevel fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"UpdateIdiomLevel  close fail");
         }
     }];
    
}

-(void)UpdateIdiomLevel:(int)levelIndex isUnlocked:(BOOL)isUnlock userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateIdiomLevel  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update IDIOMINFO set ISUNLOCKED='%d' WHERE LEVELINDEX=%d and USERID='%@';",isUnlock,levelIndex,userID];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             DLOG(@"UpdateIdiomLevel success");
         }else
         {
             DLOG(@"UpdateIdiomLevel fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"UpdateIdiomLevel  close fail");
         }
     }];
    
}



#pragma mark
- (void)createGameCenterAndUserIDtable
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createGameCenterAndUserIDtable  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS GameCenterAndUserID(ID INTEGER PRIMARY KEY, USERID TEXT,GAMECENTERID TEXT,TIME  TEXT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createGameCenterAndUserIDtable fail");
         };
         if (![db close])
         {
             
             DLOG(@"createGameCenterAndUserIDtable  close fail");
         }
         
         
     }];
}

- (NSString *)queryUserAccordGameCenteID:(NSString*)strGameCenterID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from GameCenterAndUserID WHERE GAMECENTERID='%@'",strGameCenterID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             NSString   *UserID = [rs stringForColumnIndex:1];
             NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:UserID,@"UserID",timer,@"timer",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    
    if ([array count])
    {
        return [[array objectAtIndex:0] valueForKey:@"UserID"];
    }
    
    return @"0";
}

-(void)insertGameCenterID:(NSString*)gameCenterID   userID:(NSString*)userID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToIdiom  open fail");
        }
        
        NSString   *timer = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into GameCenterAndUserID(ID, USERID, GAMECENTERID,TIME) values(NULL,'%@','%@','%@')",userID,gameCenterID,timer];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"insertGameCenterID:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertGameCenterID  close fail");
        }
        
    }];
}
-(void)UpdateLoginTime:(NSString*)gameCenterID
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"UpdateLoginTime  open fail");
        }
        
        NSString   *timer = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        NSString *updateSql = [[NSString alloc] initWithFormat:@"update GameCenterAndUserID set TIME='%@' WHERE GAMECENTERID='%@';",timer,gameCenterID];
        
        if (![db executeUpdate:updateSql])
        {
            DLOG(@"UpdateLoginTime:%@  fail",updateSql);
        }
        [updateSql release];
        if (![db close])
        {
            
            DLOG(@"UpdateLoginTime  close fail");
        }
        
    }];
}



/**********************角色解锁表*********************************/
- (void)createRoleLockInfoTable
{
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createRoleLockInfoTable  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS  RoleLockInfoTable(ID INTEGER PRIMARY KEY,ROLEID  INT,ISUNLOCKED  INT,USERID TEXT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createRoleLockInfoTable fail");
         };
         if (![db close])
         {
             
             DLOG(@"createRoleLockInfoTable  close fail");
         }
         
         
     }];
}
-(void)inserRoleLockInfo:(NSString*)userID  roleID:(int)roleID isUnlock:(int)isUnlock
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToIdiom  open fail");
        }
        
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into RoleLockInfoTable(ID, ROLEID, ISUNLOCKED,USERID) values(NULL,%d,%d,'%@')",roleID,isUnlock,userID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"inserRoleLockInfo:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"inserRoleLockInfo  close fail");
        }
        
    }];
}
-(void)UpdateRoleLockInfo:(NSString*)userID roleID:(int)roleID  isUnlock:(int)isUnlock
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"UpdateRoleLockInfo  open fail");
        }
        
        NSString *updateSql = [[NSString alloc] initWithFormat:@"update RoleLockInfoTable set isUnlock=%d WHERE userID='%@' and roleID=%d;",isUnlock,userID,roleID];
        
        if (![db executeUpdate:updateSql])
        {
            DLOG(@"UpdateRoleLockInfo:%@  fail",updateSql);
        }
        [updateSql release];
        
        if (![db close])
        {
            
            DLOG(@"UpdateRoleLockInfo  close fail");
        }
        
    }];
}
- (BOOL)queryUserRoleIDIsUnlock:(NSString*)userID  roleID:(int)roleID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from RoleLockInfoTable WHERE userID='%@' and roleID=%d",userID,roleID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             int    isUnlock = [rs intForColumnIndex:2];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(isUnlock),@"isUnlock",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    
    if ([array count])
    {
        return [[[array objectAtIndex:0] valueForKey:@"isUnlock"] boolValue];
    }
    
    return NO;
}
- (BOOL)queryUserHasRoleIDInfo:(NSString*)userID  roleID:(int)roleID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select isUnlock from RoleLockInfoTable WHERE userID='%@' and roleID=%d",userID,roleID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             int    isUnlock = [rs intForColumnIndex:2];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(isUnlock),@"isUnlock",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    
    if ([array count])
    {
        return  YES;
    }
    
    return NO;
}

/**********************充值未处理表*********************************/
- (void)createChargeUnDealTable
{
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createCHARGEINFO  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS  CHARGEINFO(ID INTEGER PRIMARY KEY,USERID  TEXT,PAYID  TEXT,RECEIPT TEXT,CHANNELID  INT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createCHARGEINFO fail:%@",createSQL);
         };
         if (![db close])
         {
             
             DLOG(@"createCHARGEINFO  close fail");
         }
         
         
     }];
}
-(void)inserchargeUnDealTable:(NSString*)userID  PayID:(NSString*)payID ChanelID:(int)channelID receipt:(NSString*)receipt
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToIdiom  open fail");
        }
        
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into CHARGEINFO(ID, USERID, PAYID,RECEIPT,CHANNELID) values(NULL,'%@','%@','%@',%d)",userID,payID,receipt,channelID];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"inserchargeUnDealTable:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"inserUnDealTable  close fail");
        }
        
    }];
}
-(void)UpdatechargeUnDealTable:(NSString*)userID  PayID:(NSString*)payID ChanelID:(int)channelID receipt:(NSString*)receipt
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"UpdatechargeUnDealTable  open fail");
        }
        
        NSString *updateSql = [[NSString alloc] initWithFormat:@"update CHARGEINFO set receipt='%@',ChanelID=%d WHERE userID='%@' and PAYID='%@';",receipt,channelID,userID,payID];
        
        if (![db executeUpdate:updateSql])
        {
            DLOG(@"UpdatechargeUnDealTable:%@  fail",updateSql);
        }
        [updateSql release];
        
        if (![db close])
        {
            
            DLOG(@"UpdatechargeUnDealTable  close fail");
        }
        
    }];
}

- (BOOL)queryIsHasUnchargeInfo:(NSString*)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select count(*) from CHARGEINFO WHERE userID='%@'",userID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             int    isHas = [rs intForColumnIndex:0];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(isHas),@"isHas",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    
    
    if ([array count])
    {
        if ([[[array objectAtIndex:0] valueForKey:@"isHas"] intValue] > 0)
        {
            return YES;
        }
        return  NO;
    }
    
    return NO;
}


- (NSMutableArray*)queryAllUnchargeInfobyUserID:(NSString*)userID andPayID:(NSString*)payID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from CHARGEINFO WHERE userID='%@' and PAYID='%@'",userID,payID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             NSString    *userID = [rs stringForColumnIndex:1];
             NSString    *payID = [rs stringForColumnIndex:2];
             NSString    *receipt = [rs stringForColumnIndex:3];
             NSString    *channelID = [NSString stringWithFormat:@"%d",[rs intForColumnIndex:4]];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID",payID,@"payID",receipt,@"receipt",channelID,@"channelID",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    return array;
}
- (NSMutableArray*)queryAllUnchargeInfobyUserID:(NSString*)userID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from CHARGEINFO WHERE userID='%@'",userID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             NSString    *userID = [rs stringForColumnIndex:1];
             NSString    *payID = [rs stringForColumnIndex:2];
             NSString    *receipt = [rs stringForColumnIndex:3];
             NSString    *channelID = [NSString stringWithFormat:@"%d",[rs intForColumnIndex:4]];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID",payID,@"payID",receipt,@"receipt",channelID,@"channelID",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    return array;
}
- (NSMutableArray*)queryAllUnchargeInfoByPayID:(NSString*)payID
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *query = [[NSString alloc] initWithFormat: @"select * from CHARGEINFO WHERE PAYID='%@'",payID];
         
         FMResultSet *rs = [db executeQuery:query];
         
         [query release];
         
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         
         while (rs.next)
         {
             
             
             //    NSString   *UserID = [rs stringForColumnIndex:1];
             //   NSString   *timer = [rs stringForColumnIndex:3];
             
             
             
             NSString    *userID = [rs stringForColumnIndex:1];
             NSString    *payID = [rs stringForColumnIndex:2];
             NSString    *receipt = [rs stringForColumnIndex:3];
             NSString    *channelID = [NSString stringWithFormat:@"%d",[rs intForColumnIndex:4]];
             
             NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID",payID,@"payID",receipt,@"receipt",channelID,@"channelID",nil];
             [array addObject:infoDic];
             
             //DLOG(@"infoDic:%@",infoDic);
         }
         
         [rs close];
         
         [db close];
         
         [pool release];
         
     }];
    return array;
}

- (void)deleteUndealInfoByPayID:(NSString*)payID
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         [db open];
         
         NSString *sqlStr = [[NSString alloc] initWithFormat:@"delete from CHARGEINFO where PAYID='%@';",payID];
         
         
         if([db executeUpdate:sqlStr])
         {
             DLOG(@"deleteUndealInfoByPayID suc");
         }else
         {
             DLOG(@"deleteUndealInfoByPayID fail");
         }
         
         
         [sqlStr release];
         
         [db close];
         
     }];
}

#pragma mark unlocklevelpurchase
- (void)createUnlockPurchaseTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"createUnlockPurchaseTable  open fail");
         }
         NSString *createSQL = @"CREATE TABLE IF NOT EXISTS UnlockPurchase(ID INTEGER PRIMARY KEY, LEVEL INT,ISPURCHASED INT)";
         
         if (![db executeUpdate:createSQL])
         {
             DLOG(@"createUnlockPurchaseTable fail");
         };
         if (![db close])
         {
             
             DLOG(@"createUnlockPurchaseTable  close fail");
         }
         
         
     }];
}

-(void)insertToUnlockPurchaseTableLevel:(int)level ispurchade:(int)ispurchased
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db open])
        {
            DLOG(@"insertToUnlockPurchaseTableLevel  open fail");
        }
        
        NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into UnlockPurchase(LEVEL, ISPURCHASED) values(%d, '%d')",level,ispurchased];
        
        if (![db executeUpdate:insertSql])
        {
            DLOG(@"executeUpdate:%@  fail",insertSql);
        }
        
        
        [insertSql release];
        
        if (![db close])
        {
            
            DLOG(@"insertToUnlockPurchaseTableLevel  close fail");
        }
        
    }];
    
}

-(void)UpdateUnlockPurchaseTableAccordLevel:(int)level ispurchade:(int)ispurchade
{
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         
         if (![db open])
         {
             DLOG(@"UpdateUnlockPurchaseTableAccordLevel  open fail");
         }
         
         NSString *updateSql = [[NSString alloc] initWithFormat:@"update UnlockPurchase set ISPURCHASED=%d WHERE LEVEL=%d;",ispurchade,level];
         
         [db beginTransaction];
         
         
         if ([db executeUpdate:updateSql])
         {
             DLOG(@"UpdateUnlockPurchaseTableAccordLevel success");
         }else
         {
             DLOG(@"UpdateUnlockPurchaseTableAccordLevel fail:%@",updateSql);
         }
         
         
         [db commit];
         
         [updateSql release];
         
         if (![db close])
         {
             
             DLOG(@"UpdateUnlockPurchaseTableAccordLevel  close fail");
         }
     }];
    
}



- (BOOL)queryLevelIspurchased:(int)level
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select * from UnlockPurchase where LEVEL='%d'",level];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            int ispurchase = [rs intForColumnIndex:2];
            
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(ispurchase),@"ispurchase",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    if ([array count])
    {
        return [[[array objectAtIndex:0] valueForKey:@"ispurchase"] boolValue];
    }
    
    return NO;
}

- (BOOL)queryhasLevelpurchasedinfo:(int)level
{
    __block NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        [db open];
        
        NSString *query = [[NSString alloc] initWithFormat: @"select count(*) from UnlockPurchase where LEVEL='%d'",level];
        
        FMResultSet *rs = [db executeQuery:query];
        
        [query release];
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        while (rs.next)
        {
            
            int ispurchase = [rs intForColumnIndex:0];
            
            
            
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@(ispurchase),@"count",nil];
            [array addObject:infoDic];
            
            //DLOG(@"infoDic:%@",infoDic);
        }
        
        [rs close];
        
        [db close];
        
        [pool release];
        
    }];
    
    if ([array count])
    {
        return [[[array objectAtIndex:0] valueForKey:@"count"] boolValue];
    }
    
    return NO;
}



@end