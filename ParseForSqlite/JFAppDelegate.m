//
//  JFAppDelegate.m
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFAppDelegate.h"
#import "JFPhaseData.h"
#import "JFSQLManger.h"
#import "JFPhaseXmlData.h"
#import "SQLOperation.h"
#import "JFIdiomModel.h"
#import "JFQuestionModel.h"

#define FILEPATH    @"/Users/popo/Desktop/Documents/csv/tiku3.csv"
@implementation JFAppDelegate
@synthesize btnStart;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
   [[SQLOperation sharedSQLOperation] createTable];
    // Insert code here to initialize your application
}

//maintype1 谜语 2 成语   3 歇后语  4 脑筋急转弯
/*
 [self tiku3Function];
 [self plant];
 [self animal];
 [self name];
 [self fun];
 [self dailyneces];
 [self love];
 [self idiom];
 [self word];
 [self child];
 [self miyuDB];
 
 [self miyuplistFromriddlelist];
 [self miyuplistFromQuestion2list];
 [self miyuplistFromQuestion3list];
 [self miyuDaquanDB];
 [self getMiyUFromTxt];
*/
//suntype 1 日常用品  2 爱情  3 字谜 4 动物  5有趣的事    6 人名  7 孩童谜语  8植物 9影视谜语 10 地名




-(IBAction)clickStart:(id)sender
{
   
   [NSThread detachNewThreadSelector:@selector(getAllDataFromPlist) toTarget:self withObject:nil];
  // [JFSQLManger closeDB];
}

-(void)getAllDataFromPlist //获取问答天下的题目
{
    NSString    *docPath = @"/Users/aplee/百度云同步盘/问答天下题目";
    NSMutableArray  *arrayInfo = [NSMutableArray array];
    [[SQLOperation sharedSQLOperation] deleteQuestionsTabel];
    
    int index = 0;
    NSArray     *arraySubPath = [[NSFileManager defaultManager] subpathsAtPath:docPath];
    for (NSString *strSubPath in arraySubPath)
    {
        
        if (![strSubPath hasSuffix:@"plist"])
        {
            continue;
        }
        NSString    *strTempPath = [docPath stringByAppendingPathComponent:strSubPath];
        NSString    *strCatery = [strSubPath stringByReplacingOccurrencesOfString:@"1" withString:@""];
        strCatery = [strCatery stringByReplacingOccurrencesOfString:@"2" withString:@""];
        strCatery = [strCatery stringByReplacingOccurrencesOfString:@".plist" withString:@""];
        strCatery = [strCatery stringByReplacingOccurrencesOfString:@"3" withString:@""];
        strCatery = [strCatery stringByReplacingOccurrencesOfString:@"4" withString:@""];
        
        NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:strTempPath];
        for (NSArray *arrayData in arrayPlist)
        {
            if (![arrayData isKindOfClass:[NSArray class]])
            {
                continue;
            }
            NSMutableArray  *subArray = [NSMutableArray array];
            [subArray addObject:strCatery];
            [subArray addObjectsFromArray:arrayData];
            [arrayInfo addObject:subArray];
            [subArray removeObject:@""];
            
            JFQuestionModel *model = [[JFQuestionModel alloc] init];
            if (subArray.count > 9)
            {
                model.cateary = subArray[0];
                model.Question = subArray[2];
                model.Aoption = subArray[3];
                model.Boption = subArray[4];
                model.Coption = subArray[5];
                model.Doption = subArray[6];
                if ([subArray[7] isEqualToString:@"A"])
                {
                    model.answer = model.Aoption;
                }else if ([subArray[7] isEqualToString:@"B"])
                {
                    model.answer = model.Boption;
                }else if ([subArray[7] isEqualToString:@"C"])
                {
                    model.answer = model.Coption;
                }else if ([subArray[7] isEqualToString:@"D"])
                {
                    model.answer = model.Doption;
                }
                model.rightOption = subArray[7];
                
                if ([subArray[8] isKindOfClass:[NSString class]])
                {
                    model.explain = subArray[8];
                }
              //  NSLog(@"subArray:%@ count:%ld",subArray,subArray.count);
                
            }else if(subArray.count == 9)
            {
                model.cateary = subArray[0];
                model.Question = subArray[2];
                model.Aoption = subArray[4];
                model.Boption = subArray[5];
                model.Coption = subArray[6];
                model.Doption = subArray[7];
                if ([subArray[8] isEqualToString:@"A"])
                {
                    model.answer = model.Aoption;
                }else if ([subArray[8] isEqualToString:@"B"])
                {
                    model.answer = model.Boption;
                }else if ([subArray[8] isEqualToString:@"C"])
                {
                    model.answer = model.Coption;
                }else if ([subArray[8] isEqualToString:@"D"])
                {
                    model.answer = model.Doption;
                }
                model.rightOption = subArray[8];
//                if ([subArray[8] isKindOfClass:[NSString class]])
//                {
//                    model.explain = subArray[8];
//                }
                //NSLog(@"subArray:%@ count:%ld",subArray,subArray.count);
            }
            model.index = index;
            index++;
            if (index == 1543)
            {
                NSLog(@"before 1543");
 
            }
            
            [self execptopnModel:model];
            [[SQLOperation sharedSQLOperation] insertQuestionsTabel:index question:model.Question Answer:model.answer cateary:model.cateary AoptionStr:model.Aoption BoptionStr:model.Boption CoptionStr:model.Coption DoptionStr:model.Doption RightoptionStr:model.rightOption Explain:model.explain];
             NSLog(@"model:%@",model);
            if (index == 1543)
            {
                NSLog(@"finish 1543");
              //  return;
            }
     
           
        }
     
        
        
    }
}

-(void)execptopnModel:(JFQuestionModel*)model
{
    model.Question = [model.Question stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.answer = [model.answer stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.cateary = [model.cateary stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.Aoption = [model.Aoption stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.Boption = [model.Boption stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.Coption = [model.Coption stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.Doption = [model.Doption stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.rightOption = [model.rightOption stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
    model.explain = [model.explain stringByReplacingOccurrencesOfString:@"'" withString:@"单单引引号号"];
   // model.Question = [model.Question stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    
}

-(void)getAllData
{
    NSMutableArray *arrayData = [[SQLOperation sharedSQLOperation] getAllIdiomModels];
    NSMutableArray  *otherarray = [self randomArray:arrayData];
    [[SQLOperation sharedSQLOperation] deleteAllIdioms];
    int index = 1;
    for (NSDictionary *dicInfo in otherarray)
    {
        [[SQLOperation sharedSQLOperation] insertIdiomTabelTabel:index hardType:1 imagePath:[dicInfo valueForKey:@"imageName"] Answer:[dicInfo valueForKey:@"answer"] optionStr:[dicInfo valueForKey:@"option"] from:[dicInfo valueForKey:@"from"] Explain:[dicInfo valueForKey:@"explain"]];
        index++;
        
    }
    NSLog(@"getAllData and write data finish");
    
}

-(NSMutableArray*)randomArray:(NSMutableArray*)sourceArray
{
    NSMutableArray  *array = [NSMutableArray array];
    while (sourceArray.count)
    {
        srandom((unsigned)(time(NULL)+sourceArray.count));
        long index = random()%sourceArray.count;
        [array addObject:sourceArray[index]];
        [sourceArray removeObjectAtIndex:index];
    }
    
    return array;
}

-(void)phaseOtherData
{
    NSError *error = nil;
    NSString    *strFile = @"/Users/aplee/Desktop/封装类以及方法/www/jsQuestion.js";
    NSString    *strContent = [NSString stringWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:&error];
    if (error || strContent == nil)
    {
        NSLog(@"strFile is not right:%@",strFile);
    }
    
    NSArray *array = [strContent componentsSeparatedByString:@"\r"];
    if (array.count)
    {
        NSLog(@"222array.count:%ld",array.count);
    }else
    {
         NSLog(@"111array.count:%ld",array.count);
    }
    
    int index = 301;
    for (NSString *strInfo in array)
    {
        if ([strInfo length] < 40)
        {
            continue;
        }
        
        
        NSRange range = [strInfo rangeOfString:@"="];
        
        strInfo = [strInfo substringFromIndex:range.location+2];
        
        if ([strInfo length] < 10)
        {
            continue;
        }
        strInfo = [strInfo stringByReplacingOccurrencesOfString:@"[" withString:@""];
        strInfo = [strInfo stringByReplacingOccurrencesOfString:@"]" withString:@""];
        strInfo = [strInfo stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        NSArray *subarray = [strInfo componentsSeparatedByString:@","];
        if (subarray.count)
        {
            NSLog(@"subarray.count:%ld",subarray.count);
        }
        NSString    *strAnswer = [NSString stringWithFormat:@"%@%@%@%@",subarray[0],subarray[1],subarray[2],subarray[3]];
        strAnswer = [strAnswer stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strAnswer = [strAnswer stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString    *strImage = subarray[4];
        strImage = [strImage stringByReplacingOccurrencesOfString:@"images/" withString:@""];
        NSString    *strOption = [NSString stringWithFormat:@"%@%@%@%@%@%@",subarray[5],subarray[6],subarray[7],subarray[8],subarray[9],subarray[10]];
        strOption = [strOption stringByReplacingOccurrencesOfString:@"\"" withString:@""];
         strOption = [strOption stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString    *strExplain = subarray[11];
        NSString    *strFrom = subarray[12];
        
        [[SQLOperation sharedSQLOperation] insertIdiomTabelTabel:index hardType:1 imagePath:strImage Answer:strAnswer optionStr:strOption from:strFrom Explain:strExplain];
        index++;
        
    }
    
}

-(void)phaseData
{
    
    NSString    *file1 = @"/Users/aplee/Desktop/Documents/cywarqusetion/cc/description.xml";
    NSString    *file2 = @"/Users/aplee/Desktop/Documents/cywarqusetion/dd/description.xml";
    NSArray *arrayFiles = [NSArray arrayWithObjects:file1,file2, nil];
    NSMutableArray  *arrayIdioms = [NSMutableArray array];
    for (NSString *strFile in arrayFiles)
    {
        NSMutableArray  *array = [JFPhaseXmlData phaseUrlInfoAccordPath:strFile];
        if (array.count)
        {
            DLOG(@"array:%@",array);
        }
        [arrayIdioms addObjectsFromArray:array];
    }
    
    
    int     index = 1;
    for (int i = 0;i < arrayIdioms.count;i++)
    {
        JFIdiomModel    *model = arrayIdioms[i];
        [[SQLOperation sharedSQLOperation] insertIdiomTabelTabel:index hardType:model.hardType imagePath:model.idiomImageName Answer:model.idiomAnswer optionStr:model.idiomOptionstr from:model.idiomFrom Explain:model.idiomExplain];
        index++;
    }
    
   
}


-(void)checkHasAnsewrInOption
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromMiyudaquanTxt:@"/Users/popo/Desktop/Documents/idiom.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    
    int levelIndex = 0;//[JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    
    int count = 0;
    for (NSString  *strInfo in array)
    {
        strInfo = [strInfo stringByReplacingOccurrencesOfString:@"||" withString:@"|没有类型|"];
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] < 2)
        {
            DLOG(@"arrayObjects:%@",arrayObjects);
            continue;
        }
        NSString  *strAnswer = [arrayObjects objectAtIndex:0];
        NSString  *strOptionStr = [arrayObjects objectAtIndex:1];

        
        if ([strOptionStr length] != 24)
        {
            count++;
            DLOG(@"strOptionStr:%@ strAnswer:%@  length:%ld",strOptionStr,strAnswer,[strOptionStr length]);
        }
       
        for (int i = 0;i < [strAnswer length];i++)
        {
            
            BOOL  bhasAnswer = NO;
            NSString  *strA = [strAnswer substringWithRange:NSMakeRange(i, 1)];
            
           
            for (int j = 0; j < [strOptionStr length]; j++)
            {
                NSString  *strQ = [strOptionStr substringWithRange:NSMakeRange(j, 1)];
                if ([strQ isEqualToString:strA])
                {
                    bhasAnswer = YES;
                    continue;
                }
                
            }
            
            if (!bhasAnswer)
            {
                count++;
                DLOG(@"count:%d strOptionStr:%@ \nstrAnswer:%@",count,strOptionStr,strAnswer);
                break;
            }
        }
    }
    
    
    
    DLOG(@"wholeMiYuFromTxt finish");
}

-(void)wholeMiYuFromTxt
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromMiyudaquanTxt:@"/Users/popo/Desktop/Documents/puzzleinfo.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    
    int levelIndex = 0;//[JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        strInfo = [strInfo stringByReplacingOccurrencesOfString:@"||" withString:@"|没有类型|"];
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
    
        if ([arrayObjects count] >= 6)
        {
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            BOOL  bhasQ = [JFSQLManger isHasSameQuestion:strQ];
            if (bhasQ)
            {
                continue;
            }
            int  mainType = 1;
            int  subType = 0;
            NSString  *strA = [arrayObjects objectAtIndex:2];
            mainType = [[arrayObjects objectAtIndex:3] intValue];
            subType = [[arrayObjects objectAtIndex:4] intValue];
            NSString  *textType = [arrayObjects objectAtIndex:5];
            strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }else
        {
            DLOG(@"strInfo:%@ levelIndex:%d",strInfo,levelIndex);
        }
    }
    
    
    DLOG(@"wholeMiYuFromTxt finish");
}


-(void)getMiyUFromTxt
{
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    NSString  *strFileDoc = @"/Users/popo/Desktop/Documents/脑筋急转弯";
    
    NSArray  *files = [[NSFileManager defaultManager] subpathsAtPath:strFileDoc];
    
    
    for (NSString  *strName in files)
    {
        if ([strName rangeOfString:@"A.TXT"].location != NSNotFound)
        {
            NSString  *afileName = [strFileDoc stringByAppendingPathComponent:strName];
            
            strName = [strName stringByReplacingOccurrencesOfString:@"A.TXT" withString:@"Q.TXT"];
            NSString  *qfileName = [strFileDoc stringByAppendingPathComponent:strName];
            
            NSError  *error = nil;
            NSString  *strQ = [NSString stringWithContentsOfFile:qfileName encoding:NSUTF8StringEncoding error:&error];
            if (error)
            {
                continue;
            }
            NSString  *strA = [NSString stringWithContentsOfFile:afileName encoding:NSUTF8StringEncoding error:&error];
            if (error)
            {
                continue;
            }
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:2 subType:0 levelType:1 index:levelIndex typeString:@"脑筋急转弯" isAnswer:0];
            levelIndex++;
            
        }
    }
}


-(void)miyuplistFromQuestion2list
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromriddleplist:@"/Users/popo/Desktop/Documents/plist/Question2.plist"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    
    DLOG(@"array  count:%ld",[array count]);
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSMutableDictionary  *dicInfo in array)
    {
        
        int  mainType = 4;
        int  subType = 0;
        
        
        NSString  *strQ = [dicInfo valueForKey:@"content"];
        strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
        //            NSRange  range =  [strQ rangeOfString:@"打一植物"];
        //
        //            if (range.location == NSNotFound)
        //            {
        //                strQ = [strQ stringByAppendingString:@" (打一植物)"];
        //            }
        NSString  *textType = nil;//@"孩童谜语";//[arrayObjects objectAtIndex:1];
        NSString  *strA = [dicInfo valueForKey:@"result"];
        
        [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
        levelIndex++;
        
    }
}

-(void)miyuplistFromQuestion3list
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromriddleplist:@"/Users/popo/Desktop/Documents/plist/Question3.plist"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    
     DLOG(@"array  count:%ld",[array count]);
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSMutableDictionary  *dicInfo in array)
    {
        
        int  mainType = 1;
        int  subType = 0;
        
        
        NSString  *strQ = [dicInfo valueForKey:@"content"];
        strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
        //            NSRange  range =  [strQ rangeOfString:@"打一植物"];
        //
        //            if (range.location == NSNotFound)
        //            {
        //                strQ = [strQ stringByAppendingString:@" (打一植物)"];
        //            }
        NSString  *textType = nil;//@"孩童谜语";//[arrayObjects objectAtIndex:1];
        NSString  *strA = [dicInfo valueForKey:@"result"];
        
        [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
        levelIndex++;
        
    }
}

-(void)miyuplistFromriddlelist
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromriddleplist:@"/Users/popo/Desktop/Documents/riddle.plist"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSMutableDictionary  *dicInfo in array)
    {

            int  mainType = 1;
            int  subType = 0;

            
            NSString  *strQ = [dicInfo valueForKey:@"question"];
            strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
            //            NSRange  range =  [strQ rangeOfString:@"打一植物"];
            //
            //            if (range.location == NSNotFound)
            //            {
            //                strQ = [strQ stringByAppendingString:@" (打一植物)"];
            //            }
            NSString  *textType = nil;//@"孩童谜语";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [dicInfo valueForKey:@"answer"];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        
    }
}





-(void)miyuDaquanDB
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromMiyudaquanTxt:@"/Users/popo/Documents/miyudaquan.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 0;
            NSString *index = [arrayObjects objectAtIndex:1];
           NSString  *textType = nil;
            
            switch ([index intValue])
            {
                case 1:
                    subType = 9;
                    textType = @"影视谜语";
                    break;
                case 5:
                    subType = 6;
                    textType = @"人名";
                    break;
                case 6:
                    subType = 4;
                    textType = @"动物";
                    break;
                case 7:
                    subType = 0;
                   // textType = @"动物";
                    break;
                case 9:
                    subType = 0;
                    mainType = 2;
                    textType = @"成语";
                    break;
                case 11:
                    subType = 3;
                    textType = @"字谜";
                    break;
                case 16:
                    subType = 10;
                    textType = @"地名";
                    break;
                case 17:
                    subType = 8;
                    textType = @"植物";
                    break;
                case 18:
                    subType = 0;
                    mainType = 4;
                    textType = @"脑筋急转弯";
                    break;
                case 19:
                    subType = 7;
                    mainType = 1;
                    textType = @"孩童谜语";
                    break;
                case 20:
                    subType = 0;
                    mainType = 1;
                    //textType = @"孩童谜语";
                    break;
                    
                default:
                    break;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:4];
            strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
            //            NSRange  range =  [strQ rangeOfString:@"打一植物"];
            //
            //            if (range.location == NSNotFound)
            //            {
            //                strQ = [strQ stringByAppendingString:@" (打一植物)"];
            //            }
         //@"孩童谜语";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects lastObject];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}



-(void)miyuDB
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/miyudb.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 0;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            strQ = [strQ stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
            //            NSRange  range =  [strQ rangeOfString:@"打一植物"];
            //
            //            if (range.location == NSNotFound)
            //            {
            //                strQ = [strQ stringByAppendingString:@" (打一植物)"];
            //            }
            NSString  *textType = nil;//@"孩童谜语";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}



-(void)child
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/child.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 7;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
//            NSRange  range =  [strQ rangeOfString:@"打一植物"];
//            
//            if (range.location == NSNotFound)
//            {
//                strQ = [strQ stringByAppendingString:@" (打一植物)"];
//            }
            NSString  *textType = @"孩童谜语";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}



-(void)plant
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/plant.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 8;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSRange  range =  [strQ rangeOfString:@"打一植物"];
            
            if (range.location == NSNotFound)
            {
                strQ = [strQ stringByAppendingString:@" (打一植物)"];
            }
            NSString  *textType = @"植物";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}

-(void)idiom
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/idiom.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 2;
            int  subType = 0;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSRange  range =  [strQ rangeOfString:@"打一成语"];
            
            if (range.location == NSNotFound)
            {
                strQ = [strQ stringByAppendingString:@" (打一成语)"];
            }
            NSString  *textType = @"成语";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}

-(void)name
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/name.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 7;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            //            NSRange  range =  [strQ rangeOfString:@"打一动物"];
            //
            //            if (range.location == NSNotFound)
            //            {
            //                strQ = [strQ stringByAppendingString:@"(打一动物)"];
            //            }
            NSString  *textType = @"人名";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}
-(void)fun
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/fun.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 5;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
//            NSRange  range =  [strQ rangeOfString:@"打一动物"];
//            
//            if (range.location == NSNotFound)
//            {
//                strQ = [strQ stringByAppendingString:@"(打一动物)"];
//            }
            NSString  *textType = @"有趣的事";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}

-(void)animal
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/animal.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 3;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSRange  range =  [strQ rangeOfString:@"打一动物"];
            
            if (range.location == NSNotFound)
            {
                strQ = [strQ stringByAppendingString:@"(打一动物)"];
            }
            NSString  *textType = @"字谜";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}




-(void)word
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/word.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 3;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSRange  range =  [strQ rangeOfString:@"打一字"];
            
            if (range.location == NSNotFound)
            {
                strQ = [strQ stringByAppendingString:@"   打一字"];
            }
            NSString  *textType = @"字谜";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}


-(void)love
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/love.txt"];
    
    if ([array count] < 5)
    {
        DLOG(@"array is not enouch");
        return;
    }
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 2;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSString  *textType = @"爱情";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}


-(void)dailyneces
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromTxt:@"/Users/popo/Documents/dailyneces.txt"];
    
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@"|"];
        
        if ([arrayObjects count] >= 3)
        {
            int  mainType = 1;
            int  subType = 1;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:1];
            NSString  *textType = @"日常用品";//[arrayObjects objectAtIndex:1];
            NSString  *strA = [arrayObjects objectAtIndex:2];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}






//finish
-(void)tiku3Function
{
    
    NSMutableArray  *array = [JFPhaseData GetDataFromCsv:@"/Users/popo/Desktop/Documents/csv/tiku3.csv"];
    
    int levelIndex = [JFSQLManger getMaxIndexFromTablePuzzleTable];
    levelIndex++;
    for (NSString  *strInfo in array)
    {
        NSArray  *arrayObjects = [strInfo componentsSeparatedByString:@","];
        
        if ([arrayObjects count] >= 4)
        {
            int  mainType = 1;
            int  subType = 0;
            NSString *index = [arrayObjects objectAtIndex:0];
            if ([index isEqualToString:@"索引"])
            {
                continue;
            }
            
            NSString  *strQ = [arrayObjects objectAtIndex:2];
            NSString  *textType= [arrayObjects objectAtIndex:1];
            if ([textType isEqualToString:@"脑筋急转弯"])
            {
                mainType = 4;
            }else if ([textType isEqualToString:@"猜谜"])
            {
                mainType = 1;
            }else if ([textType isEqualToString:@"诗词对句"])
            {
                mainType = 5;
                
            }
            NSString  *strA = [arrayObjects objectAtIndex:3];
            
            [JFSQLManger insertToSql:strQ answer:strA maintype:mainType subType:subType levelType:1 index:levelIndex typeString:textType isAnswer:0];
            levelIndex++;
        }
    }
}
@end
