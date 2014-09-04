//
//  JFQuestionModel.m
//  ParseForSqliteForChengwuWar
//
//  Created by Joshon on 14-9-4.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import "JFQuestionModel.h"

@implementation JFQuestionModel


-(NSString*)description
{
    NSString    *strReturn = [NSString stringWithFormat:@"class:%@ address<%p> index:%d cateary:%@ answer:%@ explain:%@ Aoption:%@ Boption:%@ Coption:%@ Doption:%@ type:%@ Question:%@ rightOption:%@",[self class],self,self.index,self.cateary,self.answer,self.explain,self.Aoption,self.Boption,self.Coption,self.Doption,self.type,self.Question,self.rightOption];
    return strReturn;
}
@end
