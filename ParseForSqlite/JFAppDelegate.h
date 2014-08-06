//
//  JFAppDelegate.h
//  ParseForSqlite
//
//  Created by ran on 14-2-24.
//  Copyright (c) 2014年 com.lelechat.chengyuwar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSButton *btnStart;



-(IBAction)clickStart:(id)sender;
@end
