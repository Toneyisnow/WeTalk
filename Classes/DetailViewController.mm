//
//  DetailViewController.m
//  WeTalk
//
//  Created by sui toney on 10-12-23.
//  Copyright 2010 ms. All rights reserved.
//

#import "DetailViewController.h"
#import "AudioCopy/mainroot.h"
#import "Common.h"
#import "DBConnection.h"
#import "Global.h"

@interface DetailViewController()

- (void)HViteFinalize;
- (void)toggleSlideView;
- (void)closeSlideView;
- (void)recordingStart;
- (void)toIdleState;
-(void) updateUserMark :(float)mark;

@end

@implementation DetailViewController

@synthesize sentence;
@synthesize text_en, text_ch, text_py;
@synthesize recorderState;

- (void)viewDidLoad {

	[self initializeData];
}

-(void) viewDidUnload {

	[self finalizeData];
}

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
}

- (void) initializeData {
	
	releasePool = [[NSAutoreleasePool alloc]init];
	// bookList = [[NSArray alloc]init];
	
	recorder = [[VoiceRecorder alloc]init];
	[recorder setDelegate: self];
	
	analyzer = [[VoiceAnalyzer alloc]init];
	
	player = [[AudioPlayer alloc] init];
	[player setDelegate: self];
	
	[self.view sendSubviewToBack:backgroundImage];
	
	self.text_en.text = self.sentence._fulltext_en;
	self.text_ch.text = self.sentence._fulltext_ch;
	self.text_py.text = self.sentence._fulltext_py;
	
	//slideUpView = [[UIView alloc] initWithFrame:frame];
	//[slideUpView setBackgroundColor:[UIColor blackColor]];
	//[slideUpView setOpaque:NO];
	//[slideUpView setAlpha:0.75];
	//slideUpView.visible = true;
	//[[self view] addSubview:slideUpView];
	
	[self toIdleState];
}

- (void) finalizeData {
	
	[recorder release];
	
	//[analyzer teardown];
	[analyzer release];
	
	recorderState = RecorderStateIdle;
}

- (void) toIdleState {

	voiceIndicatorBar.progress = 0;
	recorderProgressIndicatorBar.progress = 0;
	
	voiceIndicatorBtn01.alpha = 0.3;
	voiceIndicatorBtn02.alpha = 0.3;
	voiceIndicatorBtn03.alpha = 0.3;
	voiceIndicatorBtn04.alpha = 0.3;
	voiceIndicatorBtn05.alpha = 0.3;
	voiceIndicatorBtn06.alpha = 0.3;
	voiceIndicatorBtn07.alpha = 0.3;
	voiceIndicatorBtn08.alpha = 0.3;
	voiceIndicatorBtn09.alpha = 0.3;
	voiceIndicatorBtn10.alpha = 0.3;
	voiceIndicatorBtn11.alpha = 0.3;
	voiceIndicatorBtn12.alpha = 0.3;
	voiceIndicatorBtn13.alpha = 0.3;
	voiceIndicatorBtn14.alpha = 0.3;
	
	
	recorderState = RecorderStateIdle;	
}

-(IBAction)recordingBeginStart: (id)sender {
	
	NSLog(@"Playing Lesson=%d Sentence=%d", sentence._lessonId, sentence._sentenceId);
	[player play:sentence._lessonId sentence:sentence._sentenceId callback:TRUE];

}

-(IBAction)playAudio: (id)sender {
	
	NSLog(@"Playing Lesson=%d Sentence=%d", sentence._lessonId, sentence._sentenceId);
	[player play:sentence._lessonId sentence:sentence._sentenceId callback:FALSE];
}

-(IBAction)playBack: (id)sender {
	
	NSLog(@"Playing your voice");
	
	[player playFilePath:[Common ToNSString:[Common TempFile:@"lastrecorded.wav"]] callback:FALSE];
}

-(void)playFinished: (id)sender {
	
	NSLog(@"Audio Finished.");
	
	[self recordingStart];
}

-(IBAction)closeButtonPressed:(id)sender {

	[self closeSlideView];
}

-(void)recordingStart {
	
	NSLog(@"Recorder State : %d", recorderState);
	NSLog(@"Start the thread.");
	recorderState = RecorderStateRunning;
	
	NSThread* myThread = [[NSThread alloc] initWithTarget:recorder
												 selector:@selector(Run)
												   object:nil];
	[myThread start];
	
	// Start the indicator
	[NSThread sleepForTimeInterval:2];	// To skip the first 2 seconds that recorder cannot receive the sound
	//recorderProgressTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 25.0)) target:self selector:@selector(updateIndicator) userInfo:nil repeats:TRUE];

	recorderProgressIndicatorBar.progress = 0;
	[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / 25.0) target:self selector:@selector(updateIndicator) userInfo:nil repeats:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingFinished) name:NSThreadWillExitNotification object:myThread ];	
}

-(void)updateIndicator {

	if(recorderProgressIndicatorBar.progress < 1) {
		recorderProgressIndicatorBar.progress += 0.01;
		[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / 25.0) target:self selector:@selector(updateIndicator) userInfo:nil repeats:NO];
	}
}

-(void)recordingFinished {
	NSLog(@"Recording Exited.");
	
	recorderProgressIndicatorBar.progress = 1.0;
	[analyzerIndicator startAnimating];
	
	//[NSThread sleepForTimeInterval:1];
	
	NSThread* myThread = [[NSThread alloc] initWithTarget:analyzer
												 selector:@selector(analyze:)
												   object:sentence._fulltext_bench];
	[myThread start];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyzeFinished) name:NSThreadWillExitNotification object:myThread ];
}

-(void) analyzeFinished {
	
	NSLog(@"Analyze Finished.");
	//[NSThread sleepForTimeInterval:1];
	
	// At the sametime, save the audio file into lastrecorded.wav
	NSString *src = [Common ToNSString:[Common TempFile:@"delsiled.wav"]];
	NSString *dest = [Common ToNSString:[Common TempFile:@"lastrecorded.wav"]];	
	[Common CopyFile:src toPath:dest];
	
	// Show the results
	//VoiceAnalyzer* analyzer = [[VoiceAnalyzer alloc ]init];
	float finalScore = [analyzer ReadScore];
	NSLog(@"Read score finished.");
	
	[self updateUserMark:finalScore];
	
	//[analyzerIndicator stopAnimating];
	//[self toIdleState];
	//[self closeSlideView];
	
	NSString *msg = [NSString stringWithFormat: @"Your Score: %.3f", finalScore];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Analyze Finished" message:msg
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[msg retain];
	
	// [alert release];
	NSLog(@"Alert shown.");
	//[alert release];
	//[releasePool drain];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

	NSLog(@"Alert closed.");
	[self closeSlideView];
	
}

-(void) HViteFinalize {
	
	PostViterbi();
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)viewClicked:(id) sender {

	[self toggleSlideView];
	[self recordingBeginStart: self];
}

- (void)toggleSlideView {
    
	CGRect bounds = [[self view] bounds];
	float thumbHeight = 200;
	
	// create container view that will hold scroll view and label
	CGRect frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds), bounds.size.width, thumbHeight);
	
	//[creditLabel release];
	CGRect frame2 = [slideUpView frame];
    frame2.origin.y -= frame2.size.height;
    
	[analyzerIndicator stopAnimating];
	[self toIdleState];
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [slideUpView setFrame:frame2];
    [UIView commitAnimations];
	
	//[slideUpView retain];
	
	NSLog(@"Commited");
}

- (void)closeSlideView {

	CGRect frame2 = [slideUpView frame];
    frame2.origin.y += frame2.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [slideUpView setFrame:frame2];
    [UIView commitAnimations];
	
	NSLog(@"Commited");
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight
			);
}
 */

-(void) voiceFeedback:(float)val {

	if(recorderProgressIndicatorBar.progress == 0) {
		return;
	}
	
	float unit = 1/14.0;
	if(val > unit * 1) voiceIndicatorBtn01.alpha = 1.0; else voiceIndicatorBtn01.alpha = 0.3;
	if(val > unit * 2) voiceIndicatorBtn02.alpha = 1.0; else voiceIndicatorBtn02.alpha = 0.3;
	if(val > unit * 3) voiceIndicatorBtn03.alpha = 1.0; else voiceIndicatorBtn03.alpha = 0.3;
	if(val > unit * 4) voiceIndicatorBtn04.alpha = 1.0; else voiceIndicatorBtn04.alpha = 0.3;
	if(val > unit * 5) voiceIndicatorBtn05.alpha = 1.0; else voiceIndicatorBtn05.alpha = 0.3;
	if(val > unit * 6) voiceIndicatorBtn06.alpha = 1.0; else voiceIndicatorBtn06.alpha = 0.3;
	if(val > unit * 7) voiceIndicatorBtn07.alpha = 1.0; else voiceIndicatorBtn07.alpha = 0.3;
	if(val > unit * 8) voiceIndicatorBtn08.alpha = 1.0; else voiceIndicatorBtn08.alpha = 0.3;
	if(val > unit * 9) voiceIndicatorBtn09.alpha = 1.0; else voiceIndicatorBtn09.alpha = 0.3;
	if(val > unit * 10) voiceIndicatorBtn10.alpha = 1.0; else voiceIndicatorBtn10.alpha = 0.3;
	if(val > unit * 11) voiceIndicatorBtn11.alpha = 1.0; else voiceIndicatorBtn11.alpha = 0.3;
	if(val > unit * 12) voiceIndicatorBtn12.alpha = 1.0; else voiceIndicatorBtn12.alpha = 0.3;
	if(val > unit * 13) voiceIndicatorBtn13.alpha = 1.0; else voiceIndicatorBtn13.alpha = 0.3;
	if(val > unit * 14) voiceIndicatorBtn14.alpha = 1.0; else voiceIndicatorBtn14.alpha = 0.3;
		
}

// Update the mark value into Database
-(void) updateUserMark :(float)mark {
	[DBConnection UpdateUserRecord:[[Global getInstance] currentUsername] Lesson:sentence._lessonId Sentence:sentence._sentenceId Mark:mark];
}

@end
