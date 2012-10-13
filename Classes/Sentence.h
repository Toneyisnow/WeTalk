//
//  Sentence.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Sentence : DataModel {

	int _sentenceId;
	int _lessonId;
	
	NSString* _name;
	NSString* _fulltext_en;
	NSString* _fulltext_ch;
	NSString* _fulltext_py;
	
	NSString* _fulltext_bench;
}

-(id)initWithId:(int)sentenceId lesson:(int)lessonId name:(NSString *)n En:(NSString *)e Ch:(NSString *)c Py:(NSString *)p Ben:(NSString *)ben;

@property  int _sentenceId;
@property  int _lessonId;
@property (retain, nonatomic) NSString *_name;
@property (retain, nonatomic) NSString *_fulltext_en;
@property (retain, nonatomic) NSString *_fulltext_ch;
@property (retain, nonatomic) NSString *_fulltext_py;
@property (retain, nonatomic) NSString *_fulltext_bench;

@end
