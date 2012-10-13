//
//  Sentence.m
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import "Sentence.h"


@implementation Sentence

@synthesize _sentenceId, _lessonId;
@synthesize _name, _fulltext_en, _fulltext_ch, _fulltext_py, _fulltext_bench;

-(id)initWithId:(int)sentenceId lesson:(int)lessonId name:(NSString *)n En:(NSString *)e Ch:(NSString *)c Py:(NSString *)p Ben:(NSString *)ben {
	
	self = [super init];
	self._sentenceId = sentenceId;
	self._lessonId = lessonId;
	self._name = n;
	self._fulltext_en = e;
	
	self._fulltext_ch = c;
	self._fulltext_py = p;
	//self._wavFilePath = wav;
	self._fulltext_bench = ben;
	return self;	
}

@end
