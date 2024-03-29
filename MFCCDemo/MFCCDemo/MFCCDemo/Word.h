//
//  Word.h
//  MFCCDemo
//
//  Created by Hai Le on 12/21/15.
//  Copyright © 2015 Hai Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Word : BaseModel

@property(readonly, nonatomic) NSString* phoneme;
@property(readonly, nonatomic) NSString* sound;
@property(readonly, nonatomic) NSString* phonetic;
@property(readonly, nonatomic) SInt64 position;

@property(readonly, nonatomic) NSString* fullPath;
@property(readonly, nonatomic) NSString* filterPath;
@property(readonly, nonatomic) SInt64 fullLen;
@property(readonly, nonatomic) NSString* croppedPath;
@property(readonly, nonatomic) SInt64 croppedLen;

@property(readonly, nonatomic) SInt64 start;
@property(readonly, nonatomic) SInt64 end;
@property(readonly, nonatomic) SInt64 targetStart;
@property(readonly, nonatomic) SInt64 targetEnd;
@property(readonly, nonatomic) int type;

@property(readonly, nonatomic) NSString* imgPath;
@property(readonly, nonatomic) NSString* samplePath;
@property(readonly, nonatomic) NSString* speaker;

- (NSString *)filteredFilePath;
- (NSString *)filePath;

@end
