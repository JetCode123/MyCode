//
//  ADDelegate.m
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ADDelegate.h"


@implementation ADDelegate
@synthesize data;
@synthesize currentApp;
@synthesize totalCount;
@synthesize tempString;
-(id)init{
	if(self==[super init])
	{
		self.data = [[[NSMutableArray alloc] init] autorelease];
		
		self.tempString=[[[NSMutableString alloc]init]autorelease];
    }
	return self;
}

//开始解析
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	elementName=[elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([elementName isEqualToString:@"AppInfos"]) {
		self.totalCount=[[attributeDict objectForKey:@"TotalCount"] intValue];
	}			 
	else if([elementName isEqualToString:@"AppInfo"]){
		inAppInfo=TRUE;//标识符，标识解析成功！
		self.currentApp=[[[MAd alloc]init]autorelease];
	}
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(inAppInfo)
	{
		[self.tempString appendString:string];
		//叠加值
	}
}
//解析结束
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	elementName=[elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([elementName isEqualToString:@"AppInfo"]){
		inAppInfo=FALSE;//标识符，标识解析成功！
		[self.data addObject:self.currentApp];
		self.currentApp=nil;
	}
	if(inAppInfo){
		NSString *strValue = [self.tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([elementName isEqualToString:@"AppName"]){
			
			currentApp.name = strValue;
			
		}else if([elementName isEqualToString:@"AppLogo"]){
			
			currentApp.logo = strValue;
			
		}else if([elementName isEqualToString:@"AppSourceUrl"]){
			
			currentApp.sourceURL = strValue;
			
		}
		self.tempString = [[[NSMutableString alloc]init]autorelease];
	}
}



-(void)dealloc{
	self.data =nil;
	self.currentApp=nil;
	self.tempString = nil;
	[super dealloc];
	
}

@end
