//
//  DBConnection.m
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import "DBConnection.h"
#import "Lesson.h"
#import "Sentence.h"
#import "Common.h"

@implementation DBConnection

+ (sqlite3*)openDatabase
{
	sqlite3* instance;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"dat"];
    
	if (sqlite3_open([path UTF8String], &instance) != SQLITE_OK) {
		sqlite3_close(instance);
        NSLog(@"Failed to open database. (%s)", sqlite3_errmsg(instance));
        return nil;
    }        
    return instance;
}

+ (NSMutableArray *) GetLessons {
	
	NSLog(@"Get Lessons.");
	
	NSMutableArray *lessons = [[NSMutableArray alloc] init];
	
	const char *sqlStatement = "select id,namecn,nameen,description from lessons;";
	sqlite3_stmt *compiledStatement;
	
	sqlite3 *database = [self openDatabase];
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSString *aId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			NSString *aNameCN = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
			NSString *aNameEN = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			NSString *aDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
			
			Lesson *lesson = [[Lesson alloc] initWithId:[aId intValue] CN:aNameCN EN:aNameEN description:aDescription];
			[lessons addObject:lesson];
		}
	}
	sqlite3_close(database);
	
	return lessons;
}

+ (NSMutableArray *) GetSentences: (int)lessonId {
	
	NSMutableArray *sentences = [[NSMutableArray alloc] init];
	NSString *tempStr = [NSString stringWithFormat:@"select id,lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench from sentences where lessonid=%d;", lessonId];
	
	char *sqlStatement = [Common ToCString:tempStr];
	NSLog(@"SQL statement: %s", sqlStatement);
	
	sqlite3_stmt *compiledStatement;
	sqlite3 *database = [self openDatabase];
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSString *aId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			NSString *aLessonId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
			NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			NSString *fulltext_en = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
			NSString *fulltext_ch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
			NSString *fulltext_py = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
			NSString *fulltext_bench = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
			
			// NSLog(@"Name: %@", aName);
			
			Sentence *sentence = [[Sentence alloc] initWithId:[aId intValue] lesson:[aLessonId intValue] name:aName En:fulltext_en Ch:fulltext_ch Py:fulltext_py Ben:fulltext_bench];
			[sentences addObject:sentence];
		}
	}
	sqlite3_close(database);
	
	return sentences;
}

+ (float) GetUserMark: (NSString *)username Lesson:(int)lessonId Sentence:(int)sentenceId {

	NSString *tempStr = [NSString stringWithFormat:@"select recordMark from userrecords where username='%@' and lessonid=%d and sentenceid=%d;", username, lessonId, sentenceId];
	char *sqlStatement = [tempStr cStringUsingEncoding:1];
	NSLog(@"SQL statement: %s", sqlStatement);
	
	float usermark = 0;
	sqlite3_stmt *compiledStatement;
	sqlite3 *database = [self openDatabase];
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			//usermark = (float)sqlite3_column_text(compiledStatement, 0);
		}
	}
	sqlite3_close(database);
	
	return usermark;
}

+ (void) UpdateUserRecord: (NSString *)username Lesson:(int)lessonId Sentence:(int)sentenceId Mark:(float)mark {

	NSString *sqlStatement = [NSString stringWithFormat:@"select username, recordMark from userrecords where username='%@' and lessonid=%d and sentenceid=%d;", username, lessonId, sentenceId];
	char *cStatement = [Common ToCString:sqlStatement];
	NSLog(@"SQL statement: %s", cStatement);
	
	// float oldMark = 0;
	sqlite3_stmt *compiledStatement;
	sqlite3 *database = [self openDatabase];
	if(sqlite3_prepare_v2(database, cStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// char *user = (char *)sqlite3_column_text(compiledStatement, 0);
		}
	}
	
	// TODO: not finished yet
	
	sqlStatement = [NSString stringWithFormat:@"insert into userrecords (username, lessonid, sentenceid, recordmark) values ('%@', %d, %d, %f);", username, lessonId, sentenceId, mark];
	[DBConnection execute:sqlStatement database:database];
	
	sqlStatement = @"select username from userrecords;";
	cStatement = [Common ToCString:sqlStatement];
	NSLog(@"SQL statement: %s", sqlStatement);
	
	if(sqlite3_prepare_v2(database, cStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			char *val = (char *)sqlite3_column_text(compiledStatement, 0);
			
			NSLog(@"Username: %@", [Common ToNSString:val]);
		}	
	}
	
	sqlite3_close(database);
	
}

+(void) execute:(NSString *) sqlStatement database:(sqlite3 *) database {

	char *cStatement = [Common ToCString:sqlStatement];
	NSLog(@"SQL statement: %s", cStatement);
	
	char *errmsg;
	if (sqlite3_exec(database, cStatement, NULL, NULL, &errmsg) != SQLITE_OK) {
        // ignore error
        NSLog(@"SQL Error: (%s)", errmsg);
    }
	
}





@end
