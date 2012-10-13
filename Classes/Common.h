//
//  Common.h
//  WeTalk
//
//  Created by sui toney on 10-12-20.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject {
/*
	NSString *tempDirectory;	
	NSString *documentDirectory;
	NSString *tempWavFileFullPath;
*/

}

/*
@property (retain, nonatomic) NSString *tempDirectory;
@property (retain, nonatomic) NSString *documentDirectory;
@property (retain, nonatomic) NSString *tempWavFileFullPath;
*/

+(NSString *) GetTempDir;
+(NSString *) GetDocumentDir;
+(const char *)TempFile:(NSString *)filename;

+(void)CopyFile:(NSString *)srcFile toPath:(NSString *)destPath;
+(void)TryRemoveFile:(NSString *)fileName;
+(const char *) GetFileFullPathForCpp:(NSString *)fileName ofType:(NSString *)extName;
+(void) HViteInit;
+ (NSString *) ToNSString:(const char*)str;
+ (const char*) ToCString:(NSString *)str;

@end
