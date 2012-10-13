//
//  VoiceAnalyzer.m
//  OralTeacher
//
//  Created by sui toney on 10-10-13.
//  Copyright 2010 ms. All rights reserved.
//

#import "VoiceAnalyzer.h"
#import "Common.h"
#import <string>
//#import "../AudioCopy/HCopy/delSil.h"
//#import "../AudioCopy/HCopy/genresult.h"
#import "AudioCopy/hparm2.h"
#import "AudioCopy/genWdnet.h"
#import "AudioCopy/genScore.h"
#import "AudioCopy/mainroot.h"
#import "AudioCopy/delSil.h"

@implementation VoiceAnalyzer

-(void) analyze: (NSString *)sourceString {

	pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
	
	[self teardown];
	[self HCopy];
	[self HVite2: sourceString];
	
	// [pool drain];
}

-(void) DelSilence {
	
	NSLog(@"Delete Silence.");
	const char *delsiled = [Common TempFile:@"delsiled.wav"];
	const char *original = [Common TempFile:@"original.wav"];
	
	delSil(original, delsiled);
	//[Common CopyFile:[Common ToNSString: original] toPath: [Common ToNSString: delsiled]];
	
	NSLog(@"Delete Silence Finished.");
}

-(void) HCopy {
	
	const char *delsiled = [Common TempFile:@"original.wav"];
	const char* audio = [Common TempFile:@"audio.mfc"];
	
	try {
		[self DelSilence];
		
		NSLog(@"Start HCopy.");
		bool result = hcopy2(delsiled, audio);
		NSLog(@"HCopy Result: %b", result);
	}
	catch (NSException e) {
		NSLog(@"HCopy threw exception:%@", e);
	}
	
	//delete delsiled;
	delsiled = nil;
	//delete audio;
	audio = nil;
	 
}

-(void) HVite2: (NSString *)sourceString {
	
	vector<string> answerPY;
	while(sourceString.length > 0)
	{
		NSRange index = [sourceString rangeOfString:@" "
											options:(NSCaseInsensitiveSearch)];
		if(index.length <= 0)
		{
			break;
		}
		
		const char* word = [Common ToCString:[sourceString substringToIndex:index.location]];
		answerPY.push_back(word);
		
		sourceString = [sourceString substringFromIndex:index.location+1];
	}
	answerPY.push_back([Common ToCString:sourceString]);
	
	const char* audio = [Common TempFile:@"audio.mfc"];
	
	char* audiocopy = new char[255];
	strcpy(audiocopy, audio);
	
	float result = 0;
	try {
		result = Viterbi(audiocopy, answerPY);
		NSLog(@"Result:%f", result);
	}
	catch (NSException *e) {
		NSLog(@"HVite2 threw exception:%@", e);
	}
		
		
	//[self GenerateScore];
		
		// Write the result into temp file
		NSFileHandle *file;
        NSData *data;
		NSFileManager *filemgr;
		
		filemgr = [NSFileManager defaultManager];
        const char *bytestring = [Common ToCString:[NSString stringWithFormat:@"%f", result]];
		
		NSString *resultintFile = [Common ToNSString:[Common TempFile:@"result.int"]];
        data = [NSData dataWithBytes:bytestring length:strlen(bytestring)];
		data = [NSData dataWithBytes:&result length:4];
		//[data writeToFile:resultintFile automatically:true];
		[filemgr createFileAtPath: resultintFile contents: data attributes: nil];
		
		file = [NSFileHandle fileHandleForWritingAtPath:resultintFile];
		if (file == nil)
			NSLog(@"Failed to open file");
		
        [file writeData: data];
        [file closeFile];
		[file release];
		
		//[bytestring release];
		//[data release];
}

-(float) ReadScore {

	NSFileManager *filemgr;
	NSData *databuffer;
	
	filemgr = [NSFileManager defaultManager];
	NSString *resultintFile = [Common ToNSString:[Common TempFile:@"result.int"]];
	
	float finalresult = 0;
	@try
	{
		float result = 0;
		databuffer = [filemgr contentsAtPath: resultintFile];
		[databuffer getBytes:&result];
		
		NSLog(@"Result: %f", result);
		
		// Convert Score   convert: 65-90 to 100-0
		finalresult = 100-(result - 65)*100/30;
		
		if(finalresult > 99.9)
			finalresult = 99.9;
		if(finalresult < 0.001)
			finalresult = 0.001;
	}
	@catch (NSException *e) {
		
	}
	
	return finalresult;
}	

-(int) GenerateScore {
	
    const char* audiomlf = [Common TempFile:@"result.mlf"];
	
	int myscore = score(audiomlf);
	NSLog(@"Score Result: %d", myscore);
	return myscore;
}

-(void) teardown {
	
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"result.int"]]];
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"audio.mfc"]]];
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"delsiled.wav"]]];
	//[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"original.wav"]]];
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"pyfile"]]];
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"result.mlf"]]];
	[Common TryRemoveFile:[Common ToNSString:[Common TempFile: @"wdnetfile"]]];

}




@end
