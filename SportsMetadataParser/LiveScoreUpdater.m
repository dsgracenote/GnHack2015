//
//  LiveScoreUpdater.m
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import "LiveScoreUpdater.h"
#import "TFHpple.h"

@implementation LiveScoreUpdate


@end


@implementation CurrentGameTotals


@end


@implementation LiveScoreUpdater

- (instancetype)initWithXMLFile:(NSString*)xmlFilePath
{
    self = [super init];
    if (self) {
        self.currentInning = 1;
        self.currentInningHalf = 1;
        self.currentTeam = 1;
        self.completed = NO;
        
        NSData *xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
        self.doc = [[TFHpple alloc] initWithXMLData:xmlData];
        
        NSAssert(self.doc, @"Could not create XML document from file");
        
        [self initCurrentGameTotals];
    }
    
    return self;
}


- (void)initCurrentGameTotals
{
    self.totals = [CurrentGameTotals new];
    
    // Home Team
    NSArray *teamArray = [self.doc searchWithXPathQuery:@"//home-team-content/team"];
    if (teamArray.count > 0) {
        TFHppleElement *e = [teamArray objectAtIndex:0];
        NSArray *array = [e childrenWithTagName:@"id"];
        if (array.count > 0) {
            self.totals.homeTeamId = [[[[[array objectAtIndex:0] text] pathComponents] lastObject] stringByReplacingOccurrencesOfString:@"team:" withString:@""];
            
        }
        
        array = [e childrenWithTagName:@"name"];
        if (array.count > 1) {
            self.totals.homeTeamName = [[array objectAtIndex:0] text];
            self.totals.homeTeamNameShort = [[array objectAtIndex:1] text];
        }
    }
    
    // Away Team
    teamArray = [self.doc searchWithXPathQuery:@"//away-team-content/team"];
    if (teamArray.count > 0) {
        TFHppleElement *e = [teamArray objectAtIndex:0];
        NSArray *array = [e childrenWithTagName:@"id"];
        if (array.count > 0) {
            self.totals.awayTeamId = [[[[[array objectAtIndex:0] text] pathComponents] lastObject] stringByReplacingOccurrencesOfString:@"team:" withString:@""];
            
        }
        
        array = [e childrenWithTagName:@"name"];
        if (array.count > 1) {
            self.totals.awayTeamName = [[array objectAtIndex:0] text];
            self.totals.awayTeamNameShort = [[array objectAtIndex:1] text];
        }
    }
}




- (LiveScoreUpdate*)getNextUpdate
{
    if (self.completed) {
        NSLog(@"game complete...");
        return nil;
    }
    
    
    LiveScoreUpdate *update = [LiveScoreUpdate new];
    update.inningNum = self.currentInning;
    update.inningHalf = self.currentInningHalf;
    
    
    NSString *teamElemName = self.currentTeam == 1 ? @"//home-team-content" : @"//away-team-content";
    NSArray *teamArray = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/team", teamElemName]];
    if (teamArray.count > 0) {
        TFHppleElement *e = [teamArray objectAtIndex:0];
        NSArray *array = [e childrenWithTagName:@"id"];
        if (array.count > 0) {
            update.teamId = [[[[[array objectAtIndex:0] text] pathComponents] lastObject] stringByReplacingOccurrencesOfString:@"team:" withString:@""];

        }
        
        array = [e childrenWithTagName:@"name"];
        if (array.count > 1) {
            update.teamName = [[array objectAtIndex:0] text];
            update.teamNameShort = [[array objectAtIndex:1] text];
        }
    }
    
    // Find stats for team, inning, inning half

    NSString *inningHalfStr = self.currentInningHalf == 1 ? @"top" : @"bottom";
    
    
    // Errors
    NSArray *stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='errors']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.errors = [[stats objectAtIndex:0] text];
        
        if (self.currentTeam == 1) {
            self.totals.homeTeamErrorsTotal += [update.errors intValue];
        } else {
            self.totals.awayTeamErrorsTotal += [update.errors intValue];
        }
    }
    
    // Hits
    stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='hits']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.hits = [[stats objectAtIndex:0] text];
        
        if (self.currentTeam == 1) {
            self.totals.homeTeamHitsTotal += [update.hits intValue];
        } else {
            self.totals.awayTeamHitsTotal += [update.hits intValue];
        }
    }
    
    // Runs
    stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='runs']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.runs = [[stats objectAtIndex:0] text];
        
        
        if (self.currentTeam == 1) {
            self.totals.homeTeamRunsTotal += [update.runs intValue];
        } else {
            self.totals.awayTeamRunsTotal += [update.runs intValue];
        }
    }
    
    
    //NSLog(@"team id: %@ name: %@ short: %@ h: %@ r: %@ e: %@ i: %d ih: %d", update.teamId, update.teamName, update.teamNameShort, update.hits, update.runs, update.errors, update.inningNum, update.inningHalf);

    ++self.currentTeam;
    if (self.currentTeam > 2) {
        self.currentTeam = 1;
        
        ++self.currentInningHalf;
        if (self.currentInningHalf > 2) {
            self.currentInningHalf = 1;
            ++self.currentInning;
            
            if (self.currentInning > 9) {
                self.completed = YES;
            }
        }
    }
    
    return update;
}


@end
