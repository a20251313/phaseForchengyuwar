//
//  JFIdiomModel.h
//  chengyuwar
//
//  Created by ran on 13-12-13.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    JFIdiomModeHardtypeHarder = 1,
    JFIdiomModeHardtypepeNormal = 2,
    JFIdiomModeHardtypeSimple = 3
    
}JFIdiomModeHardtype;



typedef enum
{
    JFIdiomTypeNormal = 1,
    JFIdiomTypeRace = 2
}JFIdiomType;

@interface JFIdiomModel : NSObject

@property(nonatomic)JFIdiomType type;
@property(nonatomic)int  packageIndex;
@property(nonatomic)int  index;
@property(nonatomic)BOOL isAnswed;
@property(nonatomic)BOOL isUnlocked;
@property(nonatomic)JFIdiomModeHardtype  hardType;
@property(nonatomic,copy)NSString  *idiomImageName;
@property(nonatomic,copy)NSString  *idiomAnswer;
@property(nonatomic,copy)NSString  *idiomDespcription;
@property(nonatomic,copy)NSString  *idiomOptionstr;
@property(nonatomic,copy)NSString  *idiomlevelString;
@property(nonatomic,copy)NSString  *idiomFrom;
@property(nonatomic,copy)NSString  *idiomExplain;

@end
