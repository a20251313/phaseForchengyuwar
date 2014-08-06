//
//  JFPhaseXmlData.h
//  chengyuwar
//
//  Created by ran on 13-12-26.
//  Copyright (c) 2013年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    JFPhaseXmlDataTypeNormalXml,
    JFPhaseXmlDataTypeNormalIdiom
    
}JFPhaseXmlDataType;
@interface JFPhaseXmlData : NSObject

+(NSMutableArray*)phaseUrlInfoAccordPath:(NSString*)strPath;
@end
