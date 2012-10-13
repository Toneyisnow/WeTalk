//
//  SentenceListController.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBConnection.h"
#import "Lesson.h"
#import "Sentence.h"

@interface SentenceListController : UITableViewController {

	Lesson *lesson;
	NSMutableArray *sentenceList;	
}

@property (retain, nonatomic) Lesson *lesson;

-(BOOL) hasPassedSentence:(int)sentenceId;


@end
