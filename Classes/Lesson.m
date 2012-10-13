//
//  Lesson.m
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import "Lesson.h"


@implementation Lesson

@synthesize _lessonId, _nameCN, _nameEN, _description;

-(id)initWithId:(int)lessonId CN:(NSString *)cn EN:(NSString *)en description:(NSString *)d {
	
	self = [super init];
	self._lessonId = lessonId;
	self._nameCN = cn;
	self._nameEN = en;
	self._description = d;
	
	return self;
}

@end
