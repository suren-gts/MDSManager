//
//  MusicePlayerClass.h
//  BellMeditation
//
//  Created by CEPL on 28/02/15.
//  Copyright (c) 2015 sb. All rights reserved.


#import <Foundation/Foundation.h>

@interface MusicePlayerClass : NSObject

- (instancetype)init;
- (void)stopSound;
- (void)tryPlayMusic;
- (void)playSystemSound;
- (void)configureAudioPlayer:(NSString *)strMusiceName;

@end
