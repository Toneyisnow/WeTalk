//
//  Lesson.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Lesson : DataModel {

	int _lessonId;
	NSString *_nameCN;
	NSString *_nameEN;
	NSString *_description;	
}
-(id)initWithId:(int)lessonId CN:(NSString *)cn EN:(NSString *)en description:(NSString *)d;

@property  int _lessonId;
@property (retain, nonatomic) NSString *_nameCN;
@property (retain, nonatomic) NSString *_nameEN;

@property (retain, nonatomic) NSString *_description;

@end
