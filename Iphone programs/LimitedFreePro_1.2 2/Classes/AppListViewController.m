//
//  AppListViewController.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppListViewController.h"
#import "Contants.h"
#import "ImageCache.h"
#import "ImageManipulator.h"
#import "AppListBasedCell.h"
#import "AppDetailsViewController.h"
#import "AppListCellView.h"
#import	"OrderView.h"
#import "VIndicator.h"

#import "VFirstPageLogo.h"
#import "Contants.h"
#import "VTitleAd.h"
#import "MobClick.h"

#import "AppListCell.h"

#define IF [[self._conListDict valueForKey:KEY_ORDER] isEqualToString:@"New"] && [[self._conListDict valueForKey:KEY_CATEGORYID] intValue] == 24 

@interface AppListViewController(PrivateMethods)
- (void)titleAdViewGetData;
@end

@implementation AppListViewController

@synthesize titleAdV;
@synthesize	_adScrollView;
@synthesize _appListArr;
@synthesize _currentPage;
@synthesize _totalPage;
@synthesize _conListDict;
@synthesize _totalCount;
@synthesize _startPosition;
@synthesize isLoading;
@synthesize isReload;
@synthesize haveNetwork;

@synthesize _egoReloadHeaderView;
@synthesize _bottomInfoLabel;
@synthesize _bottomLoadView;
@synthesize iconDownloadProgress;

@synthesize _networkType;
@synthesize _messageView;
@synthesize _appListDownloader;

@synthesize navStatus;
@synthesize _orderToolBar;
@synthesize _category;
@synthesize _selectedIndex;

@synthesize loadImageQueue,returnArrayQueue;
@synthesize isOrderViewOn;

@synthesize _vIndicator;
@synthesize sectionIndexPath;

@synthesize isTitleAdViewLoadOver;

@synthesize showImage;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
AppListCellView *cellView;


#pragma mark -
#pragma mark View lifecycle

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
//	[self.tableView deselectRowAtIndexPath:self._selectedIndex animated:YES];
	AppListBasedCell *cell = (AppListBasedCell *)[self.tableView cellForRowAtIndexPath:self._selectedIndex];
	if(cell){
		[cell setSelected:NO animated:YES];
	}
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == 0){
		return KADVIEWHEIGHT;
	}
	
	else if(indexPath.section == 1){
        if([self._appListArr count] > 0){
            return ROW_HEIGHT;
        }
        
        else
            return 0;
	}
	else{
		return ROW_HEIGHT_FOOT;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0){
		if(IF){
			return 1;
		}
		else 
			return 0;
	}
	else if(section == 1){
		return self._appListArr.count;
	}
	else 
		return 1;
}

//      初始化广告位并设置属性。。
//        for(UIView *view in cell.contentView.subviews){
//            if(view && [view isKindOfClass:[UIImageView class]]){
//                NSLog(@"存在view");
//                [view removeFromSuperview];
//                view = nil;
//            }
//        }

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
		self.sectionIndexPath = indexPath;
		static NSString *adCell = @"headerCell";
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adCell];
		if(cell == nil){
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCell] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guanggbj.png"]];
            
            self._adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(320, 0, cell.frame.size.width, KADVIEWHEIGHT)];
            if(self.titleAdV.hasPage){
                self._adScrollView.frame = CGRectMake(0, 0, cell.frame.size.width, KADVIEWHEIGHT);
            }
            
            self._adScrollView.userInteractionEnabled = YES;
            self._adScrollView.tag = 1;
            self._adScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guanggbj.png"]];   
            self._adScrollView.showsHorizontalScrollIndicator = NO;
            self._adScrollView.showsVerticalScrollIndicator = NO;

            self._adScrollView.delegate = self;
            [cell.contentView addSubview:self._adScrollView];     
            [self._adScrollView release];
            
            self.showImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
            self.showImage.center = CGPointMake(160, KADVIEWHEIGHT / 2);
            self.showImage.image = [UIImage imageNamed:@"jrtjbj1.png"];          // @"今日推荐.png"
            self.showImage.tag = 11;
            [cell.contentView addSubview:self.showImage];
            [self.showImage release];
            
            UIImageView *tuijian = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuijian.png"]];   // @"红色条。png"
            tuijian.frame = CGRectMake(0, 0, 30, 94);
            tuijian.center = CGPointMake(17.5, 94 / 2);
            [cell.contentView addSubview:tuijian];
            [tuijian release];
            
            NSLog(@"今日推荐图片");
		}		

        //    视图层次关系 _adScrollView、showImage(view) 同级关系 --->titleAdV---> 
        
        CGFloat offset_y = self.tableView.contentOffset.y;
        NSLog(@"offset_y = %f",offset_y);
        
        if(offset_y <= 0){
            UIImageView *showImage1;
            switch(titleAdV._page){
                case 1:                    
                    if (self.isTitleAdViewLoadOver == NO){
                        self.isTitleAdViewLoadOver = YES;

                        if(self.titleAdV.hasPage == NO){
                            NSLog(@"Page is 1.");
                            NSLog(@"单元格中加载");
                            
                            showImage1 = (UIImageView *)[cell.contentView viewWithTag:11];
                            CGRect showImgFrame = showImage1.frame;
                            
                            [UIView beginAnimations:@"out the today view" context:nil];
                            [UIView setAnimationDuration:1.2];
                            showImgFrame.origin.x -= 320;
                            [showImage1 setFrame:showImgFrame];
                            [UIView commitAnimations];         
                            
                            self.titleAdV.frame = CGRectMake(0, 0, 320 * titleAdV._page, KADVIEWHEIGHT);
                            [_adScrollView addSubview:self.titleAdV];
                            [_adScrollView setContentSize:CGSizeMake(320 + 5, KADVIEWHEIGHT)];
                            
                            //              TODO:控制3个apps.
                            CGRect scrollViewFrame = _adScrollView.frame;
                            
                            [UIView beginAnimations:@"Left out" context:nil];
                            [UIView setAnimationDuration:1.2];
                            scrollViewFrame.origin.x -= 320;
                            [_adScrollView setFrame:scrollViewFrame];
                            [UIView commitAnimations];
                        
                            self.titleAdV.hasPage = YES;
                        }
                    }
                    break;          
                    
                default:
                    break;
            }
        }
		return cell;
	}

    else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"AppListCell";
        
        AppListCell *cell = (AppListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if(cell == nil){
            cell = [[[AppListBasedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.frame = CGRectMake(0, 0, 320, ROW_HEIGHT);
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.122 green:0.408 blue:0.766 alpha:1.0];
        }
    
        
        cellView = (AppListCellView *)cell._cellContentView;
        cellView._appListVC = self;
        cellView._indexPath = indexPath;
        cellView._tableView = self.tableView;
        cellView._basedCell = cell;
        
        cell._app = [self._appListArr objectAtIndex:indexPath.row];
        cell._orderIndex = indexPath.row + 1;
        
        NSString *_todayString = [AppListCellView stringWithDate:[NSDate date]];
        NSString *_yesterdayString = [AppListCellView stringWithDate:[NSDate dateWithTimeInterval:(- 24 * 60 * 60) sinceDate:[NSDate date]]];
        if([cell._app._appUpdateDateAll isEqualToString:_todayString]){
            cellView._detailLabel.text = @"今日限免";
            cellView._detailImageView.image = [UIImage imageNamed:@"jrxm.png"];
        }
        
        else if([cell._app._appUpdateDateAll isEqualToString:_yesterdayString]){
            cellView._detailImageView.image = [UIImage imageNamed:@"zrxm.png"];
            cellView._detailLabel.text = @"昨日限免";
        }
        
        else{
            cellView._detailImageView.image = [UIImage imageNamed:@"zrxm.png"];
            cellView._detailLabel.text = cell._app._appUpdateDate;
        }
        
        NSString *_id = [NSString stringWithFormat:@"%@",cell._app._appWifiLogoPath];
        UIImage *icon = [ImageCache loadFromCacheWithID:_id andDir:DIR_LIST];
        
        if(icon){
            icon = [ImageManipulator makeRoundCornerImage:icon :30 :30];
            cell._iconImgView.image = icon;
            cell._iconMaskImgView.image = [UIImage imageNamed:@"mask_dark_y.png"];
            [icon release];
        }
        
        else{
            if([self._networkType isEqualToString:@"3g"]){
                icon = [ImageCache loadFromCacheWithID:cell._app._appLogoPath andDir:DIR_LIST];
                if(icon){
                    icon = [ImageManipulator makeRoundCornerImage:icon :15 :15];
                    cell._iconImgView.image = icon;
                    cell._iconMaskImgView.image = [UIImage imageNamed:@"mask_dark_y.png"];
                    [icon release];
                }
                
                else{
                    cell._iconImgView.image	= [UIImage imageNamed:@"mask_dark_y.png"];
                }
            }
            
            else{
                cell._iconImgView.image	= [UIImage imageNamed:@"mask_dark_y.png"];
            }
        }
        
        if(!icon && !self.tableView.dragging && !self.tableView.decelerating){
            
            if([self._networkType isEqualToString:@"Wifi"]){
                [self startIconDownload:cell._app._appWifiLogoPath forIndexPath:indexPath logo:cell._app._appWifiLogo];	
            }
            else if([self._networkType isEqualToString:@"3g"]){
                [self startIconDownload:cell._app._appLogoPath forIndexPath:indexPath logo:cell._app._appLogo];
            }
        }
        return cell;
    }
    
    static NSString *cellin = @"footcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellin];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellin] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:self._bottomLoadView];
        self._bottomLoadView.center = CGPointMake(125, ROW_HEIGHT_FOOT / 2);
        [self._bottomLoadView release];
        
        [cell addSubview:self._bottomInfoLabel];
        [self._bottomInfoLabel release];
    }
    return cell;
}
	

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


/*         
 case 2:
 self._vIndicator = [[VIndicator alloc] initWithFrame:CGRectMake(0, 0, 160 - 20 * (2 - 1) + (2 - 1) * 20, 30)];
 self._vIndicator.center = CGPointMake(160, 100);
 [cell.contentView addSubview:self._vIndicator];
 [self._vIndicator setSelected:0];
 [self._vIndicator release];
 
 self.titleAdV.frame = CGRectMake(0, 0, 320 * titleAdV._page, KADVIEWHEIGHT);
 [_adScrollView addSubview:self.titleAdV];
 
 [_adScrollView setContentSize:CGSizeMake(320 * 2, KADVIEWHEIGHT)];
 break;
 */

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
		if(indexPath.section == 1){
			cell.backgroundColor = (indexPath.row % 2 != 0) ?  [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1] :
			[UIColor whiteColor]; 
		}

}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	if(indexPath.section == 1){
			return indexPath;
		}
		else 
			return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	self._selectedIndex = indexPath;
	
	UITableViewCell *selectedCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	selectedCell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ROW_HEIGHT)] autorelease];
	selectedCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.122 green:0.408 blue:0.766 alpha:1.0];
	
	AppDetailsViewController *_appDetailsVC = [[AppDetailsViewController alloc] init];
	_appDetailsVC._app = [self._appListArr objectAtIndex:indexPath.row];
	
	if(indexPath.row + 1 < [self._appListArr count]){
		_appDetailsVC._nextApp = [self._appListArr objectAtIndex:(indexPath.row + 1)];		
	}
    
	[self.navigationController pushViewController:_appDetailsVC animated:YES];
	[_appDetailsVC release];
	
	if(indexPath.row < 50){
		NSString *dijiwei = [NSString stringWithFormat:@"第%d行",indexPath.row + 1];
		[MobClick event:@"列表前50位" label:dijiwei];
	}
}


#pragma mark -llllllll
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
//    TODO:
    // Releases the view if it doesn't have a superview.
    NSLog(@"收到内存警告");
//    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
	[self._adScrollView release];
	
	self.titleAdV = nil;
	
	[self.sectionIndexPath release];
	self.sectionIndexPath = nil;
	
	[self._appListArr release];
	self._appListArr = nil;
	
	[self._conListDict release];
	self._conListDict = nil;
	
	[self._egoReloadHeaderView release];
	self._egoReloadHeaderView = nil;
	
	[self._bottomInfoLabel release];
	self._bottomInfoLabel = nil;
	
	[self._bottomLoadView release];
	self._bottomLoadView = nil;
	
	[self.iconDownloadProgress release];
	self.iconDownloadProgress = nil;
	
	[self._networkType release];
	self._networkType = nil;
	
	[self._messageView release];
	self._messageView = nil;
	
	
	[self._appListDownloader release];
	self._appListDownloader = nil;
	
	[self._orderToolBar release];
	self._orderToolBar = nil;
	
	[self._category release];
	self._category = nil;
	
	[self._selectedIndex release];
	self._selectedIndex = nil;
	
	self.loadImageQueue = nil;
	self.returnArrayQueue = nil;
	
	[self._vIndicator release];
	self._vIndicator = nil;
	
    [showImage release];
    
    [super dealloc];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	NSLog(@"app-list-controller");
//	self.navigationItem.title = @"限时免费";

	self.loadImageQueue = [[[NSOperationQueue alloc] init] autorelease];
	[self.loadImageQueue setMaxConcurrentOperationCount:1];
	
	returnArrayQueue = [[[NSOperationQueue alloc] init] autorelease];
	[returnArrayQueue setMaxConcurrentOperationCount:1];
	
	
	UIButton *_paixuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_paixuBtn.frame = CGRectMake(320 - 50 - 34, 7, 34, 30);
	[_paixuBtn setBackgroundImage:[UIImage imageNamed:@"paixu.png"] forState:UIControlStateNormal];
	[_paixuBtn addTarget:self action:@selector(paixu_Action) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_paixuBtn] autorelease];
	
	UIButton *_fenleiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_fenleiBtn.frame = CGRectMake(50, 7, 34, 30);
	[_fenleiBtn setBackgroundImage:[UIImage imageNamed:@"fenlei.png"] forState:UIControlStateNormal];
	[_fenleiBtn addTarget:self action:@selector(fenlei_Action) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_fenleiBtn] autorelease];
	
	self.tableView.opaque = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.separatorColor = [UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1];
	
	[self.tableView setRowHeight:ROW_HEIGHT];
	if(self._appListArr == nil){
		self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
		self._networkType = [[NSUserDefaults standardUserDefaults] stringForKey:Key_NetworkType];
		self._appListDownloader = [[AppListDataDownloader alloc] init];
		self._appListDownloader.delegate =self;
		
		self.iconDownloadProgress = [NSMutableDictionary dictionary];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:NETWORK_NOTIFICATION object:nil];
		
        self._conListDict = [NSMutableDictionary dictionary];
		self._appListArr =  [[NSMutableArray alloc] init];
		
		self._currentPage = 1;
	}

	//	self.tableView.separatorStyle = NO;
	//TODO:下拉刷新
	
	[self initHeaderView];
	
	self._bottomInfoLabel = [[UILabel alloc] init];
	self._bottomInfoLabel.backgroundColor = [UIColor clearColor];
	self._bottomInfoLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
	self._bottomInfoLabel.font = [UIFont systemFontOfSize:12];
	
	self._bottomLoadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROW_HEIGHT_FOOT, ROW_HEIGHT_FOOT)];
	self._bottomLoadView.backgroundColor = [UIColor clearColor];
	UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	ind.center = CGPointMake(ROW_HEIGHT_FOOT / 2, ROW_HEIGHT_FOOT / 2);
	[ind startAnimating];
	[self._bottomLoadView addSubview:ind];
	[ind release];
	
	self._bottomLoadView.hidden = YES;
	
	_ov = [[OrderView alloc] initWithFrame:CGRectMake(320, 64, 90, 416)];
	[self.navigationController.view addSubview:_ov];
	[_ov release];
	
	if([self._appListArr count] == 0){
		[self._conListDict setValue:@"New" forKey:KEY_ORDER];
		[self._conListDict setValue:[NSNumber numberWithInt:24] forKey:KEY_CATEGORYID];
		[self._conListDict setValue:[NSNumber numberWithInt:self._startPosition] forKey:KEY_POSITION];
	}
	
	self.titleAdV = [[VTitleAd alloc] init];
	self.titleAdV.delegate = self;
	
	self.titleAdV.userInteractionEnabled = YES;
	self.titleAdV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guanggbj.png"]];
	self.titleAdV._appListVC = self;
	self.titleAdV._networkType = self._networkType;
	self.titleAdV._conListDict = self._conListDict;
	[self.titleAdV release];
}

-(void)titleAdViewLoadingOver{
	NSLog(@"加载完毕");
    
    /*
    if(self.sectionIndexPath != nil){
		if([self numberOfSectionsInTableView:self.tableView] == 3){
            
            if(self.isTitleAdViewLoadOver == NO){
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.sectionIndexPath];
                UIImageView *showImageView = (UIImageView *)[cell.contentView viewWithTag:11];
                
                CGRect rect = showImageView.frame;
                
                [UIView beginAnimations:@"Left-The-Today-view" context:nil];
                [UIView setAnimationDuration:1.2];
                
                rect.origin.x -= 320;
                [showImageView setFrame:rect];
                [UIView commitAnimations];
                
                self.titleAdV.frame = CGRectMake(0, 0, 320, KADVIEWHEIGHT);
                [self._adScrollView addSubview:self.titleAdV];
                [self._adScrollView setContentSize:CGSizeMake(325, KADVIEWHEIGHT)];
                
                CGRect adScrollViewFrame = self._adScrollView.frame;
                
                NSLog(@"ad-scroll-view-frame =  (%.f,%.f,%.f,%.f)",adScrollViewFrame.origin.x,adScrollViewFrame.origin.y,adScrollViewFrame.size.width,adScrollViewFrame.size.height);
                NSLog(@"hasPage === %d",self.titleAdV.hasPage);
                
                if(self.titleAdV.hasPage == NO){
                    [UIView beginAnimations:@"Left-The-Ad-view" context:nil];
                    [UIView setAnimationDuration:1.2];
                    
                    adScrollViewFrame.origin.x -= 320;
                    [self._adScrollView setFrame:adScrollViewFrame];
                    [UIView commitAnimations];
                }
            }
            
            self.titleAdV.hasPage = YES;
            self.isTitleAdViewLoadOver = YES;
        }
    }
     */
}

-(void)networkChange{
	NSLog(@"AppListController网络状态变化");
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
		self.haveNetwork = YES;
	}
	else{
		self.haveNetwork = NO;
		[self.iconDownloadProgress removeAllObjects];
	}
	
	self._networkType = [[NSUserDefaults standardUserDefaults] stringForKey:Key_NetworkType];
//	[self showMessage];
}

-(void)showMessage{
	if(self._messageView == nil){
		self._messageView = [[MessageTool alloc] initWithView:self.navigationController.view];
		[self._messageView release];
		
		[self._messageView showNetworkStatus:self.haveNetwork];
		[self performSelector:@selector(hideMessage) withObject:self afterDelay:2.484888];
	}
}

-(void)hideMessage{
	if(self._messageView != nil){
		[self._messageView hideMessage];
		self._messageView = nil;
	}
}

-(void)dataDidLoad:(NSMutableArray *)appArr{

	[self loadDataEnd:appArr];
	if([appArr count] == 0){
		if(self._currentPage > 1){
			self._currentPage --;
		}
		[self showBottomInfo:5];
		self._totalPage = 0;
	}
}

-(void)downloadError:(NSError *)error{
		
	if(self._currentPage > 1){
		self._currentPage --;
	}
	[self showBottomInfo:4];
	self.isReload = NO;
	self.isLoading = NO;
	
	NSInteger errorCode = [error code];
	if(errorCode == - 1001){
		if([[NSUserDefaults standardUserDefaults] objectForKey:kTotalPageCount] != nil){
			NSNumber *pageNum = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kTotalPageCount];
			self._totalPage = [pageNum intValue];
		}
		
		self._startPosition = self._currentPage * 50 + 1;
		
		if(self._totalCount == 0){
			self._startPosition = 1;
			self._currentPage = 0;
			self._totalPage = 0;
		}
		
		[self._conListDict setValue:[NSNumber numberWithInt:self._startPosition] forKey:KEY_POSITION];
	}
}

-(void) hideLoadStatusMessage{
    if (self._messageView != nil) {
        [self._messageView hideLoadingStatus];
        [self performSelector:@selector(hideMessage) withObject:self afterDelay:1.0];
    }
}

-(void)loadDataEnd:(NSMutableArray *)data{
    
	self._totalCount = [self._appListDownloader getTotalCount];
    
	self._totalPage = self._totalCount % page_size == 0 ? self._totalCount / page_size : self._totalCount / page_size + 1;
//	NSLog(@"%s,totalPage = %i",__FUNCTION__,self._totalPage);
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self._totalPage] forKey:kTotalPageCount];
	
	self._startPosition = [self._appListDownloader getStartPosition];
	[self._conListDict setValue:[NSNumber numberWithInt:self._startPosition] forKey:KEY_POSITION];
	
	self.isLoading = NO;
	
	if(self.isReload){
		//TODO:
		//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];

		[self._appListArr removeAllObjects];
		self.isReload = NO;
		[self.iconDownloadProgress removeAllObjects];
	}
	
	[self._appListArr addObjectsFromArray:data];
	
//  手动删除没有简介的应用。。	
//	NSMutableArray *haveSummaryArray = [NSMutableArray array];
//	for(MApp *m_app in self._appListArr){
//		if(![m_app._appBriefSummary isEqualToString:@""]){
//			[haveSummaryArray addObject:m_app];
//		}
//	}
//	
//	[self._appListArr removeAllObjects];
//	[self._appListArr addObjectsFromArray:haveSummaryArray];
//	self._totalCount = [self._appListArr count];

	
	[self.tableView reloadData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	//调整底部信息
	if(self._currentPage < self._totalPage){
		[self showBottomInfo:2];
	}
	else{
		[self showBottomInfo:3];
	} 
	
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

-(void)doneLoadingTableViewData{
	self.isLoading = NO;
	[self._egoReloadHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

-(void)showBottomInfo:(NSInteger)index{
    self._bottomLoadView.hidden = YES;
    if (index == 1 && self._currentPage > 1) {//正在加载
        self._bottomLoadView.hidden = NO;
        self._bottomInfoLabel.text = @"加载中 . . .";
        CGSize size = [self._bottomInfoLabel.text sizeWithFont:self._bottomInfoLabel.font];
        self._bottomInfoLabel.frame = CGRectMake(180 - size.width / 2, ROW_HEIGHT_FOOT / 2 - size.height / 2,size.width, size.height);
        return;
    }else if(index == 2){//加载完成某一页
        self._bottomInfoLabel.text = @"上拉显示更多";
    }else if(index == 3){//加载完成所有数据
        self._bottomInfoLabel.text = [NSString stringWithFormat:@"共%i款应用",self._totalCount];
    }else if(index == 4){//加载超时
        self._bottomInfoLabel.text = @"加载超时，请重试 . . .";
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    }else if(index == 1 && self._currentPage == 1){
        self._bottomInfoLabel.text = @"正在加载数据，请等待 . . .";
    }
	
	else if(index == 5){
		self._bottomInfoLabel.text= @":-( 暂时没有应用";
	}
    CGSize size = [self._bottomInfoLabel.text sizeWithFont:self._bottomInfoLabel.font];
    self._bottomInfoLabel.frame = CGRectMake(160 - size.width / 2, ROW_HEIGHT_FOOT / 2 - size.height / 2,size.width, size.height);
}


-(void)appImageDidLoad:(NSIndexPath *)indexPath withPath:(NSString *)path{

//  11.11 纠结的问题解决。===（不知道为什么强制转换成了UITableViewCell）
    
    NSInteger section = [indexPath section];
    if(section > 1 || section == 0)
        return;
    
//    NSLog(@"indexPath.section = %d",indexPath.section);
    
	IconDownloader *_iconDownloader = [self.iconDownloadProgress objectForKey:indexPath];

	if(_iconDownloader != nil){

        AppListCell *_cell = (AppListCell *)[self.tableView cellForRowAtIndexPath:indexPath];

        //      获取图标
        UIImage *icon = [ImageCache loadFromCacheWithID:path andDir:DIR_LIST];
		if([self._networkType isEqualToString:@"3g"]){
			icon = [ImageManipulator makeRoundCornerImage:icon :13 :13];
		}
		else{
			icon = [ImageManipulator makeRoundCornerImage:icon :26 :26];
		}
		
		if(_cell != nil){
            _cell._iconImgView.image = icon;
		}

        [icon release];

		[self.iconDownloadProgress removeObjectForKey:indexPath];
	}
}

-(void)initHeaderView{
	self._egoReloadHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,-66, 320, 66)];
	self._egoReloadHeaderView.delegate = self;
	[self.tableView addSubview:self._egoReloadHeaderView];
	[self._egoReloadHeaderView release];
	
	self._egoReloadHeaderView.backgroundColor = [UIColor whiteColor];
}

#pragma mark EGORefreshTableHeaderView delegate methods.
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
	return self.isLoading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    //return [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
	return [NSDate date];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
	NSLog(@"trigger");
	if(self.haveNetwork){
		[self reloadData];
	}
	else{
		[self showMessage];
		[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3];
	}
}

-(void)reloadData{ 
    
    if(self.titleAdV){
        self.titleAdV.hasPage = NO;
    }
    
	if(!self.isLoading){
		self._totalPage = 0;
		self._totalCount = 0;

		self.isReload = YES;
		self._currentPage = 1;
		self._startPosition = 1;
	
		
		[self._conListDict setValue:[NSNumber numberWithInt:1] forKey:KEY_POSITION];
		[self getDataByPageId:self._currentPage];
		
        [self titleAdViewGetData];
        
//		[self performSelector:@selector(titleAdViewGetData) withObject:nil afterDelay:0];
	}
}

-(void)titleAdViewGetData{
	if([[self._conListDict valueForKey:KEY_ORDER] isEqualToString:@"New"] && [[self._conListDict valueForKey:KEY_CATEGORYID] intValue] == 24)
		[titleAdV asynInit];
}

-(void)getDataByPageId:(NSInteger)page{

	self.isLoading = YES;
	[self showBottomInfo:1];
	[self loadData];
}

-(void)loadData{
	
}

# pragma mark UIScrollViewDelegate.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//	CGFloat pageWidth;
//	NSUInteger pageIndex;
//	if(scrollView == _adScrollView){
//		pageWidth = _adScrollView.frame.size.width;
//		pageIndex =  floor((_adScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//		[self._vIndicator setSelected:pageIndex];
//		
//		self.titleAdV.userInteractionEnabled = NO;
//	}
	
	if(scrollView == _adScrollView){
		self.titleAdV.userInteractionEnabled = NO;
	}
	
	[self._egoReloadHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
	if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height){
		if(!self.isLoading && self._currentPage < self._totalPage){
			if(!self.haveNetwork){
				[self showMessage];
				return;
			}
			self._currentPage ++;
						
			[self getDataByPageId:self._currentPage];
		}
	}
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[self loadImagesForOnscreenRows];
	[self._egoReloadHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if(scrollView == _adScrollView){
		self.titleAdV.userInteractionEnabled = YES;
	}
	[self loadImagesForOnscreenRows];
}

-(void)loadImagesForOnscreenRows{
	if([self._appListArr count] > 0){
		NSArray *_visiblePaths = [self.tableView indexPathsForVisibleRows];
        
		for(NSIndexPath *indexPath in _visiblePaths){
			MApp *app = [self._appListArr objectAtIndex:indexPath.row];
			
			BOOL haveImage = [ImageCache haveImageWithPath:app._appWifiLogoPath andDir:DIR_LIST];
			if(!haveImage){
				if([self._networkType isEqualToString:@"Wifi"]){
					[self startIconDownload:app._appWifiLogoPath forIndexPath:indexPath logo:app._appWifiLogo];
				}
				else if([self._networkType isEqualToString:@"3g"]){
					haveImage = [ImageCache haveImageWithPath:app._appLogoPath andDir:DIR_LIST];
					
					if(!haveImage){
						[self startIconDownload:app._appLogoPath forIndexPath:indexPath logo:app._appLogo];
					}
				}
			}
		}
	}
}

- (void)startIconDownload:(NSString *)path forIndexPath:(NSIndexPath *)indexPath logo:(NSString *)logo{
	IconDownloader *iconDownloader = [self.iconDownloadProgress objectForKey:indexPath];
	
	if(iconDownloader == nil){
		iconDownloader = [[IconDownloader alloc] init];
		iconDownloader._iconPath = logo;
		iconDownloader._path = path;
		iconDownloader._indexPathInTableView = indexPath;
        iconDownloader.delegate = self;

		[self.iconDownloadProgress setObject:iconDownloader forKey:iconDownloader._indexPathInTableView];
		[iconDownloader startDownload];
		[iconDownloader release];
	}
}

-(void)clickReload{
	
	NSLog(@"self.isReload = %d",self.isReload);
	
	if(self.haveNetwork){
		if(self.isReload) 
			return;

		self.tableView.contentOffset = CGPointMake(0, -66);
		[self._egoReloadHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
	}
	
	else{
		[self showMessage];
	}
}

-(void)paixu_Action{
}
-(void)pushAction{}

-(void)expandOut{}
-(void)drawBack{}

@end

