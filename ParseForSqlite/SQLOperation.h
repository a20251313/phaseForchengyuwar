//
//  SQLOperation.h
//  I366_V1_4
//
//  操作信息记录中最后一条记录的数据库表格
//
//  Created by  on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"




@interface SQLOperation : NSObject
{
    sqlite3 *database;
    
    //    FMDatabase *db;
    
    FMDatabaseQueue *_dbQueue;
}

@property(nonatomic, retain) FMDatabaseQueue *dbQueue;

+ (SQLOperation *)sharedSQLOperation;
+ (void)closeOperation;
- (void)openDatabase;
- (void)closeDatabase;

//信息表
- (void)createTable;

///用户信息表
-(void)UpdateUSERINFO:(NSString*)userID levelNumber:(int)levelnumber;
-(void)UpdateUSERINFO:(NSString*)userID GoldNumber:(int)goldnumber;
-(void)UpdateUSERINFO:(NSString*)userID userIDType:(int)userIDType lastLogintime:(NSString*)timeInter nickName:(NSString*)nickName roletype:(int)roleType winConut:(int)wincount
            losecount:(int)loseCount goldNumber:(int)goldNumber score:(int)score maxconwinnumber:(int)maxconnumber gamecenterID:(NSString*)gamecenterID gameCenterDisplayName:(NSString*)gamedisplayname LastBeatleatLevel:(int)lastBeatleatLevel isPayed:(int)isPayed;
-(void)insertToUSERINFO:(NSString*)userID userIDType:(int)userIDType lastLogintime:(NSString*)timeInter nickName:(NSString*)nickName roletype:(int)roleType winConut:(int)wincount
              losecount:(int)loseCount goldNumber:(int)goldNumber score:(int)score maxconwinnumber:(int)maxconnumber gamecenterID:(NSString*)gamecenterID gameCenterDisplayName:(NSString*)gamedisplayname LastBeatleatLevel:(int)lastBeatleatLevel ispayedUser:(int)isPayed;
- (NSMutableArray *)queryUserInfoByUserID:(int)userID;
- (NSMutableArray *)queryAllUserInfo;




/**
 *
 *
 *  @param type 1 为闯关类型 2为竞赛
 *
 *  @return 查询到的题目
 */
- (NSMutableArray *)queryIdiomInfoAccordType:(int)type userID:(NSString*)userID;
- (int )queryIdiomCountAccordType:(int)type userID:(NSString*)userID;

- (NSMutableArray *)queryIdiomInfoAccordpackageIndex:(int)packageindex secondIndex:(int)secondIndex;

- (NSMutableArray *)queryIdiomInfoAccordLevelIndex:(int)llevelIndex userID:(NSString*)userID;

- (int )queryIdiomCountAccordType:(int)type userID:(NSString*)userID  index:(int)index packageIndex:(int)packageindex;
-(void)UpdateIdiom:(int)packageindex secondIndex:(int)index levelIndex:(int)levelIndex answer:(NSString*)strAnswer optionStr:(NSString*)optionStr IsAnswer:(int)isAnswer
              Type:(int)type explain:(NSString*)explain source:(NSString*)source picName:(NSString*)picName isUnlock:(BOOL)isUnlocked userID:(NSString*)userID;

-(void)insertToIdiom:(int)packageindex secondIndex:(int)index levelIndex:(int)levelIndex answer:(NSString*)strAnswer optionStr:(NSString*)optionStr IsAnswer:(int)isAnswer
                Type:(int)type explain:(NSString*)explain source:(NSString*)source picName:(NSString*)picName isUnlock:(BOOL)isUnlocked userID:(NSString*)userID;

-(void)UpdateIdiomLevel:(int)levelIndex isUnlocked:(BOOL)isUnlock userID:(NSString*)userID;
-(void)UpdateIdiomLevel:(int)levelIndex isAnswer:(int)isAnswer userID:(NSString*)userID;
-(void)UpdateIdiomLevel:(int)levelIndex isAnswer:(int)isAnswer isunlock:(int)isunlock userID:(NSString*)userID;
-(void)DeleteIdiomAccordLevel:(int)levelIndex userID:(NSString*)userID type:(int)type;
-(void)DeleteAllIdiomAccorduserID:(NSString*)userID type:(int)type;


//
-(void)insertGameCenterID:(NSString*)gameCenterID   userID:(NSString*)userID;
- (NSString *)queryUserAccordGameCenteID:(NSString*)strGameCenterID;
- (void)createGameCenterAndUserIDtable;
-(void)UpdateLoginTime:(NSString*)gameCenterID;

- (BOOL)queryUserHasRoleIDInfo:(NSString*)userID  roleID:(int)roleID;
- (BOOL)queryUserRoleIDIsUnlock:(NSString*)userID  roleID:(int)roleID;
-(void)UpdateRoleLockInfo:(NSString*)userID roleID:(int)roleID  isUnlock:(int)isUnlock;
-(void)inserRoleLockInfo:(NSString*)userID  roleID:(int)roleID isUnlock:(int)isUnlock;


//
- (void)createChargeUnDealTable;
-(void)inserchargeUnDealTable:(NSString*)userID  PayID:(NSString*)payID ChanelID:(int)channelID receipt:(NSString*)receipt;
-(void)UpdatechargeUnDealTable:(NSString*)userID  PayID:(NSString*)payID ChanelID:(int)channelID receipt:(NSString*)receipt;
- (BOOL)queryIsHasUnchargeInfo:(NSString*)userID;
- (NSMutableArray*)queryAllUnchargeInfobyUserID:(NSString*)userID;
- (NSMutableArray*)queryAllUnchargeInfoByPayID:(NSString*)payID;
- (NSMutableArray*)queryAllUnchargeInfobyUserID:(NSString*)userID andPayID:(NSString*)payID;
- (void)deleteUndealInfoByPayID:(NSString*)payID;



//
- (BOOL)queryLevelIspurchased:(int)level;
-(void)insertToUnlockPurchaseTableLevel:(int)level ispurchade:(int)ispurchased;
-(void)UpdateUnlockPurchaseTableAccordLevel:(int)level ispurchade:(int)ispurchade;
- (BOOL)queryhasLevelpurchasedinfo:(int)level;


//

-(void)insertPuzzleTabel:(NSString*)strQuestion Answer:(NSString*)strAnswer mainType:(int)mainType subType:(int)subType
                TextType:(NSString*)strTextType puzzleIndex:(int)index levelType:(int)leveltype isAnswer:(int)isAnswer;
-(int)getMaxIndexINTablePUZZLEINFO;
-(BOOL)getIsHasSameQuestion:(NSString*)strQuestion;


//成语大战


-(void)insertIdiomTabelTabel:(int)index hardType:(int)hardType imagePath:(NSString*)imagePath Answer:(NSString*)answer optionStr:(NSString*)optionStr from:(NSString*)strFrom
                     Explain:(NSString*)explain;

@end