//
//  DetailViewController.h
//  WeTalk
//
//  Created by sui toney on 10-12-23.
//  Copyright 2010 ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sentence.h"
#import "VoiceRecorder.h"
#import "VoiceAnalyzer.h"
#import "AudioPlayer.h"

typedef enum RecorderState {
	RecorderStateIdle			= 0,
	RecorderStateRunning		= 1,
	RecorderStateStarting		= 1 << 1,
	RecorderStateStopping		= 1 << 2,
	RecorderStateInterrupted	= 1 << 3
} RecorderState;


@interface DetailViewController : UIViewController<VoiceRecorderDelegate> {

	Sentence *sentence;
	VoiceRecorder *recorder;
	VoiceAnalyzer *analyzer;
	AudioPlayer *player;
	
	IBOutlet UILabel *text_en;
	IBOutlet UILabel *text_ch;
	IBOutlet UILabel *text_py;
	IBOutlet UIProgressView *voiceIndicatorBar;
	IBOutlet UIProgressView *recorderProgressIndicatorBar;
	IBOutlet UIButton *testButton;
	IBOutlet UIImageView *backgroundImage;
	
	
	IBOutlet UIButton *voiceIndicatorBtn01;
	IBOutlet UIButton *voiceIndicatorBtn02;
	IBOutlet UIButton *voiceIndicatorBtn03;
	IBOutlet UIButton *voiceIndicatorBtn04;
	IBOutlet UIButton *voiceIndicatorBtn05;
	IBOutlet UIButton *voiceIndicatorBtn06;
	IBOutlet UIButton *voiceIndicatorBtn07;
	IBOutlet UIButton *voiceIndicatorBtn08;
	IBOutlet UIButton *voiceIndicatorBtn09;
	IBOutlet UIButton *voiceIndicatorBtn10;
	IBOutlet UIButton *voiceIndicatorBtn11;
	IBOutlet UIButton *voiceIndicatorBtn12;
	IBOutlet UIButton *voiceIndicatorBtn13;
	IBOutlet UIButton *voiceIndicatorBtn14;
	
	RecorderState recorderState;
	
	IBOutlet UIView *slideUpView;
	IBOutlet UIActivityIndicatorView *analyzerIndicator;
	
	NSAutoreleasePool *releasePool;
}

-(IBAction)recordingBeginStart: (id)sender;
-(IBAction)playAudio: (id)sender;
-(IBAction)playBack: (id)sender;
- (IBAction)viewClicked:(id) sender;
	
-(void)initializeData;
-(void)finalizeData;

@property (retain, nonatomic) IBOutlet UILabel *text_en;
@property (retain, nonatomic) IBOutlet UILabel *text_ch;
@property (retain, nonatomic) IBOutlet UILabel *text_py;
@property (retain, nonatomic) Sentence *sentence;
@property RecorderState recorderState;
	
@end
