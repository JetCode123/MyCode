//
//  WeiboHelper.m
//  AppNavigator
//
//  Created by Meng Xiangping on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeiboHelper.h"


@implementation WeiboHelper

@synthesize errorCode;

@synthesize requestMethod = requestMethod_;
@synthesize callback = callback_;
@synthesize consumerKey = consumerKey_;
@synthesize consumerSecret = consumerSecret_;
@synthesize nonce = nonce_;
@synthesize signature = signature_;
@synthesize timestamp = timestamp_;
@synthesize version = version_;

@synthesize oauthToken = oauthToken_;
@synthesize oauthSecret = oauthSecret_;
@synthesize userPin = userPin_;

@synthesize accessToken = accessToken_;
@synthesize accessSecret = accessSecret_;
@synthesize userID = userID_;

static WeiboHelper *sharedHelper;

#pragma mark 私有方法
- (NSString *) _generateNonce 
{
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef string = CFUUIDCreateString(NULL, theUUID);
  NSMakeCollectable(theUUID);
  return (NSString *)string;
}

- (NSString *) _escapeURL: (NSString *) url{
  
  return [[url stringByReplacingOccurrencesOfString:@":" withString:@"%3A"] 
          stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
  
}

- (NSString *) _signClearText:(NSString *)text withSecret:(NSString *)secret 
{
  NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
  NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
  unsigned char result[20];
  CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
  
  //Base64 Encoding
  
  char base64Result[32];
  size_t theResultLength = 32;
  Base64EncodeData(result, 20, base64Result, &theResultLength);
  NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
  
  NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
  return [base64EncodedResult autorelease];
  
}

+(NSString *) urlencode: (NSString *) url
{
  NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                          @"@" , @"&" , @"=" , @"+" ,
                          @"$" , @"," , @"[" , @"]",
                          @"#", @"!", @"'", @"(", 
                          @")", @"*", nil];
  
  NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                           @"%3A" , @"%40" , @"%26" ,
                           @"%3D" , @"%2B" , @"%24" ,
                           @"%2C" , @"%5B" , @"%5D", 
                           @"%23", @"%21", @"%27",
                           @"%28", @"%29", @"%2A", nil];
  
  int len = [escapeChars count];
  
  NSMutableString *temp = [url mutableCopy];
  
  int i;
  for(i = 0; i < len; i++)
  {
    
    [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                          withString:[replaceChars objectAtIndex:i]
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [temp length])];
  }
  
  NSString *out = [NSString stringWithString: temp];
  
  return out;
}

#pragma init method

+ (WeiboHelper *)sharedHelper{
  
  if(sharedHelper == nil){

    sharedHelper = [[WeiboHelper alloc] init];
      
    sharedHelper.oauthToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRequestToken];
    sharedHelper.oauthSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kRequestToken]; 
    sharedHelper.userPin = [[NSUserDefaults standardUserDefaults] objectForKey:kUserPin];
    sharedHelper.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    sharedHelper.accessSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessSecret];

  }
  
  return sharedHelper;
  
}

- (void)unbindAccount{
  
  self.oauthToken = nil;
  self.oauthSecret = nil;
  self.userPin = nil;
  self.userID = nil;
  self.accessToken = nil;
  self.accessSecret = nil;
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRequestToken];  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRequestSecret];    
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPin];      
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessSecret];
  
}

- (id)init{
  
  if((self = [super init])){
    self.callback = @"http://xml.app111.com/common/SinaCallback.html";
//    self.consumerKey = @"2792275292";
//    self.consumerSecret = @"ddfb0e07435de517eff8c603831c5be0";
      self.consumerKey = @"4200447883";
      self.consumerSecret = @"a39c635c00817a28dd5d3caeb64080e6";    

    self.nonce = [self _generateNonce];
    self.signature = @"HMAC-SHA1";
    self.timestamp = @"1272323042";
    self.version = @"1.0";
  }
  
  return self;
  
}

- (void)dealloc{
  
  self.requestMethod = nil;
  self.callback = nil;
  self.consumerKey = nil;
  self.consumerSecret = nil;
  self.nonce = nil;
  self.signature = nil;
  self.timestamp = nil;
  self.version = nil;
  self.oauthToken = nil;
  self.oauthSecret = nil;
  self.userPin = nil;
  
  self.accessToken = nil;
  self.accessSecret = nil;
  self.userID = nil;
  [super dealloc];
}

NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
  if (*(BOOL *)reverse == YES) {
    return [string2 localizedCaseInsensitiveCompare:string1];
  }
  return [string1 localizedCaseInsensitiveCompare:string2];
}

- (NSString *)generateBaseString:(NSString *)method url:(NSString *)url keyDict:(NSDictionary *)keyDict{
  
  NSMutableString *baseString = [[NSMutableString alloc] init];
  [baseString appendString:method];
  [baseString appendString:@"&"];
  [baseString appendString:[WeiboHelper urlencode:url]];
  [baseString appendString:@"&"];


  BOOL reverseSort = NO;
  NSArray *keyArray = [[keyDict allKeys] sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
  
  NSMutableString *paramString = [[NSMutableString alloc] init];
  
  for(int i = 0;i < [keyArray count];i++){
    
    [paramString appendFormat:@"%@=%@",[keyArray objectAtIndex:i],
     [keyDict valueForKey:[keyArray objectAtIndex:i]]];
    
    if(i < [keyArray count] - 1){
      [paramString appendFormat:@"&"];
    }
    
  }
  
  [baseString appendString:[paramString URLEncodedString]];
  [paramString release];
  //  NSLog(@"base string %@",baseString);
  return [baseString autorelease];
  
}

- (NSString *)getBaseString{
  
  NSMutableString *baseString = [[NSMutableString alloc] init];
  [baseString appendString:self.requestMethod];
  [baseString appendString:@"&"];
  [baseString appendString:[self _escapeURL:@"http://api.t.sina.com.cn/oauth/request_token&"]]; //  
  
//  [baseString appendFormat:@"oauth_callback%%3D%@%%26",[WeiboHelper urlencode:self.callback]];  
  [baseString appendFormat:@"oauth_consumer_key%%3D%@%%26",self.consumerKey];
  [baseString appendFormat:@"oauth_nonce%%3D%@%%26",self.nonce];
  [baseString appendFormat:@"oauth_signature_method%%3D%@%%26",self.signature];
  [baseString appendFormat:@"oauth_timestamp%%3D%@%%26",self.timestamp];
  [baseString appendFormat:@"oauth_version%%3D%@",self.version];

//  NSLog(@"base string %@",baseString);
  return [baseString autorelease];
  
}

- (NSString *)getAccessBaseString{
  
  NSMutableString *baseString = [[NSMutableString alloc] init];
  [baseString appendString:@"GET"];
  [baseString appendString:@"&"];
  [baseString appendString:[self _escapeURL:URL_ACCESS_TOKEN]];
  [baseString appendString:@"&"];
  [baseString appendFormat:@"oauth_consumer_key%%3D%@%%26",self.consumerKey];
  [baseString appendFormat:@"oauth_nonce%%3D%@%%26",self.nonce];
  [baseString appendFormat:@"oauth_signature_method%%3D%@%%26",self.signature];
  [baseString appendFormat:@"oauth_timestamp%%3D%@%%26",self.timestamp];
  [baseString appendFormat:@"oauth_token%%3D%@%%26",self.oauthToken];
  [baseString appendFormat:@"oauth_token_secret%%3D%@%%26",self.oauthSecret];
  [baseString appendFormat:@"oauth_verifier%%3D%@%%26",self.userPin];
  [baseString appendFormat:@"oauth_version%%3D%@",self.version];

//  NSLog(@"base %@",baseString);
  return [baseString autorelease];
  
}

- (NSString *)getUserInfoBaseString{

  NSMutableString *baseString = [[NSMutableString alloc] init];
  [baseString appendString:@"GET"];
  [baseString appendString:@"&"];
  [baseString appendString:[self _escapeURL:URL_VERIFY]];
  [baseString appendString:@"&"];
  [baseString appendFormat:@"oauth_consumer_key%%3D%@%%26",self.consumerKey];
  [baseString appendFormat:@"oauth_nonce%%3D%@%%26",self.nonce];
  [baseString appendFormat:@"oauth_signature_method%%3D%@%%26",self.signature];
  [baseString appendFormat:@"oauth_timestamp%%3D%@%%26",self.timestamp];
  [baseString appendFormat:@"oauth_token%%3D%@%%26",self.accessToken];  
  [baseString appendFormat:@"oauth_version%%3D%@%%26",self.version];
  [baseString appendFormat:@"source%%3D%@",self.consumerKey];  
//  NSLog(@"userbase %@",baseString);
  return [baseString autorelease];
  
}

- (NSString *)getUploadBaseString:(NSString *)text{
  
  NSMutableString *baseString = [[NSMutableString alloc] init];
  [baseString appendString:@"POST"];
  [baseString appendString:@"&"];
  [baseString appendString:[self _escapeURL:URL_UPLOAD]];
  [baseString appendString:@"&"];
  [baseString appendFormat:@"oauth_consumer_key%%3D%@%%26",self.consumerKey];
  [baseString appendFormat:@"oauth_nonce%%3D%@%%26",self.nonce];
  [baseString appendFormat:@"oauth_signature_method%%3D%@%%26",self.signature];
  [baseString appendFormat:@"oauth_timestamp%%3D%@%%26",self.timestamp];
  [baseString appendFormat:@"oauth_token%%3D%@%%26",self.accessToken];  
  [baseString appendFormat:@"oauth_version%%3D%@%%26",self.version];
  [baseString appendFormat:@"source%%3D%@%%26",self.consumerKey];  
  [baseString appendFormat:@"status%%3D%@",text];

  return [baseString autorelease];
  
}

- (NSString *)generateSignature:(NSString *)baseString consumerSecret:(NSString *)consumerSecret tokenSecret:(NSString *)tokenSecret{
  
  if(tokenSecret == nil){
    
    return [WeiboHelper urlencode:[self _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&",consumerSecret]]];
    
  }else{
    return [WeiboHelper urlencode:[self _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&%@",consumerSecret,tokenSecret]]];
    
  }
 
}

- (NSString *)getSignature{
  
//  NSString *baseString = [self getBaseString];
  NSString *baseString = [self generateBaseString:@"GET" url:URL_REQUEST_TOKEN keyDict:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             self.consumerKey,OAUTH_CONSUMER_KEY,
                             self.nonce, OAUTH_NONCE,
                             self.signature, OAUTH_SIGNATURE_METHOD,
                             self.timestamp, OAUTH_TIMESTAMP,
                             self.version, OAUTH_VERSION,nil
                             ]];
  
  return [WeiboHelper urlencode:[self  _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&",self.consumerSecret]]];
//  return [[self  _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&",self.consumerSecret]] stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
  
}

- (NSString *)getAccessSignature{
  
  NSString *baseString = [self getAccessBaseString];
  return [WeiboHelper urlencode:[self  _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&%@",self.consumerSecret,self.oauthSecret]]];
  
}

- (NSString *)getUserInfoSignature{

  NSString *baseString = [self getUserInfoBaseString];
  return [WeiboHelper urlencode:[self  _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&%@",self.consumerSecret,self.accessSecret]]];
  
}

- (NSString *)getUploadSignature:(NSString *)text{
  
  NSString *baseString = [self getUploadBaseString:text];
  return [WeiboHelper urlencode:[self  _signClearText:baseString withSecret:[NSString stringWithFormat:@"%@&%@",self.consumerSecret,self.accessSecret]]];
  
}

- (void)callbackRequestToken{
  
  NSString *baseString = [self generateBaseString:@"GET" url:URL_REQUEST_TOKEN keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           [self.callback URLEncodedString],OAUTH_CALLBACK,
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.version, OAUTH_VERSION,nil
                           ]];
  
  
  NSString *url = [NSString stringWithFormat:@"http://api.t.sina.com.cn/oauth/request_token?oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@&oauth_signature=%@",
                   [self.callback URLEncodedString],
                   self.consumerKey,
                   self.nonce,
                   self.signature,
                   self.timestamp,
                   self.version,
                   [self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:nil]];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  NSURLResponse *response;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	  
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
  
  if([responseString rangeOfString:@"oauth_token"].location != NSNotFound){
    
    NSArray *tokenArray = [responseString componentsSeparatedByString:@"&"];
    if([tokenArray count] == 2){
      
      NSArray *token = [[tokenArray objectAtIndex:0] componentsSeparatedByString:@"="];
      NSArray *tokenSecret = [[tokenArray objectAtIndex:1] componentsSeparatedByString:@"="];
      
      if([token count] == 2){
        self.oauthToken = [token objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthToken forKey:kRequestToken];
      }
      
      if([tokenSecret count] == 2){
        
        self.oauthSecret = [tokenSecret objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthSecret forKey:kRequestSecret];        
        
      }
      
    }
    
  }
  
  [request release];

  
  
}

- (void) requestToken{
    
  NSString *baseString = [self generateBaseString:@"GET" url:URL_REQUEST_TOKEN keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.version, OAUTH_VERSION,nil
                           ]];
  
  
  NSString *url = [NSString stringWithFormat:@"http://api.t.sina.com.cn/oauth/request_token?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@&oauth_signature=%@",
                   self.consumerKey,
                   self.nonce,
                   self.signature,
                   self.timestamp,
                   self.version,
                   [self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:nil]];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  NSURLResponse *response;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
//  NSLog(@"resp %@",responseString);
    
  if([responseString rangeOfString:@"oauth_token"].location != NSNotFound){
    
    NSArray *tokenArray = [responseString componentsSeparatedByString:@"&"];
    if([tokenArray count] == 2){

      NSArray *token = [[tokenArray objectAtIndex:0] componentsSeparatedByString:@"="];
      NSArray *tokenSecret = [[tokenArray objectAtIndex:1] componentsSeparatedByString:@"="];

      if([token count] == 2){
        self.oauthToken = [token objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthToken forKey:kRequestToken];
      }

      if([tokenSecret count] == 2){

        self.oauthSecret = [tokenSecret objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthSecret forKey:kRequestSecret];        
        
      }
      
    }
    
  }

  [request release];

}

- (void)requestAccessToken{


  NSString *baseString = [self generateBaseString:@"GET" url:URL_ACCESS_TOKEN keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.oauthToken, OAUTH_TOKEN,
                           self.oauthSecret, OAUTH_TOKEN_SECRET,
                           self.userPin, OAUTH_VERIFIER,
                           self.version, OAUTH_VERSION,nil
                           ]];
  
  NSString *url = [NSString stringWithFormat:
                   @"%@?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_token_secret=%@&oauth_verifier=%@&oauth_version=%@&oauth_signature=%@",
                   URL_ACCESS_TOKEN,                   
                   self.consumerKey,                   
                   self.nonce,
                   self.signature,
                   self.timestamp,
                   self.oauthToken,
                   self.oauthSecret,
                   self.userPin,
                   self.version,
                   [self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:self.oauthSecret]];


  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  NSURLResponse *response;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

  if([responseString rangeOfString:@"oauth_token"].location != NSNotFound){
    
    NSArray *tokenArray = [responseString componentsSeparatedByString:@"&"];
    if([tokenArray count] >= 3){
      
      NSArray *token = [[tokenArray objectAtIndex:0] componentsSeparatedByString:@"="];
      NSArray *tokenSecret = [[tokenArray objectAtIndex:1] componentsSeparatedByString:@"="];
      NSArray *userID = [[tokenArray objectAtIndex:2] componentsSeparatedByString:@"="];
      
      if([token count] == 2){
        self.accessToken = [token objectAtIndex:1];
      }
      
      if([tokenSecret count] == 2){
        
        self.accessSecret = [tokenSecret objectAtIndex:1];
        
      }
      
      if([userID count] == 2){
        self.userID = [userID objectAtIndex:1];
      }
      
    }
    
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessToken];
  [[NSUserDefaults standardUserDefaults] setObject:self.accessSecret forKey:kAccessSecret];
  
//  NSLog(@"access info %@ %@ %@",self.accessToken,self.accessSecret,self.userID);
  
  [request release];

  
}

- (WeiboUser *)requestUserInfo{

    
  NSString *baseString = [self generateBaseString:@"GET" url:URL_VERIFY keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.accessToken, OAUTH_TOKEN,
                           self.version, OAUTH_VERSION,
                           self.consumerKey,@"source",nil
                           ]];
  
  NSString *url = [NSString stringWithFormat:
                   @"%@?oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_token=%@&oauth_timestamp=%@&oauth_version=%@&oauth_signature=%@&source=%@",
                   URL_VERIFY,
                   self.consumerKey,                   
                   self.nonce,
                   self.signature,
                   self.accessToken,
                   self.timestamp,
                   self.version,
                   [self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:self.accessSecret],
                   self.consumerKey];

//  NSLog(@"info url %@",url);
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  NSURLResponse *response;
	NSError *error;
	
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

  WeiboUser *user = [[WeiboUser alloc] initWithXMLString:responseString];
//  self.userID = user.userID;
  return [user autorelease];
//  NSLog(@"%@ %@ %@",user.userID,user.screenName,user.profileImage);
//  NSLog(@"user info %@",responseString);
  
}

- (void)updateStatus:(NSString *)status{
  
  
  NSString *baseString = [self generateBaseString:@"POST" url:URL_UPDATE keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.accessToken, OAUTH_TOKEN,
                           self.version, OAUTH_VERSION,
                           self.consumerKey,@"source",
                           [status URLEncodedString],@"status",
                           nil
                           ]];

  NSString *params = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_token=%@&oauth_timestamp=%@&oauth_version=%@&oauth_signature=%@&source=%@&status=%@",self.consumerKey,
                      self.nonce,
                      self.signature,
                      self.accessToken,
                      self.timestamp,
                      self.version,
                      [self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:self.accessSecret],
                      self.consumerKey,
                      [status URLEncodedString]];
  
  NSString *url = URL_UPDATE;

  //NSData *paramData = [NSData dataWithBytes:[params UTF8String] length:[params length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
  NSURLResponse *response;
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"responseString = %@",responseString);
}

- (NSData *)bulidMultiPartFormData:(NSDictionary *)params imageData:(UIImage *)image boundry:(NSString *)boundry{
  
  NSMutableData *postData = [[NSMutableData alloc] init];

  BOOL reverseSort = NO;
  NSArray *keyArray = [[params allKeys] sortedArrayUsingFunction:alphabeticSort context:&reverseSort];  
  //NSArray *keyArray = [params allKeys];
  
  for(int i = 0;i < [keyArray count];i++){
    
    [postData appendData:
     [[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:
     [[NSString stringWithFormat:
       @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [keyArray objectAtIndex:i]]
      dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[params valueForKey:[keyArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
  }
  
  [postData appendData:
   [[NSString stringWithFormat:@"--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
  
//  NSLog(@"%@",[[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease]);
  
  return [postData autorelease];
  
}

- (int)uploadImage:(NSString *)status withImage:(UIImage *)pic{
  
  NSString *baseString = [self generateBaseString:@"POST" url:URL_UPLOAD keyDict:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           self.consumerKey,OAUTH_CONSUMER_KEY,
                           self.nonce, OAUTH_NONCE,
                           self.signature, OAUTH_SIGNATURE_METHOD,
                           self.timestamp, OAUTH_TIMESTAMP,
                           self.accessToken, OAUTH_TOKEN,
                           self.version, OAUTH_VERSION,
                           [status URLEncodedString], @"status",
                           nil]];
  
//  NSLog(@"basestring %@",baseString);
  
  NSString *params = [NSString stringWithFormat:@"OAuth %@=\"%@\", %@=\"%@\", %@=\"%@\", %@=\"%@\", %@=\"%@\", %@=\"%@\", %@=\"%@\"",
                      OAUTH_CONSUMER_KEY,self.consumerKey,
                      OAUTH_TOKEN,self.accessToken,                      
                      OAUTH_SIGNATURE_METHOD,self.signature,                      
                      OAUTH_SIGNATURE,[self generateSignature:baseString consumerSecret:self.consumerSecret tokenSecret:self.accessSecret],                                            
                      OAUTH_TIMESTAMP,self.timestamp,
                      OAUTH_NONCE,self.nonce,
                      OAUTH_VERSION,self.version
                      ];
//  NSLog(@"%@",params);
  NSString *url = URL_UPLOAD;
//  NSString *url = [NSString stringWithFormat:@"%@?source=%@",URL_UPLOAD,self.consumerKey];

  
  NSString *boundry = @"WEIBOIMAGE";
  //NSData *paramData = [NSData dataWithBytes:[params UTF8String] length:[params length]];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
                                  initWithURL:[NSURL URLWithString:url]];
  [request setHTTPMethod:@"POST"];
  [request setValue:params forHTTPHeaderField:@"Authorization"];
  [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
    forHTTPHeaderField:@"Content-Type"];

  NSMutableData *postData = [[NSMutableData alloc] init];
  
  //status
  [postData appendData:
   [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"status\"\r\n", 
     boundry] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:
   [[NSString stringWithFormat:@"Content-Type: text/plain; charset=UTF-8\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:
   [[NSString stringWithFormat:@"Content-Transfer-Encoding: 8bit\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[status dataUsingEncoding:NSUTF8StringEncoding]];
  [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

  //source
//  [postData appendData:
//   [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"source\"\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
//  [postData appendData:
//   [[NSString stringWithFormat:@"Content-Type: text/plain; charset=UTF-8\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//  [postData appendData:
//   [[NSString stringWithFormat:@"Content-Transfer-Encoding: 8bit\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//  [postData appendData:[self.consumerKey dataUsingEncoding:NSUTF8StringEncoding]];
//  [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

  //image
  [postData appendData:
   [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"pic\"; filename=\"logo.jpg\"\r\nContent-Type: image/jpeg; charset=UTF-8\r\n\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSData *imageData = UIImageJPEGRepresentation(pic, 1.0);

  [postData appendData:[NSData dataWithData:imageData]];

  [postData appendData:
     [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];

  [request setHTTPBody:postData];

  
  NSURLResponse *response;
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
  if([responseString rangeOfString:kErrorCode].location == NSNotFound){
    
    return 0;
    
  }else{
      if([responseString rangeOfString:@"400"].location != NSNotFound){
          return -1;
      }else{
          return -2;
      }
  }
}

@end
