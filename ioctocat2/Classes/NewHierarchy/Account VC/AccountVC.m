



#import "IOCAccountsController.h"
#import "IOCDefaultsPersistence.h"
#import "IOCMyEventsController.h"
#import "IOCMenuController.h"
#import "IOCAccountFormController.h"
#import "GHAccount.h"
#import "GHUser.h"
#import "GHOAuthClient.h"
#import "IOCUserObjectCell.h"
#import "NSURL_IOCExtensions.h"
#import "NSString_IOCExtensions.h"
#import "NSDictionary_IOCExtensions.h"
#import "NSMutableArray_IOCExtensions.h"
#import "iOctocatDelegate.h"
#import "IOCAuthenticationService.h"
#import "IOCTableViewSectionHeader.h"
#import "ECSlidingViewController.h"

//==========v 2
#import "AccountVC.h"
#import "UIImageView+startLoading.h"
#import "UITableViewCell+xibCell.h"
#import "CellOfAccout.h"

#import "nh_baseViewController.h"
#import "nh_menuViewController.h"
#import "nh_contentNavVC.h"
#import "innerDashboardVC.h"

@interface AccountVC () <IOCAccountFormControllerDelegate>

@property(nonatomic,strong)NSMutableDictionary *accountsByEndpoint;//  old  dataAccount  dic

//@property(nonatomic,strong)NSMutableDictionary *accountsByEndpoint_X;//  new  dataAccount

@property (nonatomic,assign)NSInteger indexWaitAction;
//@property(nonatomic,strong)NSIndexPath *indexPathWaitAction;
@end


//===account Obj setup===
#define kGithubAccArr_Inner  ((NSMutableArray *)self.accountsByEndpoint[[[NSURL URLWithString:@"http://github.com"] host]])



@implementation AccountVC


-(void)viewDidLoad
{

    
    [super viewDidLoad];
    
    
    _IB_lblInspired.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                         [UIScreen mainScreen].bounds.size.height-50);
    _IB_lblEGSDesign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                          [UIScreen mainScreen].bounds.size.height-30);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
#warning 暂时屏蔽 1
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(menuMovedOff)
//                                                 name:ECSlidingViewTopDidAnchorRight
//                                               object:nil];
//
    
    if (iOctocatDelegate.sharedInstance.currentAccount) {
        //====不重新  授权
        [self handleAccountsChange];
        [self.tableView reloadData];
        
        return;
        
        //====重新  授权
		iOctocatDelegate.sharedInstance.currentAccount = nil;
	}
	[self handleAccountsChange];
    
	[self.tableView reloadData];
 
    
    // create account if there is none, open account if there is only one
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        if (self.accounts.count == 0) {
            //===自动添加：：：
            [self addAccount:nil];
        } else if (self.accounts.count == 1) {
            //===自动登陆：：：
//            [self authenticateAccountAtIndex:0];
        }
	});
    
    
    self.navigationController.navigationBar.tintColor = COLOR(74 , 77 , 105, 1);
    

    //===IB group 放置到view 外面
    {
        
        _IB_autoLogin.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                           [UIScreen mainScreen].bounds.size.height+30);
        
        _IB_helperLblAuto.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                               [UIScreen mainScreen].bounds.size.height+30);
        
    }

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    //===IB group 放置到view 外面
    {
        _IB_autoLogin.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                           [UIScreen mainScreen].bounds.size.height+30);
        
        _IB_helperLblAuto.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                               [UIScreen mainScreen].bounds.size.height+30);
        
        //==== helper lbl
        _IB_lblInspired.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-50);
        _IB_lblEGSDesign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-30);
    }
    
}
- (void)viewDidAppear:(BOOL)animated {

    //=== 不显示navBar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
#warning 暂时屏蔽 2
    
//	[super viewDidAppear:animated];
//	self.navigationItem.rightBarButtonItem = (self.accounts.count > 0) ? self.editButtonItem : nil;
    
    //==== helper lbl
    _IB_lblInspired.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-50);
    _IB_lblEGSDesign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-30);
    
    
    
    [self performSelector:@selector(animationMake4Lbl)
               withObject:nil
               afterDelay:0.5];
}

-(void)animationMake4Lbl
{
    
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         if (_IB_lblInspired.center.y != [UIScreen mainScreen].bounds.size.height-50)
                         {
                             _IB_lblInspired.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-50);
                             _IB_lblEGSDesign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-30);
                         }
                         
                         
                         _IB_autoLogin.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                                            [UIScreen mainScreen].bounds.size.height-85);
                         
                         _IB_helperLblAuto.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                                                [UIScreen mainScreen].bounds.size.height-63);
                     }];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationItem.rightBarButtonItem = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ECSlidingViewTopDidAnchorRight
                                                  object:nil];
}

- (void)menuMovedOff {
    self.slidingViewController.topViewController = nil;
}

//====真实已登录的  账户 list
- (NSMutableArray *)accounts {
    
    DebugLog(@"%@",iOctocatDelegate.sharedInstance.accounts);
    
    return iOctocatDelegate.sharedInstance.accounts;
}

#pragma mark IOCAccountFormControllerDelegate

- (void)updateAccount:(GHAccount *)account atIndex:(NSUInteger)idx callback:(void (^)(NSUInteger idx))callback {
	// add new account to list of accounts
	if (idx == NSNotFound) {
		[self.accounts addObject:account];
        [self handleAccountsChange];
		if (callback) {
			idx = [self.accounts indexOfObject:account];
			callback(idx);
		}
	} else {
		self.accounts[idx] = account;
        [self handleAccountsChange];
        if (callback) callback(idx);
	}
}

- (void)removeAccountAtIndex:(NSUInteger)idx
                    callback:(void (^)(NSUInteger idx))callback {
    
    if (idx == NSNotFound)
        return;
    
    GHAccount *account = [self.accounts objectAtIndex:idx];
    [IOCDefaultsPersistence removeAccount:account];
    [self.accounts removeObjectAtIndex:idx];
    
	[self handleAccountsChange];
    
    if (callback)
        callback(idx);
}

- (NSUInteger)indexOfAccountWithLogin:(NSString *)login endpoint:(NSString *)endpoint {
    // compare the hosts, because there might be slight differences in the full URL notation
    NSString *endpointHost = [[NSURL ioc_smartURLFromString:endpoint] host];
    return [self.accounts indexOfObjectPassingTest:^(GHAccount *account, NSUInteger idx, BOOL *stop) {
        NSString *accountHost = [[NSURL ioc_smartURLFromString:account.endpoint] host];
        if ([login isEqualToString:account.login] && [endpointHost isEqualToString:accountHost]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
}

#pragma mark Helpers

- (void)handleAccountsChange {
	// persist the accounts
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *encodedAccounts = [NSKeyedArchiver archivedDataWithRootObject:self.accounts];
	[defaults setValue:encodedAccounts forKey:kAccountsDefaultsKey];
	[defaults synchronize];
	// update cache for presenting the accounts
	self.accountsByEndpoint = [NSMutableDictionary dictionary];
	for (GHAccount *account in self.accounts) {
        NSString *endpoint = account.endpoint;
        // FIXME This is only here to stay compatible with old versions upgrading
        // to >= v1.8, because empty endpoints got deprecated with that update.
        // Should get removed once v1.9 gets released.
        
        //====这里的 endpoint 指的是  baseURL
		if (!endpoint || [endpoint ioc_isEmpty])
            endpoint = kGitHubComURL;
        
        // use hosts as key, because there might be slight differences in the full URL notation
        NSString *host = [[NSURL URLWithString:endpoint] host];
		if (!self.accountsByEndpoint[host]) {
			self.accountsByEndpoint[host] = [NSMutableArray array];//========可变mArr
		}
		[self.accountsByEndpoint[host] addObject:account];
	}
    
	// update UI
	self.navigationItem.rightBarButtonItem = (self.accounts.count > 0) ? self.editButtonItem : nil;
    
	if (self.accounts.count == 0)
        self.editing = NO;
}

- (NSUInteger)accountIndexFromIndexPath:(NSIndexPath *)indexPath {
	GHAccount *account = [[self accountsInSection:indexPath.section] objectAtIndex:indexPath.row];
	if (account) {
		return [self.accounts indexOfObject:account];
	} else {
		return NSNotFound;
	}
}

- (NSArray *)accountsInSection:(NSInteger)section {
	NSArray *keys = self.accountsByEndpoint.allKeys;
	NSString *key = keys[section];
	return self.accountsByEndpoint[key];
}

#pragma mark Actions

//====编辑 账户  &&  创建账户
- (void)editAccountAtIndex:(NSUInteger)idx {
    
	GHAccount *account = (idx == NSNotFound) ? [[GHAccount alloc] initWithDict:@{}] : self.accounts[idx];
    
	IOCAccountFormController *viewController = [[IOCAccountFormController alloc] initWithAccount:account
                                                                                        andIndex:idx];
	viewController.delegate = self;
    
    //=== helper method
    {
        [viewController view];
        
        [viewController selectAccountType:({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = 1 ;
            btn;
        })];
    }
    
    //==隐藏 navBar...  egs add
//    [self.navigationController setNavigationBarHidden:YES];
    
    
	[self.navigationController pushViewController:viewController
                                         animated:YES];
    
    
}

- (IBAction)toggleEditAccounts:(id)sender {
	self.tableView.editing = !self.tableView.isEditing;
}

- (IBAction)addAccount:(id)sender {
	[self editAccountAtIndex:NSNotFound];
}

//===== key method:  执行关键登陆授权
- (void)authenticateAccountAtIndex_Last
{
    [self authenticateAccountAtIndex:[self.accounts count]-1];
}

- (void)authenticateAccountAtIndex:(NSUInteger)idx {
	GHAccount *account = self.accounts[idx];
	iOctocatDelegate.sharedInstance.currentAccount = account;
    
	[IOCAuthenticationService authenticateAccount:account
                                          success:^(GHAccount *account) {
                                              
                                              iOctocatDelegate.sharedInstance.currentAccount = account;
                                              
                                              //====旧 的入口
//                                              IOCMenuController *menuController = [[IOCMenuController alloc] initWithUser:account.user];
//                                              [self.navigationController pushViewController:menuController animated:YES];
                                              
                                              //====新的  入口
                                              nh_baseViewController *baseVC = (nh_baseViewController *)AppRoot_VC;
                                              nh_menuViewController *menuVC = (nh_menuViewController *)baseVC.menuViewController;
                                              nh_contentNavVC *navVC = (nh_contentNavVC *)baseVC.contentViewController;
                                              
                                              id innerDash = navVC.topViewController;
                                              
                                              if ([innerDash isKindOfClass:[innerDashboardVC class]]) {
                                                  //标识，初始化 是自己的 powerMap
                                                  innerDashboardVC *innerDash_Yes = (innerDashboardVC *)innerDash;
                                                  innerDash_Yes.isSelf = YES ;
                                                  innerDash_Yes.currLoginName = iOctocatDelegate.sharedInstance.currentAccount.login;
                                              }
                                              else
                                              {
                                                  //====新用户切换，都从 innerDash 开始
                                                  navVC.innerDash_fix.isSelf = YES ;//标识，初始化 是自己的 powerMap
                                                  navVC.innerDash_fix.currLoginName = iOctocatDelegate.sharedInstance.currentAccount.login;
                                                  
                                                  [navVC setViewControllers:@[navVC.innerDash_fix]];
                                              }

                                              
                                              if ([menuVC isKindOfClass:[nh_menuViewController class]]
                                                  &&account.user!=nil) {
                                                  
                                                  
                                                  [menuVC setupUserObj_info:account.user];
                                                  
                                                  [self.navigationController dismissViewControllerAnimated:YES
                                                                                                completion:^{
                                                                                                    
                                                                                                }];
                                              }
                                              
                                              
                                              
                                              
                                              
                                          }
                                          failure:^(GHAccount *account) {
                                              
                                              [iOctocatDelegate reportError:@"Authentication failed"
                                                                       with:@"Please ensure that you are connected to the internet and that your credentials are correct"];
                                              
                                              NSUInteger idx = [self.accounts indexOfObject:account];
                                              
                                              [self editAccountAtIndex:idx];
                                          }];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
//	return self.accountsByEndpoint.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return 5;
    
//	return   [[self accountsInSection:section] count];
    
    NSString *host = [[NSURL URLWithString:@"http://github.com"] host];
    
    return  [self.accounts count]+1; //已经存有的账号 +   add Btn
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.height;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 0;
//    
////    return ([self tableView:tableView titleForHeaderInSection:section]) ? 24 : 0;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
//    return (title == nil) ? nil : [IOCTableViewSectionHeader headerForTableView:tableView title:title];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return self.accountsByEndpoint.allKeys[section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	IOCUserObjectCell *cell = (IOCUserObjectCell *)[tableView dequeueReusableCellWithIdentifier:kUserObjectCellIdentifier];
//	if (!cell) {
//		cell = [IOCUserObjectCell cellWithReuseIdentifier:kUserObjectCellIdentifier];
//		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//	}
//	NSUInteger idx = [self accountIndexFromIndexPath:indexPath];
//	GHAccount *account = self.accounts[idx];
//	cell.userObject = account.user;
//	return cell;
    
    CellOfAccout *cell ;
    
     cell = [CellOfAccout xibCell];
    
    cell.IB_bgView.backgroundColor = RamFlatColor_Shade(0);
    cell.IB_lblName.textColor = cell.IB_bgView.backgroundColor;
    
    //===account Obj setup===
//    NSString *host = [[NSURL URLWithString:@"http://github.com"] host];
//    NSArray *githubAccArr = self.accountsByEndpoint[host];
    
    GHAccount *account = [self.accounts objectAtIndexSavely:indexPath.row];//[self.accounts objectAtIndexSavely:indexPath.row];
    
    if (account) {
        //配置已经账号 list
        [cell setupAccout:account
                         :NO];
        
        if (indexPath.row==0)
            cell.IB_autoFlag.hidden = NO ;
        else
            cell.IB_autoFlag.hidden = YES ;
    }
    else
    {//===配置  add Account btn
        [cell setupAccout:nil
                         :YES];
        
        //==固定颜色
        cell.IB_bgView.backgroundColor = [UIColor flatBlackColor];
        cell.IB_lblName.textColor = cell.IB_bgView.backgroundColor;
        cell.IB_autoFlag.hidden = YES ;
    }
    
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //===account Obj setup===
    NSString *host = [[NSURL URLWithString:@"http://github.com"] host];
    NSArray *githubAccArr = self.accountsByEndpoint[host];
    
    GHAccount *account = [githubAccArr objectAtIndexSavely:indexPath.row];
    
    //=== 执行已经存在账户的授权
    if (account) {
        NSUInteger idx = [self accountIndexFromIndexPath:indexPath];
        [self authenticateAccountAtIndex:idx];
    }
    //====添加账户
    else
    {
        [self addAccount:nil];
    }
    
	
}

#pragma mark Editing

//是否允许：编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"can edit row at %d",indexPath.row);
    if (indexPath.row < [self.accounts count]) {
        return YES;
    }
    
    return NO;
    
}
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//===删除 action
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        //===删除 obj
        [self.tableView beginUpdates];
        
//        [self.accounts removeObjectAtIndex:self.indexWaitAction];
        
        [self removeAccountAtIndex:indexPath.row
                          callback:^(NSUInteger idx) {
                              
                          }];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
       
        
    }
    
}

//===是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DebugLog(@"can move row at %d",indexPath.row);
    
    if (indexPath.row < [self.accounts count]) {
        return YES;
    }
    
    return NO;
}

//===移动操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DebugLog(@"sourceIndexPath %d",sourceIndexPath.row);
    DebugLog(@"destinationIndexPath %d",destinationIndexPath.row);
    
    
    if (sourceIndexPath.row != destinationIndexPath.row
        &&destinationIndexPath.row != [self.accounts count]+1-1
        &&sourceIndexPath.row != [self.accounts count]+1-1)
    {
//        //    需要的移动行
//        NSInteger fromRow = [sourceIndexPath row];
//        //    获取移动某处的位置
//        NSInteger toRow = [destinationIndexPath row];
//        //    从数组中读取需要移动行的数据
//        id object = [self.accounts objectAtIndex:fromRow];
//        //    在数组中移动需要移动的行的数据
//        [self.accounts removeObjectAtIndex:fromRow];
//        //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
//        [self.accounts insertObjectSafely:object atIndex:toRow];
        
        [self.accounts ioc_moveObjectFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];//mArr 的移动
        [self handleAccountsChange];//保存更改 save
        
        //===update account arr
        
    }
    
    [tableView reloadData];
}

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromPath toIndexPath:(NSIndexPath *)toPath {
//    if (toPath.row != fromPath.row) {
//        [self.accounts ioc_moveObjectFromIndex:fromPath.row toIndex:toPath.row];
//        [self handleAccountsChange];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	NSUInteger idx = [self accountIndexFromIndexPath:indexPath];
//	[self editAccountAtIndex:idx];
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
//    if (proposedDestinationIndexPath.section == sourceIndexPath.section) {
//        return proposedDestinationIndexPath;
//    }
//    return sourceIndexPath;
//}


#pragma mark -- main method --
- (IBAction)action_edit:(id)sender {
    
    UIButton *btnSelf = (UIButton *)sender;
    
    if ([btnSelf.titleLabel.text isEqualToString:@"edit"]) {
        
        [btnSelf setTitle:@"done" forState:UIControlStateNormal];
        
        [self.tableView setEditing:YES animated:YES];
    }
    else if ([btnSelf.titleLabel.text isEqualToString:@"done"])
    {
        [btnSelf setTitle:@"edit" forState:UIControlStateNormal];
        
        [self.tableView setEditing:NO animated:YES];
        
//        [self.tableView reloadData];//设定 mainTeam
    }
    
}


@end
