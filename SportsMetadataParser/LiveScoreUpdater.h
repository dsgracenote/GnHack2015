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
@property BOOL     isHomeTeam;
@property int      inningNum;
@property int      inningHalf;
@property NSString *runs;
@property NSString *hits;
@property NSString *errors;

@end



@interface CurrentGameTotals : NSObject

@property NSString *homeTeamId;
@property NSString *homeTeamName;
@property NSString *homeTeamNameShort;
@property int       homeTeamRunsTotal;
@property int       homeTeamHitsTotal;
@property int       homeTeamErrorsTotal;

@property NSString *awayTeamId;
@property NSString *awayTeamName;
@property NSString *awayTeamNameShort;
@property int       awayTeamRunsTotal;
@property int       awayTeamHitsTotal;
@property int       awayTeamErrorsTotal;

@end




@interface LiveScoreUpdater : NSObject

- (instancetype)initWithXMLFile:(NSString*)xmlFilePath;
- (LiveScoreUpdate*)getNextUpdate;

@property BOOL completed;
@property CurrentGameTotals *totals;






/****** Private -- Don't use -- ************/
@property int currentInning;
@property int currentInningHalf;
@property (strong) TFHpple* doc;
@property int currentTeam;

@end
