//
//  WeiboHelper.h
//  AppNavigator
//
//  Created by Meng Xiangping on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "WeiboUser.h"
#import "NSString+URLEncoding.h"
#import "Base64Transcoder.h"

#define URL_REQUEST_TOKEN @"http://api.t.sina.com.cn/oauth/request_token"
#define URL_ACCESS_TOKEN @"http://api.t.sina.com.cn/oauth/access_token"
#define URL_VERIFY @"http://api.t.sina.com.cn/account/verify_credentials.xml"
#define URL_UPLOAD @"http://api.t.sina.com.cn/statuses/upload.xml"
#define URL_UPDATE @"http://api.t.sina.com.cn/statuses/update.xml"

#define OAUTH_CALLBACK @"oauth_callback"
#define OAUTH_CONSUMER_KEY @"oauth_consumer_key"
#define OAUTH_NONCE @"oauth_nonce"
#define OAUTH_SIGNATURE_METHOD @"oauth_signature_method"
#define OAUTH_SIGNATURE @"oauth_signature"
#define OAUTH_TIMESTAMP @"oauth_timestamp"
#define OAUTH_VERSION @"oauth_version"

#define OAUTH_TOKEN @"oauth_token"
#define OAUTH_TOKEN_SECRET @"oauth_token_secret"
#define OAUTH_VERIFIER @"oauth_verifier"

//存储信息
#define kRequestToken @"kRequestToken"
#define kRequestSecret @"kRequestSecret"
#define kUserPin @"kUserPin"
#define kAccessToken @"kAccessToken"
#define kAccessSecret @"kAccessSecret"


//error codes
#define kErrorCode @"error_code"

@interface WeiboHelper : NSObject {
 
	NSInteger errorCode;
	
 @private
  
  NSString *requestMethod_;
  NSString *callback_;
  NSString *consumerKey_;
  NSString *consumerSecret_;
  NSString *nonce_;
  NSString *signature_;
  NSString *timestamp_;
  NSString *version_;
    
  
  NSString *oauthToken_;
  NSString *oauthSecret_;
  
  NSString *userPin_;
  
  NSString *accessToken_;
  NSString *accessSecret_;
  NSString *userID_;
	

  
}

@property (nonatomic) NSInteger errorCode;

@property (nonatomic, retain) NSString *requestMethod;
@property (nonatomic, retain) NSString *callback;
@property (nonatomic, retain) NSString *consumerKey;
@property (nonatomic, retain) NSString *consumerSecret;
@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSString *version;

@property (nonatomic, retain) NSString *oauthToken;
@property (nonatomic, retain) NSString *oauthSecret;
@property (nonatomic, retain) NSString *userPin;

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *accessSecret;
@property (nonatomic, retain) NSString *userID;


+ (WeiboHelper *) sharedHelper;

//生成Base String
- (NSString *) generateBaseString: (NSString *) method 
                              url:(NSString *) url 
                              keyDict: (NSDictionary *) keyDict;

//利用Base String 生成签名
- (NSString *) generateSignature: (NSString *) baseString
                     consumerSecret: (NSString *) consumerSecret 
                     tokenSecret: (NSString *) tokenSecret;


- (NSString *) getBaseString;
- (NSString *) getSignature;
- (NSString *) getUserInfoBaseString;
- (NSString *) getUploadBaseString: (NSString *) text;


- (NSString *) getAccessBaseString;
- (NSString *) getAccessSignature;
- (NSString *) getUserInfoSignature;
- (NSString *) getUploadSignature: (NSString *) text;

- (void) unbindAccount;

//发送新微博
- (void) updateStatus: (NSString *) status;
- (int) uploadImage: (NSString *) status withImage: (UIImage *) pic;

- (void) callbackRequestToken;
- (void) requestToken;
- (void) requestAccessToken;
- (WeiboUser *) requestUserInfo;

- (NSData *) bulidMultiPartFormData: (NSDictionary *) params imageData: (UIImage *) image
boundry: (NSString *)boundry;

@end
