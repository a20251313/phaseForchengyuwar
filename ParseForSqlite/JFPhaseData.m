//
//  JFPhaseData.m
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFPhaseData.h"
@implementation JFPhaseData



+(NSMutableArray*)GetDataFromCsv:(NSString*)strFilePath
{
    NSMutableArray  *array = [NSMutableArray array];
    
    NSError *error = nil;
    NSString    *strInfo = [NSString stringWithContentsOfFile:strFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    if (error || !strInfo)
    {
        DLOG(@"GetDataFromCsv error:%@,filePath:%@",error,strFilePath);
    }
    
    NSArray  *arrayStr = [strInfo componentsSeparatedByString:@"\r\n"];
    if ([arrayStr count])
    {
        DLOG(@"arrayStr count:%ld",[arrayStr count]);
    }
    
    [array addObjectsFromArray:arrayStr];
    return array;
}

+(NSMutableArray*)GetDataFromTxt:(NSString*)strFilePath
{
    NSMutableArray  *array = [NSMutableArray array];
    
    NSError *error = nil;
    NSString    *strInfo = [NSString stringWithContentsOfFile:strFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    if (error || !strInfo)
    {
        DLOG(@"GetDataFromCsv error:%@,filePath:%@",error,strFilePath);
    }
    
    NSArray  *arrayStr = [strInfo componentsSeparatedByString:@"\n"];
    if ([arrayStr count])
    {
        DLOG(@"arrayStr count:%ld",[arrayStr count]);
    }
    
    [array addObjectsFromArray:arrayStr];
    return array;
}

+(NSMutableArray*)GetDataFromMiyudaquanTxt:(NSString*)strFilePath
{
    NSMutableArray  *array = [NSMutableArray array];
    
    NSError *error = nil;
    NSString    *strInfo = [NSString stringWithContentsOfFile:strFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    if (error || !strInfo)
    {
        DLOG(@"GetDataFromCsv error:%@,filePath:%@",error,strFilePath);
    }
    
    NSArray  *arrayStr = [strInfo componentsSeparatedByString:@"\n"];
    if ([arrayStr count])
    {
        DLOG(@"arrayStr count:%ld",[arrayStr count]);
    }
    
    [array addObjectsFromArray:arrayStr];
    return array;
}


+(NSMutableArray*)GetDataFromriddleplist:(NSString*)strFilePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:strFilePath])
    {
        
    }
  //  NSDictionary  *dic = [NSDictionary dictionaryWithContentsOfFile:strFilePath];
   // DLOG(@"dic:%@",dic);
    NSArray     *arraycon = [NSArray arrayWithContentsOfFile:strFilePath];
    NSMutableArray  *array = [NSMutableArray array];
    [array addObjectsFromArray:arraycon];
    
    
    /*
    NSError *error = nil;
    NSString    *strInfo = [NSString stringWithContentsOfFile:strFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    if (error || !strInfo)
    {
        DLOG(@"GetDataFromCsv error:%@,filePath:%@",error,strFilePath);
    }
    
    NSArray  *arrayStr = [strInfo componentsSeparatedByString:@"\n"];
    if ([arrayStr count])
    {
        DLOG(@"arrayStr count:%ld",[arrayStr count]);
    }
    
    [array addObjectsFromArray:arrayStr];*/
    return array;
}

@end
