//
//  JFQuestionModel.h
//  ParseForSqliteForChengwuWar
//
//  Created by Joshon on 14-9-4.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFQuestionModel : NSObject

@property(nonatomic,strong)NSString *cateary;
@property(nonatomic,strong)NSString *answer;
@property(nonatomic,strong)NSString *explain;
@property(nonatomic,strong)NSString *Aoption;
@property(nonatomic,strong)NSString *Boption;
@property(nonatomic,strong)NSString *Coption;
@property(nonatomic,strong)NSString *Doption;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *Question;
@property(nonatomic,strong)NSString *rightOption;
@property(nonatomic)int index;
@end
