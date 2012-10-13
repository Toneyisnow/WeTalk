//
//  DBConnection.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBConnection : NSObject {

}

+ (sqlite3*)openDatabase;

+ (NSMutableArray *) GetLessons;
+ (NSMutableArray *) GetSentences: (int)lessonId;
+ (float) GetUserMark: (NSString *)username Lesson:(int)lessonId Sentence:(int)sentenceId;
+ (void) UpdateUserRecord: (NSString *)username Lesson:(int)lessonId Sentence:(int)sentenceId Mark:(float)mark;
+ (void) execute:(NSString *) sqlStatement database:(sqlite3 *) database;


@end
