//
//  AppMacro.h
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define kOffLineDebug 0 //是否离线debug

/***********NSuserDefault_Key**************/
//医院搜索记录
#define CUS_SEARCH_HISTORY @"cus_search_history"
//产品搜索记录
#define PRD_SEARCH_HISTORY @"prd_search_history"
/**********localDirName*************/
//图片上传缓存
#define kFilePath_upload @"tmp/upload"
//报告下载缓存
#define kFilePath_report @"tmp/report"

/******************NotificationString****************/
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

/******************SystomFunction****************/
//版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kSubjectColor RGBColor(77, 163, 169, 1)
#define kSubjectColor_Red RGBColor(238, 79, 100, 1)
#define kBgColor RGBColor(235, 235, 235, 1)
#define kGrayFontColor RGBColor(153, 153, 153, 1)
#define kBlackFontColor RGBColor(51, 51, 51, 1)
#define kPlaceHolderColor RGBColor(153, 153, 153, 1)
#define kSeparateLineColor RGBColor(200, 200, 200, 1)

#define kHugeFont [UIFont systemFontOfSize:20]
#define kBigFont [UIFont systemFontOfSize:17]
#define kMidFont [UIFont systemFontOfSize:14]
#define kSmallFont [UIFont systemFontOfSize:12]
#endif /* AppMacro_h */
