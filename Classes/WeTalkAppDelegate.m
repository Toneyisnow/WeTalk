//
//  WeTalkAppDelegate.m
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright ms 2010. All rights reserved.
//

#import "WeTalkAppDelegate.h"
#import "MenuViewController.h"
#import "Common.h"

@implementation WeTalkAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	[Common HViteInit];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

