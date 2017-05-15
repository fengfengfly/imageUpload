//
//  InterfaceMacro.h
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#ifndef InterfaceMacro_h
#define InterfaceMacro_h

//#define domainURL @"Http://172.17.117.8:8080"
#define domainURL @"http://192.168.224.9:8090"

//登录
#define kLoginUrl @"/Front/app/appLogin.action"
//退出登录
#define kLogoutUrl @"/Front/app/appLogout.action"
//查询医院
#define kQueryCustomer @"/Front/app/queryCustomerForApp.action"
//查询产品
#define kQueryProduct @"/Front/app/queryProductForApp.action"
//上传照片
#define kUploadPic @"/Front/servlet/FileSteamUpload"
//查询结果
#define kQuerySample @"/Front/app/querySampleImportMainTableForApp.action"
//查询交付按产品
#define kQueryDelieverProduct @"/Front/app/queryDeliverCountByProduct.action"
//查询交付按客户
#define kQueryDelieverCustom @"/Front/app/queryDeliverCountByCustomer.action"
//查询到样统计按产品
#define kQueryReceiveProduct @"/Front/app/queryReceiveCountByProduct.action"
//查询到样统计按客户
#define kQueryReceiveCustom @"/Front/app/queryReceiveCountByCustomer.action"

#endif /* InterfaceMacro_h */
