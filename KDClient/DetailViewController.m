//
//  DetailViewController.m
//  KDClient
//
//  Created by Tair Sabirgaliev on 02.04.11.
//  Copyright 2011 BEE Software. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "DetailTableViewController.h"
#import "NSObject+BeeExtensions.h"
#import "KDClientAppDelegate.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
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
    int baseItems = 1; // only [spring]
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        baseItems = 2; // [reports] + [spring]
    }
    
    NSMutableArray *items = [[[self.toolbar items] subarrayWithRange:NSMakeRange(0, baseItems)] mutableCopy];
    if (self.detailItem != nil) {
        NSString *box = [self.detailItem valueForKey:@"box"];
        if ([box isEqualToString:@"draft"]) {
            [items addObject:self.trashBarItem];
            [items addObject:self.outboxBarItem];
        } else if ([box isEqualToString:@"outbox"]) {
            [items addObject:self.trashBarItem];
            [items addObject:self.draftsBarItem];
        } else if ([box isEqualToString:@"sent"]) {
            // TODO check status button
        } else if ([box isEqualToString:@"trash"]) {
            // TODO delete forever button
        }
    }
    
    [self.toolbar setItems:items animated:YES];
    [items release];
    
    [self.tableViewController.tableView reloadData];
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
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

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

@end
