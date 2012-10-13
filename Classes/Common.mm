//
//  Common.m
//  WeTalk
//
//  Created by sui toney on 10-12-20.
//  Copyright 2010 ms. All rights reserved.
//

#import "Common.h"
#import "AudioCopy/mainroot.h"


@implementation Common


+(NSString *) GetTempDir {

	return @"/ProgramData/temp/";
	//return NSTemporaryDirectory();
}

+(NSString *) GetDocumentDir {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString *) GetTempWaveFileFullPath {
	return [NSString stringWithFormat:@"%@/original.wav", [self GetTempDir]];
	
}

+(void)CopyFile:(NSString *)srcFile toPath:(NSString *)destPath {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	//NSURL *srcURL = [NSURL fileURLWithPath:srcFile];
	//NSURL *destinationURL = [NSURL fileURLWithPath:destFile];
	
	if([fileManager fileExistsAtPath:destPath]) {
	
		[fileManager removeItemAtPath:destPath error:&error];
	}
	
	if (![fileManager copyItemAtPath:srcFile toPath:destPath error:&error]) {
		// Handle the error.
	}
	
}

+(void)TryRemoveFile:(NSString *)fileName {

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	
	if([fileManager fileExistsAtPath:fileName]) {
		
		[fileManager removeItemAtPath:fileName error:&error];
	}
	
}

+(const char *) GetFileFullPathForCpp:(NSString *)fileName ofType:(NSString *)extName {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extName];
    return [path cStringUsingEncoding:NSASCIIStringEncoding];
}

+(const char *)TempFile:(NSString *)filename {
	
	return [[NSString stringWithFormat:@"%@/%@", [Common GetTempDir], filename] cStringUsingEncoding:1];
	
}

+ (NSString *) ToNSString:(const char*)str {
	
	return [NSString stringWithFormat:@"%s", str];
}

+ (const char*) ToCString:(NSString *)str {
	
	return [str cStringUsingEncoding:NSASCIIStringEncoding];
}

+(void) HViteInit {
	
	const char* dictstr = [Common GetFileFullPathForCpp:@"dict" ofType:@"newrank"];
	const char* tiedliststr = [Common GetFileFullPathForCpp:@"tiedlist" ofType:@"rank"];
	const char* hmmdefsstr = [Common GetFileFullPathForCpp:@"hmmdefs" ofType:@"rank"];
	
	Initiate(dictstr, tiedliststr, hmmdefsstr);
	
}

@end
