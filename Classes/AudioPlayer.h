//
//  AudioPlayer.h
//  OralTeacher
//
//  Created by sui toney on 10-6-12.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef enum AudioPlayerStatus {
	AudioPlayerStatusIdle		= 0,
	AudioPlayerStatusRunning	= 1,
} AudioPlayerStatus;

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate> {

	AVAudioPlayer* audioPlayer;
	
	AudioPlayerStatus status;
	id delegate;
	bool shouldCallback;
}

- (void)playFileName :(NSString *)fileName callback:(BOOL)callback;
- (void)playFilePath :(NSString *)filePath callback:(BOOL)callback;
- (void)play :(int)lessonId sentence:(int)sentenceId callback:(BOOL)callback;

-(void) setDelegate: (id)dele;

@property AudioPlayerStatus status;

@end
