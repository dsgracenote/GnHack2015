//
//  ViewController.m
//  SportsMetadataParser
//
//  Created by Dan Spirlock on 7/30/15.
//  Copyright (c) 2015 Gracenote. All rights reserved.
//

#import "ViewController.h"
#import "LiveScoreUpdater.h"
#import "ImageURLRetriever.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Lookup team logo by team id
    NSURL *teamURL = [[[ImageURLRetriever alloc] init] getTeamImageWithTeamId:@"2962"];
    NSLog(@"%@", [teamURL path]);
    
    LiveScoreUpdater *updater = [[LiveScoreUpdater alloc] initWithXMLFile:[[NSBundle mainBundle] pathForResource:@"live-score_383227" ofType:@"xml"]];
    
    while (updater.completed == NO) {
        LiveScoreUpdate *update = [updater getNextUpdate];
        CurrentGameTotals *totals = updater.totals;
        
        NSLog(@"Home:%@ R:%d H:%d E:%d", totals.homeTeamNameShort, totals.homeTeamRunsTotal, totals.homeTeamHitsTotal, totals.homeTeamErrorsTotal);
        NSLog(@"Away:%@ R:%d H:%d E:%d", totals.awayTeamNameShort, totals.awayTeamRunsTotal, totals.awayTeamHitsTotal, totals.awayTeamErrorsTotal);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
