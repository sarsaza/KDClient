//
//  DetailTableViewController.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 02.04.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailViewController.h"
#import "NSObject+BeeExtensions.h"
#import "KDClientAppDelegate.h"
#import "EditingCell.h"
#import "SelectOneCell.h"

@interface DetailTableViewController ()
- (UITableViewCell *)tableView:(UITableView *)tableView plainCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView editingCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView selectOneCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) NSIndexPath *prevCellIndex;
@end

@implementation DetailTableViewController

@synthesize detailViewController=_detailViewController;
@synthesize prevCellIndex=_prevCellIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Cell type support

- (UITableViewCell *)tableView:(UITableView *)tableView plainCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat: @"Cell-%i-%i", indexPath.section, indexPath.row];
    NSString *label = [cellInfo objectForKey:@"label"];
    NSString *sample = [cellInfo objectForKey:@"sample"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];    
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	cell.textLabel.text = label;
	cell.detailTextLabel.text = sample;
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView editingCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat: @"Cell-%i-%i", indexPath.section, indexPath.row];
    
	EditingCell *cell = (EditingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EditingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];    
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailViewController = self.detailViewController;
    }
    
    NSString *label = [cellInfo objectForKey:@"label"];
    NSString *field = [cellInfo objectForKey:@"field"];
    [cell useField:field ofManagedObject:self.detailViewController.detailItem];
	cell.textLabel.text = label;
    //    cell.textField.text = sample;
    //    cell.textField.keyboardType = type;
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView selectOneCellWithInfo:(NSDictionary *)cellInfo indexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat: @"Cell-%i-%i", indexPath.section, indexPath.row];
    
    NSString *label = [cellInfo objectForKey:@"label"];
    NSString *sample = [cellInfo objectForKey:@"sample"];
    
	SelectOneCell *cell = (SelectOneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SelectOneCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	cell.textLabel.text = label;
	cell.detailTextLabel.text = sample;
    cell.detailViewController = self;
	return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailViewController.detailItem) {
        return [[self.app.uiInfo objectForKey:@"sections"] count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[self.app.uiInfo objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"cells"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.app.uiInfo objectForKey:@"sections"] objectAtIndex:section] objectForKey:@"label"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    NSDictionary *sectionInfo = [[self.app.uiInfo objectForKey:@"sections"] objectAtIndex:indexPath.section]; 
    NSDictionary *cellInfo = [[sectionInfo objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    NSString *type = [cellInfo objectForKey:@"type"];
    
    if ([type isEqual:@"text"]) {
        cell = [self tableView:tableView editingCellWithInfo:cellInfo indexPath:indexPath];
    } else if ([type isEqual:@"dictionary"]) {
        cell = [self tableView:tableView selectOneCellWithInfo:cellInfo indexPath:indexPath];
    } else if ([type isEqual:@"plain"]) {
        cell = [self tableView:tableView plainCellWithInfo:cellInfo indexPath:indexPath];
    } else {
        NSLog(@"cell type '%@' is unknown!", type);
    }
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:indexPath];
    if (![nextCell isEdit]) {
        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.prevCellIndex];
        self.prevCellIndex = indexPath;
        [prevCell endEdit];
        [nextCell startEdit];
    }
}

@end
