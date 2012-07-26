//
//  AppCommentView.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAppComment.h"

@interface AppCommentView : UIView {
	UILabel *_titleLabel;
	UITextView *_contentTextView;
	UILabel *_dateLabel;
	
	MAppComment *_currentAppComment;
}

@property (nonatomic,retain) UILabel *_titleLabel;
@property (nonatomic,retain) UITextView *_contentTextView;
@property (nonatomic,retain) UILabel *_dateLabel;
@property (nonatomic,retain) MAppComment *_currentAppComment;

-(void)bindItem;

@end
