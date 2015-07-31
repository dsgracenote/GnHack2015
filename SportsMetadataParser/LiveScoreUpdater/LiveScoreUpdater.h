//
//  LiveScoreUpdater.h
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFHpple;

@interface LiveScoreUpdate : NSObject

@property NSString *teamId;
@property NSString *teamName;
@property NSString *teamNameShort;
@property int      inningNum;
@property int      inningHalf;
@property NSString *runs;
@property NSString *hits;
@property NSString *errors;


@end


@interface LiveScoreUpdater : NSObject

- (instancetype)initWithXMLFile:(NSString*)xmlFilePath;
- (LiveScoreUpdate*)getNextUpdate;

@property BOOL completed;

/****** Private -- Don't use -- ************/
@property int currentInning;
@property int currentInningHalf;
@property (strong) TFHpple* doc;
@property int currentTeam;

@end
