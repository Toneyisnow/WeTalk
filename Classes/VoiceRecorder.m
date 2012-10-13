//
//  VoiceRecorder.m
//  Untitled
//
//  Created by sui toney on 10-3-21.
//  Copyright 2010 ms. All rights reserved.
//

#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioConverter.h>
#import "VoiceRecorder.h"
#import "Common.h"
#import <string.h>

@implementation VoiceRecorder

@synthesize	maxRunTime, intervalTime;

id refToSelf;

-(VoiceRecorder *)init {

	self = [super init];
	maxRunTime = 5;
	intervalTime = 1;
	
	refToSelf = self;
	return self;
}

-(void)setDelegate:(id<VoiceRecorderDelegate>) dele {

	delegate = dele;
}

-(void) callback:(int)val {
	//NSLog(@"Value: %d", val);
	//float param = val / 100.0;
	
	//[delegate performSelectorOnMainThread:@selector(voiceFeedback:) withObject:&param waitUntilDone:NO];  
	[delegate voiceFeedback:val/100.0];
	
	
}

void HandleInputBuffer (
						void                                 *aqData,
						AudioQueueRef                        inAQ,
						AudioQueueBufferRef                  inBuffer,
						const AudioTimeStamp                 *inStartTime,
						UInt32                               inNumPackets,
						const AudioStreamPacketDescription   *inPacketDesc
						) 
{
    AQRecorderState *pAqData = (AQRecorderState *) aqData;               // 1
	
    if (inNumPackets == 0 &&                                             // 2
		pAqData->mDataFormat.mBytesPerPacket != 0)
		inNumPackets =
		inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
	
	//NSLog(@"%d %s", strlen(inBuffer->mAudioData), inBuffer->mAudioData);
	[refToSelf callback:strlen(inBuffer->mAudioData)];
	if (AudioFileWritePackets (                                          // 3
							   pAqData->mAudioFile,
							   false,
							   inBuffer->mAudioDataByteSize,
							   inPacketDesc,
							   pAqData->mCurrentPacket,
							   &inNumPackets,
							   inBuffer->mAudioData
							   ) == noErr) {
		pAqData->mCurrentPacket += inNumPackets;                     // 4
    }
		
	if (pAqData->mIsRunning == 0)                                         // 5
		return;
	
    AudioQueueEnqueueBuffer (                                            // 6
							 pAqData->mQueue,
							 inBuffer,
							 0,
							 NULL
							 );
}


-(void) Run {
	
	// This is needed in the multiple thread model
	pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
	
	[self Starting];
	
	// Recording...And wait for be interrupted
	int currentTime = 0;
	while (currentTime <= maxRunTime) {
		
		NSLog(@"Checking recorder state...");
		
		[NSThread sleepForTimeInterval:intervalTime];
		currentTime += intervalTime;
	}
	
	NSLog(@"Recorder State is stopping.");
	
	[self Stopping];
}

-(void)Starting {

	NSLog(@"Voice Recorder Starting.");
	NSString *filePathString = [NSString stringWithFormat:@"%@/original.wav", [Common GetTempDir]];
	const char *filePath = [filePathString cStringUsingEncoding: NSASCIIStringEncoding];
	
	NSLog(@"File Path: %s", filePath);
	
	aqData.mDataFormat.mFormatID = kAudioFormatLinearPCM;        // 2
	//aqData.mDataFormat.mFormatID = kAudioFormatALaw;        // 2
	
	aqData.mDataFormat.mSampleRate = 8000.0;                    // 3
	aqData.mDataFormat.mChannelsPerFrame = 1;                    // 4
	aqData.mDataFormat.mBitsPerChannel = 16;                     // 5
	aqData.mDataFormat.mBytesPerPacket =                         // 6
	aqData.mDataFormat.mBytesPerFrame =
	aqData.mDataFormat.mChannelsPerFrame * sizeof (SInt16);
	aqData.mDataFormat.mFramesPerPacket = 1;                     // 7
	
	//AudioFileTypeID fileType = kAudioFileAIFFType;               // 8
	AudioFileTypeID fileType = kAudioFileWAVEType;               // 8
	
	/*
	 aqData.mDataFormat.mFormatFlags =                            // 9
     kLinearPCMFormatFlagIsSignedInteger
	 | kLinearPCMFormatFlagIsPacked;
	*/
	
	 aqData.mDataFormat.mFormatFlags =                            // 9
	kLinearPCMFormatFlagIsSignedInteger
	| kAudioFormatFlagIsPacked;
	
	/*
	aqData.mDataFormat.mFormatFlags =                            // 9
    //kAudioFormatFlagIsBigEndian |
    kAudioFormatFlagIsSignedInteger
    | kAudioFormatFlagIsPacked;
	*/
	
	// Create a Audio Queue
	AudioQueueNewInput (                              // 1
						&aqData.mDataFormat,                          // 2
						HandleInputBuffer,                            // 3
						&aqData,                                      // 4
						NULL,                                         // 5
						kCFRunLoopCommonModes,                        // 6
						0,                                            // 7
						&aqData.mQueue                                // 8
						);
	
	UInt32 dataFormatSize = sizeof (aqData.mDataFormat);       // 1
	AudioQueueGetProperty (                                    // 2
						   aqData.mQueue,                                           // 3
						   NULL, //kAudioConverterCurrentOutputStreamDescription,           // 4
						   &aqData.mDataFormat,                                     // 5
						   &dataFormatSize                                          // 6
						   );
	
	// Create file
	CFURLRef audioFileURL =
    CFURLCreateFromFileSystemRepresentation (            // 1
											 NULL,                                            // 2
											 (const UInt8 *) filePath,                        // 3
											 strlen (filePath),                               // 4
											 false                                            // 5
											 );
	
	AudioFileCreateWithURL (                                 // 6
							audioFileURL,                                        // 7
							fileType,                                            // 8
							&aqData.mDataFormat,                                 // 9
							kAudioFileFlags_EraseFile,                           // 10
							&aqData.mAudioFile                                   // 11
							);
	
	// Derive buffer size
	/*
	 DeriveBufferSize (                               // 1
	 aqData.mQueue,                               // 2
	 aqData.mDataFormat,                          // 3
	 0.5,                                         // 4
	 &aqData.bufferByteSize                       // 5
	 );
	 */
	
	// Prepare the buffers
	UInt32 defaultBufferByteSize = 0x500;
	for (int i = 0; i < kNumberBuffers; ++i) {           // 1
		AudioQueueAllocateBuffer (                       // 2
								  aqData.mQueue,                               // 3
								  defaultBufferByteSize,                       // 4
								  &aqData.mBuffers[i]                          // 5
								  );
		
		AudioQueueEnqueueBuffer (                        // 6
								 aqData.mQueue,                               // 7
								 aqData.mBuffers[i],                          // 8
								 0,                                           // 9
								 NULL                                         // 10
								 );
	}
	
	// Start Recording
	aqData.mCurrentPacket = 0;                           // 1
	aqData.mIsRunning = true;                            // 2
	AudioQueueStart (                                    // 3
					 aqData.mQueue,                                   // 4
					 NULL                                             // 5
					 );

}

-(void)Stopping {

	// Wait, on user interface thread, until user stops the recording
	AudioQueueStop (                                     // 6
					aqData.mQueue,                                   // 7
					true                                             // 8
					);
	aqData.mIsRunning = false;                           // 9
	
	// Clean up
	AudioQueueDispose (                                 // 1
					   aqData.mQueue,                                  // 2
					   true                                            // 3
					   );
	AudioFileClose (aqData.mAudioFile);                 // 4
	
	// This is needed in the multiple thread model
	[pool release];  // Release the objects in the pool.

}

OSStatus SetMagicCookieForFile (
								AudioQueueRef inQueue,                                      // 1
								AudioFileID   inFile                                        // 2
								) {
    OSStatus result = noErr;                                    // 3
    UInt32 cookieSize;                                          // 4
	
    if (
		AudioQueueGetPropertySize (                         // 5
								   inQueue,
								   kAudioQueueProperty_MagicCookie,
								   &cookieSize
								   ) == noErr
		) {
        char* magicCookie =
		(char *) malloc (cookieSize);                       // 6
        if (
			AudioQueueGetProperty (                         // 7
								   inQueue,
								   kAudioQueueProperty_MagicCookie,
								   magicCookie,
								   &cookieSize
								   ) == noErr
			)
            result =    AudioFileSetProperty (                  // 8
											  inFile,
											  kAudioFilePropertyMagicCookieData,
											  cookieSize,
											  magicCookie
											  );
        free (magicCookie);                                     // 9
    }
    return result;                                              // 10
}



@end
