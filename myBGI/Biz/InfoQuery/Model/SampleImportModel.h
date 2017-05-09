//
//  SampleImportModel.h
//  InfoCapture
//
//  Created by feng on 21/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleImportModel : NSObject
@property (strong, nonatomic) NSString *sampleName;
@property (strong, nonatomic) NSString *sampleNum;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *customerCode;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *step;
/*
 {"addTest":null,
 "addTestUser":null,
 "addTime":null,
 "address":null,
 "age":"31",
 "area":null,
 "birthDate":null,
 "bloodDateEnd":null,
 "bloodDateStart":null,
 "city":null,
 "closeReason":null,
 "closeUser":null,
 "connectPhone":null,
 "connectSystem":"01",
 "country":null,
 "countrySide":null,
 "createTime":"2017-04-20 14:57:04",
 "createUser":"李蒙蒙",
 "customerCode":"华北石油管理局总医院",
 "idCard":"130982198604277422",
 "idCardType":null,
 "insertListSql":null,
 "isUrgent":"0",
 "lastModifiedTime":"2017-04-20 15:39:58",
 "lastModifiedUser":"SYSTEM",
 "orderBy":null,
 "phoneNum":null,
 "productCode":"DX0459",
 "productCodes":null,
 "productCodesArr":null,
 "productDirection":"遗传性耳聋基因检测",
 "productDirections":null,
 "productLine":"新生儿产品线",
 "productLines":null,
 "productName":"遗传性耳聋4个常见基因检测",
 "productSys":"医学产品",
 "projectCode":null,
 "projectName":null,
 "province":null,
 "reportTimeEnd":null,
 "reportTimeStart":null,
 "result":null,
 "sampleBaseId":"4D6E528678AC0373E053D8E0A8C0DE53",
 "sampleBaseIdStr":null,
 "sampleBaseIds":null,
 "sampleInfoId":"4D6E528678AF0373E053D8E0A8C0DE53",
 "sampleInfoIds":null,
 "sampleInfoIdsArr":null,
 "sampleName":"任杰",
 "sampleNum":"17B0838019",
 "sampleNumStr":null,
 "sampleNums":null,
 "status":"0",
 "step":"00100001",
 "urgentUser":null}
 */
@end
