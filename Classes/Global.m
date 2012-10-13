//
//  Global.m
//  WeTalk
//
//  Created by sui toney on 10-12-31.
//  Copyright 2010 ms. All rights reserved.
//

#import "Global.h"

@implementation Global

static Global *_instance = nil;

@synthesize currentUsername;
@synthesize passMark;

+(Global *) getInstance {

	@synchronized(self)
    {
		if(_instance == nil) {
			_instance = [[Global alloc] init];
		}
	}
	return _instance;
}

-(id) init {

	self = [super init];
	self.passMark = 60.0;
	NSLog(@"Pass mark:%f", passMark);
	
	return self;
}


@end
