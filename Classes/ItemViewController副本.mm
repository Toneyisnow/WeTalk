//
//  ItemViewController.m
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import "ItemViewController.h"
#import "VoiceAnalyzer.h"
#import "AudioPlayer.h"
#import "AudioCopy/mainroot.h"

@interface ItemViewController()

-(void) HViteFinalize;

@end

@implementation ItemViewController

@synthesize sentence;
@synthesize text_en, text_ch, text_py;
@synthesize recorderState;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self initializeData];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	[self finalizeData];
}

- (void) initializeData {
	// bookList = [[NSArray alloc]init];
	
	recorder = [[VoiceRecorder alloc]init];
	self.text_en.text = self.sentence._fulltext_en;
	self.text_ch.text = self.sentence._fulltext_ch;
	self.text_py.text = self.sentence._fulltext_py;
	
	recorderState = RecorderStateIdle;	
}

- (void) finalizeData {
	
	recorderState = RecorderStateIdle;
}

-(IBAction)recordingBeginStart: (id)sender {
	
	NSLog(@"Playing Lesson=%d Sentence=%d", sentence._lessonId, sentence._sentenceId);
	AudioPlayer *player = [[AudioPlayer alloc] init];
	[player setDelegate: self];
	[player play:sentence._lessonId sentence:sentence._sentenceId];

	
	NSLog(@"Recorder State : %d", recorderState);
	NSLog(@"Start the thread.");
	recorderState = RecorderStateRunning;
	
	NSThread* myThread = [[NSThread alloc] initWithTarget:recorder
												 selector:@selector(Run)
												   object:nil];
	[myThread start];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingFinished) name:NSThreadWillExitNotification object:myThread ];	
}

-(void)recordingFinished
{
	NSLog(@"Recording Exited.");
	[NSThread sleepForTimeInterval:1];
	
	
	VoiceAnalyzer* analyzer = [[VoiceAnalyzer alloc ]init];
	NSThread* myThread = [[NSThread alloc] initWithTarget:analyzer
												 selector:@selector(HCopy)
												   object:nil];
	[myThread start];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hcopyFinished) name:NSThreadWillExitNotification object:myThread ];
}

-(void) hcopyFinished {
	
	NSLog(@"HCopy Finished.");
	[NSThread sleepForTimeInterval:1];
	
	@try {
		VoiceAnalyzer* analyzer = [[VoiceAnalyzer alloc ]init];
		NSThread* myThread = [[NSThread alloc] initWithTarget:analyzer
													 selector:@selector(HVite2:)
													   object:sentence._fulltext_bench];
		[myThread start];
		
		// Notification for the thread exits
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hviteFinished) name:NSThreadWillExitNotification object:myThread ];
		
	}
	@catch (NSException *e) {
		NSLog(@"Exception: %@", [e reason]);
	}
}

-(void) hviteFinished {
	
	NSLog(@"HVite Finished.");
	[NSThread sleepForTimeInterval:1];
	
	// Show the results
	VoiceAnalyzer* analyzer = [[VoiceAnalyzer alloc ]init];
	float finalScore = [analyzer ReadScore];
	
	NSString *msg = [NSString stringWithFormat: @"Your Score: %.3f", finalScore];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Analyze Finished" message:msg
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	@try {
		[analyzer DeleteTempFiles];
	}
	@catch (NSException *e) {
		NSLog(@"Exception: %@", [e reason]);
	}
}

-(void) HViteFinalize {
	
	PostViterbi();
}

-(IBAction)playAudio: (id)sender {
	
	NSLog(@"Playing Lesson=%d Sentence=%d", sentence._lessonId, sentence._sentenceId);
	AudioPlayer *player = [[AudioPlayer alloc] init];
	[player play:sentence._lessonId sentence:sentence._sentenceId];
}

-(IBAction)playBack: (id)sender {
	
	NSLog(@"Playing Lesson=%d Sentence=%d", sentence._lessonId, sentence._sentenceId);
	AudioPlayer *player = [[AudioPlayer alloc] init];
	[player play:sentence._lessonId sentence:sentence._sentenceId];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end
