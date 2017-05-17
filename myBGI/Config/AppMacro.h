//
//  AppMacro.h
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define kOffLineDebug 0

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

#define kBgColor RGBColor(235, 235, 241, 1)
#define kGrayFontColor RGBColor(153, 153, 153, 1)
#define kBlackFontColor RGBColor(51, 51, 51, 1)
#define kSubjectColor RGBColor(77, 163, 169, 1)
#define kPlaceHolderColor RGBColor(153, 153, 153, 1)
#define kSeprateLineColor RGBColor(220, 220, 220, 1)
#endif /* AppMacro_h */
