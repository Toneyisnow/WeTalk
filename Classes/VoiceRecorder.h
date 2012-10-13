//
//  VoiceRecorder.h
//  Untitled
//
//  Created by sui toney on 10-3-21.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioQueue.h>

#define kNumberBuffers 3                            // 1

typedef struct AQRecorderState {
    AudioStreamBasicDescription  mDataFormat;                   // 2
    AudioQueueRef                mQueue;                        // 3
    AudioQueueBufferRef          mBuffers[kNumberBuffers];		// 4
    AudioFileID                  mAudioFile;                    // 5
    UInt32                       bufferByteSize;                // 6
    SInt64                       mCurrentPacket;                // 7
    bool                         mIsRunning;                    // 8
} AQRecorderState;

@protocol VoiceRecorderDelegate

-(void) voiceFeedback:(float)val;

@end


@interface VoiceRecorder : NSObject {
	
	AQRecorderState aqData;                                      // 1
	NSAutoreleasePool *pool;
	
	// char* filePath;		// The path and name of the output file
	int maxRunTime;
	int intervalTime;
	
	id<VoiceRecorderDelegate> delegate;
}

-(void)Run;
-(void)Starting;
-(void)Stopping;

-(void)setDelegate:(id<VoiceRecorderDelegate>) dele;

@property int maxRunTime;
@property int intervalTime;

@end



