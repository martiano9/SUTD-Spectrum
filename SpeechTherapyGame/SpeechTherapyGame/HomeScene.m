//
//  GameScene.m
//  SpeechTherapyGame
//
//  Created by Vit on 8/31/15.
//  Copyright (c) 2015 SUTD. All rights reserved.
//

@import AVFoundation;
#import "HomeScene.h"
#import "HomeSceneViewController.h"
#import "FishingGameScene.h"

@interface HomeScene ()
{
    BOOL _isSoundOn;
    BOOL _isBgmOn;
    SKSpriteNode *_btnSound;
    SKSpriteNode *_btnBgm;
}

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@end

#define starButtonName  @"StarButton"

@implementation HomeScene

-(void)didMoveToView:(SKView *)view {
    
    // Buttons
//    _btnSound = (SKSpriteNode*)[self childNodeWithName:@"btnSound"];
//    [self _soundOn:[NSStandardUserDefaults boolForKey:kKeySound]];
//    
//    _btnBgm = (SKSpriteNode*)[self childNodeWithName:@"btnBgm"];
//    [self _bgmOn:[NSStandardUserDefaults boolForKey:kKeyBgm]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchNode = [self nodeAtPoint:location];
    
    SKAction *push = [NodeUtility buttonPushActionWithSound];
    
//    if ([touchNode.name isEqualToString:@"btnSound"]) {
//        [touchNode runAction:push completion:^{
//            [self _soundOn:!_isSoundOn];
//        }];
//    }
//    else if ([touchNode.name isEqualToString:@"btnBgm"]) {
//        [touchNode runAction:push completion:^{
//            [self _bgmOn:!_isBgmOn];
//        }];
    if ([touchNode.name isEqualToString:@"btnParentsMode"]) {
        [touchNode runAction:push completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowParentsMode
                                                                object:self
                                                              userInfo:nil];
        }];
    } else if ([touchNode.name isEqualToString:@"btnStar"]) {
        [touchNode runAction:push completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSchedule
                                                                object:self
                                                              userInfo:nil];
        }];
    }
    else {
        SKScene *scene = [FishingGameScene unarchiveFromFile:@"FishingGameScene"];
        //scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }
}

#pragma mark - Private
- (void)_soundOn:(BOOL)boo {
    _isSoundOn = boo;
    [NSStandardUserDefaults setBool:boo forKey:kKeySound];
    
    if (boo) {
        _btnSound.texture = [SKTexture textureWithImageNamed:@"btnSoundOn"];
    } else {
        
        _btnSound.texture = [SKTexture textureWithImageNamed:@"btnSoundOff"];
    }
}

- (void)_bgmOn:(BOOL)boo {
    _isBgmOn = boo;
    [NSStandardUserDefaults setBool:boo forKey:kKeyBgm];
    
    if (boo) {
        [_musicPlayer play];
        _btnBgm.texture = [SKTexture textureWithImageNamed:@"btnBgmOn"];
    } else {
        [_musicPlayer stop];
        _btnBgm.texture = [SKTexture textureWithImageNamed:@"btnBgmOff"];
    }
}

@end
