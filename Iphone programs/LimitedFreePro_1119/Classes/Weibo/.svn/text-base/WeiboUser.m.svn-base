//
//  WeiboUser.m
//  AppNavigator
//
//  Created by Meng Xiangping on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeiboUser.h"
#import "TBXML.h"

@implementation WeiboUser

@synthesize userID = userID_;
@synthesize screenName = screenName_;
@synthesize profileImage = profileImage_;


- (id)initWithXMLString:(NSString *)xmlString{
  
  if((self = [super init])){

    TBXML *tbXML = [TBXML tbxmlWithXMLString:xmlString];
    TBXMLElement *rootElement = tbXML.rootXMLElement;
    
    if(rootElement){
      
      if([TBXML childElementNamed:@"id" parentElement:rootElement] != nil){                                            
       self.userID = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:rootElement]];      
      }
      
      if([TBXML childElementNamed:@"screen_name" parentElement:rootElement] != nil){                                            
        self.screenName = [TBXML textForElement:[TBXML childElementNamed:@"screen_name" parentElement:rootElement]];      
      }
      
      if([TBXML childElementNamed:@"profile_image_url" parentElement:rootElement] != nil){                                            
        self.profileImage = [TBXML textForElement:[TBXML childElementNamed:@"profile_image_url" parentElement:rootElement]];
      }
      
    }
    

  }
  
  return self;
  
}

- (void)dealloc{
  
  self.userID = userID_;
  self.screenName = screenName_;
  self.profileImage = profileImage_;
  [super dealloc];
  
}

@end
