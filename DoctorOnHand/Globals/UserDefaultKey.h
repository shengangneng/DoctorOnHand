//
//  UserDefaultKey.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/20.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#ifndef UserDefaultKey_h
#define UserDefaultKey_h

//    NSString *url = @"https://auth.jifenzhi.com/oauth/token";

#define kHasLogin       @"hasLogin"     // 是否已经登录
#define kUserName       @"username"     // 记录用户名
#define kPassWord       @"password"     // 记录密码
#define kComyCode       @"comycode"     // 记录社区码
#define kBaseBsco       @"basebscore"   // 记录基础分
#define kAgeScore       @"agescore"     // 记录工龄分
#define kResume         @"resume"       // 选择完组织之后重启标识

#define kAccessToken    @"access_token" // token
#define kRefreshToken   @"refresh_token"// refreshtoken
#define kUserId         @"userId"       // 用户id
#define kCustomNote     @"customNote"   // 登录凭证
#define kServerURL      @"server_url"   // 保存服务器地址
#define kLoginType      @"login_type"   // 登录方式：local和enterprise
#define kName           @"name"         // 真实姓名
#define kRecord         @"record"       // 是否记录用户名和密码
#define kSaveOrgCache   @"save_orgcache"// 是否记录用户名和密码


#endif /* UserDefaultKey_h */
