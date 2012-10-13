//
//  ItemViewController.h
//  WeTalk
//
//  Created by sui toney on 10-12-19.
//  Copyright 2010 ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sentence.h"
#import "VoiceRecorder.h"

typedef enum RecorderState {
	RecorderStateIdle			= 0,
	RecorderStateRunning		= 1,
	RecorderStateStarting		= 1 << 1,
	RecorderStateStopping		= 1 << 2,
	RecorderStateInterrupted	= 1 << 3
} RecorderState;

@interface ItemViewController : UIViewController {

	Sentence *sentence;
	VoiceRecorder *recorder;
	
	IBOutlet UILabel *text_en;
	IBOutlet UILabel *text_ch;
	IBOutlet UILabel *text_py;
	
	RecorderState recorderState;
}

-(IBAction)recordingBeginStart: (id)sender;
-(IBAction)playAudio: (id)sender;
-(IBAction)playBack: (id)sender;

-(void)initializeData;
-(void)finalizeData;

@property (retain, nonatomic) IBOutlet UILabel *text_en;
@property (retain, nonatomic) IBOutlet UILabel *text_ch;
@property (retain, nonatomic) IBOutlet UILabel *text_py;
@property (retain, nonatomic) Sentence *sentence;
@property RecorderState recorderState;

@end
