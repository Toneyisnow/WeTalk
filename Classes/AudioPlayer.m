//
//  AudioPlayer.m
//  OralTeacher
//
//  Created by sui toney on 10-6-12.
//  Copyright 2010 ms. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVAudioPlayer.h>

@implementation AudioPlayer

@synthesize status;

-(id) init {

	self = [super init];
	status = AudioPlayerStatusIdle;
	shouldCallback = FALSE;
	return self;
}

-(void) setDelegate: (id)dele {
	delegate = dele;
}

-(void) play :(int)lessonId sentence:(int)sentenceId callback:(BOOL)callback {

	NSString *fileName = [NSString stringWithFormat:@"audio-%d-%d", lessonId, sentenceId];
	[self playFileName:fileName callback:callback];
}

-(void) playFileName :(NSString *)fileName callback:(BOOL)callback {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    [self playFilePath: path callback:callback];
}
-(void) playFilePath :(NSString *)filePath callback:(BOOL)callback {

	audioPlayer = [[AVAudioPlayer alloc ] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    
	[audioPlayer prepareToPlay];
	[audioPlayer setDelegate:self];
	[audioPlayer play];
	shouldCallback = callback;
	status = AudioPlayerStatusRunning;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

	[audioPlayer release];
	status = AudioPlayerStatusIdle;
	NSLog(@"Audio Play Finished.");
	if(delegate && shouldCallback) {
	
		[delegate playFinished: self];
	}
}


@end
