//
//  AppService.m
//  SpeechTherapyGame
//
//  Created by Hai Le on 2/7/16.
//  Copyright © 2016 SUTD. All rights reserved.
//

#import "AppService.h"

@interface AppService()

@property (strong, nonatomic) AVAudioPlayer *bgmPlayer;

@end

@implementation AppService

static AppService *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[AppService alloc] init];
}

- (id)mutableCopy
{
    return [[AppService alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    
   
    
    return self;
}


@end
