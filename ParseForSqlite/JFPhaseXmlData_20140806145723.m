//
//  JFPhaseXmlData.m
//  chengyuwar
//
//  Created by ran on 13-12-26.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFPhaseXmlData.h"
#import "GDataXMLNode.h"
#import "JFIdiomModel.h"

@implementation JFPhaseXmlData

+(NSMutableArray*)phaseUrlInfoAccordPath:(NSString*)strPath
{
  
   
  //  DLOG(@"data:%@",[NSString stringWithUTF8String:[data bytes]]);
    GDataXMLDocument  *doc = nil;
   
    doc = [[GDataXMLDocument alloc] initWithData:[NSData dataWithContentsOfFile:strPath] options:0 error:NULL];

    
    
    
    
    NSMutableArray  *arrayData = [NSMutableArray array];
    if (doc)
    {
        
                GDataXMLElement  *rootele = [doc rootElement];
               // NSArray *array = [rootele elementsForName:@"package"];
                
                int  packageIndex = [[[[rootele elementsForName:@"package_idx"] objectAtIndex:0] stringValue] intValue];
                
                GDataXMLElement *question = [[rootele elementsForName:@"question"] objectAtIndex:0];
                NSArray *array = [question elementsForName:@"p"];
                
                for (GDataXMLElement *xmlData in array)
                {
                    JFIdiomModel    *model = [[JFIdiomModel alloc] init];
                    NSString    *lastPath = [[[xmlData elementsForName:@"idiom_guess_pic"] objectAtIndex:0] stringValue];
                   // lastPath = [rootPath stringByAppendingPathComponent:lastPath];
                    model.packageIndex = packageIndex;
                    model.index = [[[[xmlData elementsForName:@"idx"] objectAtIndex:0] stringValue] intValue];
                    model.hardType = [[[[xmlData elementsForName:@"level"] objectAtIndex:0] stringValue] intValue];
                    model.idiomOptionstr = [[[xmlData elementsForName:@"option_str"] objectAtIndex:0] stringValue];
                    model.idiomOptionstr = [model.idiomOptionstr stringByReplacingOccurrencesOfString:@"、" withString:@""];
                    model.idiomOptionstr = [model.idiomOptionstr stringByReplacingOccurrencesOfString:@"," withString:@""];model.idiomOptionstr = [model.idiomOptionstr stringByReplacingOccurrencesOfString:@"，" withString:@""];
                    
                    GDataXMLElement *secondEle = [[xmlData elementsForName:@"answer"] objectAtIndex:0];
                    model.idiomAnswer = [[[secondEle elementsForName:@"idiom"] objectAtIndex:0] stringValue];
                    model.idiomExplain = [[[secondEle elementsForName:@"explain"] objectAtIndex:0] stringValue];
                    model.idiomFrom = [[[secondEle elementsForName:@"from"] objectAtIndex:0] stringValue];
                    
                   // model.idiomImageName = [NSString stringWithFormat:@""];
                    model.idiomImageName = lastPath;
                    [arrayData addObject:model];
                    [model release];
                    
                    DLOG(@"");

                }
        
        
    }
    
    [doc release];
    doc = nil;
    
  //  DLOG(@"phaseUrlInfoAccordPath:%@",arrayData);
    return arrayData;
}
@end
