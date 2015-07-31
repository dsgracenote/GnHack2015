//
//  ImageRetriever.h
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageURLRetriever : NSObject

-(NSURL*)getTeamImageWithTeamId:(NSString*)teamId;
-(NSURL*)getPlayerImage:(NSString*)playerId;

@end
