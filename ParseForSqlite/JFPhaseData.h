//
//  JFPhaseData.h
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFPhaseData : NSObject

+(NSMutableArray*)GetDataFromCsv:(NSString*)strFilePath;
+(NSMutableArray*)GetDataFromTxt:(NSString*)strFilePath;
+(NSMutableArray*)GetDataFromMiyudaquanTxt:(NSString*)strFilePath;
+(NSMutableArray*)GetDataFromriddleplist:(NSString*)strFilePath;
@end
