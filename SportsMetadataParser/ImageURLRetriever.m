//
//  ImageRetriever.m
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import "ImageURLRetriever.h"

@implementation ImageURLRetriever

-(NSURL*)getTeamImageWithTeamId:(NSString*)teamId
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"team_%@", teamId] withExtension:@"png"];
    return url;
}


-(NSURL*)getPlayerImage:(NSString*)playerId
{
    return nil;
}

@end
