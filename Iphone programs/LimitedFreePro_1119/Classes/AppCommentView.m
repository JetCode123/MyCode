//
//  AppCommentView.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppCommentView.h"


@implementation AppCommentView

@synthesize _titleLabel;
@synthesize _contentTextView;
@synthesize _dateLabel;
@synthesize _currentAppComment;

- (void)dealloc {
	self._currentAppComment = nil;
	self._titleLabel = nil;
	self._dateLabel = nil;
	
	[self._contentTextView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self._titleLabel = [[UILabel alloc] init];
		self._titleLabel.frame = CGRectMake(0, 0, 190, 20);
		self._titleLabel.textColor = [UIColor colorWithRed:31.0/255 green:132.0/255 blue:238.0/255 alpha:1];
		self._titleLabel.font = [UIFont systemFontOfSize:13.f];
		self._titleLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self._titleLabel];
		[self._titleLabel release];
		
		self._dateLabel = [[UILabel alloc] init];
		self._dateLabel.frame = CGRectMake(195, 2, 90, 20);
		self._dateLabel.textColor = [UIColor darkGrayColor];
		self._dateLabel.font = [UIFont systemFontOfSize:11.f];
		self._dateLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self._dateLabel];
		[self._dateLabel release];
		
		self._contentTextView = [[UITextView alloc] init];
		self._contentTextView.frame = CGRectMake(-8, 15, 300, 20);
		self._contentTextView.userInteractionEnabled = NO;
		self._contentTextView.textAlignment = UITextAlignmentLeft;
		self._contentTextView.font = [UIFont systemFontOfSize:13.f];
		self._contentTextView.backgroundColor = [UIColor clearColor];
		[self addSubview:self._contentTextView];
		[self._contentTextView release];
	}
    return self;
}

-(void)bindItem{
	if(self._currentAppComment != nil){
		self._titleLabel.text = [NSString stringWithFormat:@"网友说: %@",self._currentAppComment._commTitle];
		self._contentTextView.text = [self._currentAppComment._commContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		
		NSArray *_dateArr = [self._currentAppComment._commPubDate componentsSeparatedByString:@"/"];
        
		if([_dateArr count] == 3){
			self._dateLabel.text = [NSString stringWithFormat:@"%i年%i月%i日",[[_dateArr objectAtIndex:2] intValue],[[_dateArr objectAtIndex:0] intValue],[[_dateArr objectAtIndex:1] intValue]];
		}
		
		self._contentTextView.frame = CGRectMake(self._contentTextView.frame.origin.x, self._contentTextView.frame.origin.y
												 , self._contentTextView.frame.size.width, self._contentTextView.contentSize.height);
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/




@end
