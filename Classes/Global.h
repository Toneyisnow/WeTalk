//
//  Global.h
//  WeTalk
//
//  Created by sui toney on 10-12-31.
//  Copyright 2010 ms. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Global : NSObject {

	NSString *currentUsername;
	float passMark;
}

+(Global *) getInstance;


@property (nonatomic, retain) NSString *currentUsername;
@property float passMark;

@end
