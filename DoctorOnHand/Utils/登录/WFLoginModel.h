//
//  WFLoginModel.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/7/16.
//  Copyright © 2020 sgn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 account = 1113;
 birthday = "0001-01-01 00:00:00";
 department = "\U5916\U79d1";
 deptId = 1401;
 email = "<null>";
 hosiptal = "<null>";
 phone = "<null>";
 photo = "<null>";
 sex = "\U7537";
 token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBcGkiLCJpc3MiOiJXaXNlZmx5IiwibmFtZSI6IjExMTMiLCJuYmYiOjE1OTQ5MDQxNjksImV4cCI6MTU5NDkxMTM2OSwiaWF0IjoxNTk0OTA0MTY5fQ.R9sW7lAJzTvv19yiPNVngTsTrvDdbI8E75y5MMoK-Es";
 type = "<null>";
 userId = 80502;
 username = "\U9648\U5065\U660e";
 wards = "<null>";
 */

@interface WFLoginModel : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *hosiptal;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *wards;

@end

NS_ASSUME_NONNULL_END
