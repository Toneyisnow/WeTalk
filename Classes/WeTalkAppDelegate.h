//
//  WeTalkAppDelegate.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright ms 2010. All rights reserved.
//

@interface WeTalkAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

