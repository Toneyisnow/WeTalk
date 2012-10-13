//
//  VoiceAnalyzer.h
//  OralTeacher
//
//  Created by sui toney on 10-10-13.
//  Copyright 2010 ms. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "Sentence.h"

@interface VoiceAnalyzer : NSObject {

	NSAutoreleasePool *pool;
}

-(void) DelSilence;
-(void) HCopy;
-(void) HVite2: (NSString *)sourceString;
-(int) GenerateScore;
-(void) teardown;
-(float) ReadScore;

-(void) analyze: (NSString *)sourceString;

@end
