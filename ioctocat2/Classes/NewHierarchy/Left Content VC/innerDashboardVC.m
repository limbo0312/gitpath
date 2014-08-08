//
//  innerDashboardVC.m
//  iOctocat
//
//  Created by Engels on 14-7-27.
//
//

#import "innerDashboardVC.h"
#import "AccountVC.h"

#import "iOctocatDelegate.h"

#import "visualClient.h"
#import "GHAccount.h"

#import "cellOfDash.h"

@interface innerDashboardVC ()

@end

@implementation innerDashboardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //=====判断: 如果 未登陆  则调到账号页面
    if (iOctocatDelegate.sharedInstance.currentAccount==nil) {
        
        AccountVC *accoutVC = [MainSB_New instantiateViewControllerWithIdentifier:@"AccountVC_iden"];
        
        UINavigationController *navVC_accout = [[UINavigationController alloc] initWithRootViewController:accoutVC];
        
        [self presentViewController:navVC_accout
                           animated:NO
                         completion:^{ }];
    }
    
    
    self.title = @"Insight Your Power";
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [[visualClient shareClient] getV_visualizationDataBy:iOctocatDelegate.sharedInstance.currentAccount.login
                                                        :^(BOOL succ) {
                                                            
                                                            if (succ) {
                                                                //===do dataGet3arr drawChart
                                                            };
                                                        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     cellOfDash *cell ;
     
     if (indexPath.row==0) {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash00"];
         
         if (!cell) {
             cell = [cellOfDash xibCell];
         }
         
         //==call & visual data00
         [cell forceDataChart_skillInsight];
     }
     else if (indexPath.row==1)
     {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash01"];
         
         if (!cell) {
             cell = [cellOfDash xibCell_2pos];
         }
     }
     else if (indexPath.row==2)
     {
         
         cell = (cellOfDash *)[tableView dequeueReusableCellWithIdentifier:@"cellOfDash02"];
         
         if (!cell) {
             cell = [cellOfDash xibCell_3pos];
         }
     }
     
 
 // Configure the cell...
 
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.height;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */
@end
