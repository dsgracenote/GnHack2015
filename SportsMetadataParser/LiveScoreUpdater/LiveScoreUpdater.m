//
//  LiveScoreUpdater.m
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import "LiveScoreUpdater.h"
#import "TFHpple.h"

@interface LiveScoreUpdate (PrivateAPI)

-(instancetype)init;
@end


@implementation LiveScoreUpdate

-(instancetype)init
{
    self = [super init];
//    if (self) {
//        self.runs = @"";
//        self.hits = @"";
//        self.errors = @"";
//    }
    
    return self;
}

@end



@implementation LiveScoreUpdater

@synthesize currentInning;
@synthesize currentInningHalf;
@synthesize doc;
@synthesize currentTeam;
@synthesize completed;


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
    }
    
    return self;
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
    
    NSArray *stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='errors']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.errors = [[stats objectAtIndex:0] text];
    }
    
    // Hits
    stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='hits']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.hits = [[stats objectAtIndex:0] text];
    }
    
    // Runs
    stats = [self.doc searchWithXPathQuery:[NSString stringWithFormat:@"%@/stat-group/scope[@num='%d' and @sub-type='%@']/parent::*/stat[@type='runs']/@num", teamElemName, self.currentInning, inningHalfStr]];
    if (stats && stats.count > 0) {
        update.runs = [[stats objectAtIndex:0] text];
    }
    
    
    NSLog(@"team id: %@ name: %@ short: %@ h: %@ r: %@ e: %@ i: %d ih: %d", update.teamId, update.teamName, update.teamNameShort, update.hits, update.runs, update.errors, update.inningNum, update.inningHalf);

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
