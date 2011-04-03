//
//  DetailViewController.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 02.04.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "NSObject+BeeExtensions.h"
#import "KDClientAppDelegate.h"
#import "EditingCell.h"
#import "SelectOneCell.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@property (nonatomic, copy) NSIndexPath *prevCellIndex;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;

@synthesize detailItem=_detailItem;

@synthesize popoverController=_myPopoverController;

@synthesize rootViewController=_rootViewController;

@synthesize outboxBarItem=_outboxBarItem;
@synthesize draftsBarItem=_draftsBarItem;
@synthesize trashBarItem=_trashBarItem;

@synthesize tableViewController=_tableViewController;

@synthesize prevCellIndex=_prevCellIndex;

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSManagedObject *)managedObject
{
	if (_detailItem != managedObject) {
		[_detailItem release];
		_detailItem = [managedObject retain];
		
        // Update the view.
        [self configureView];
	}
    
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }		
}

- (void)configureView
{
    self.trashBarItem.enabled = NO;
    if (self.detailItem != nil) {
        NSString *box = [self.detailItem valueForKey:@"box"];
        if ([box isEqualToString:@"draft"]) {
            NSLog(@"asdf");
            self.trashBarItem.enabled = YES;
            [self.navigationItem setRightBarButtonItem:self.outboxBarItem animated:YES];
        } else if ([box isEqualToString:@"outbox"]) {
            self.trashBarItem.enabled = YES;
            [self.navigationItem setRightBarButtonItem:self.draftsBarItem animated:YES];
        } else if ([box isEqualToString:@"sent"]) {
            // TODO check status button
        } else if ([box isEqualToString:@"trash"]) {
            // TODO delete forever button
        }
    }
    
    [self.tableView reloadData];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Events";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolbar.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolbar];
    
}

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [super dealloc];
}

#pragma mark -
#pragma mark Toolbar items actions

- (void) moveReport:(NSManagedObject *)report to:(NSString *)newBox  {
    assert(![[report valueForKey: @"box"] isEqual: newBox]);
    
    [report setValue:newBox forKey:@"box"];
    
    [self.app saveContext];
}

- (IBAction)moveToDrafts:(id)sender {
    [self moveReport:self.detailItem to:@"draft"];
    
    NSManagedObject *object = [self.detailItem retain];
    [self setDetailItem:nil];
    [self setDetailItem:object];
    [object release];
}

- (IBAction)moveToOutbox:(id)sender {
    [self moveReport:self.detailItem to:@"outbox"];
    
    [self setDetailItem:nil];
}

- (IBAction)moveToTrash:(id)sender {
    [self moveReport:self.detailItem to:@"trash"];
    
    [self setDetailItem:nil];
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
        cell.detailViewController = self;
    }
    
    NSString *label = [cellInfo objectForKey:@"label"];
    NSString *field = [cellInfo objectForKey:@"field"];
    [cell useField:field ofManagedObject:self.detailItem];
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
    if (self.detailItem) {
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
