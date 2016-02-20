//
//  ParentSoundDetailsController.m
//  SpeechTherapyGame
//
//  Created by Hai Le on 2/20/16.
//  Copyright © 2016 SUTD. All rights reserved.
//

#import "ParentSoundDetailsController.h"
#import "DetailsCell.h"
#import "Score.h"
#import "DataManager.h"

@implementation ParentSoundDetailsController {
    NSArray* _groupNames;
    NSMutableDictionary* _groupedData;
}

- (void)reloadTableWithDateString:(NSString *)date {
    self.lbText.text = date;
    NSMutableArray* arr = [[DataManager shared] getScoresByDateString:date];
    
    // Group data
    _groupedData = [NSMutableDictionary dictionary];
    
    // Here `customObjects` is an `NSArray` of your custom objects from the XML
    for (Score * object in arr) {
        NSMutableArray * theMutableArray = [_groupedData objectForKey:object.phoneme];
        if ( theMutableArray == nil ) {
            theMutableArray = [NSMutableArray array];
            [_groupedData setObject:theMutableArray forKey:object.phoneme];
        }
        
        [theMutableArray addObject:object];
    }
    
    /* `sortedCountries` is an instance variable */
    _groupNames = [[_groupedData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    // reload table
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource

//static NSString* cellIdentifier = @"Cell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                     forIndexPath:indexPath];
    
    NSString * group = [_groupNames objectAtIndex:indexPath.section];
    NSArray * objects = [_groupedData objectForKey:group];
    Score * w = [objects objectAtIndex:indexPath.row];
    
    // Text
    cell.lbText.text = w.sound;
    
    // Subtext
    cell.lbDate.text = w.dateString;
    
    // Score
    cell.lbScore.text = [NSString stringWithFormat:@"%.2f",w.score];
    if (w.score >= [[DataManager shared] difficultyValue]) {
        cell.lbScore.textColor = [UIColor flatGreenColorDark];
    } else {
        cell.lbScore.textColor = [UIColor flatRedColorDark];
    }
    
    // Selected Background
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [[UIColor flatLimeColor] colorWithAlphaComponent:0.4];
    cell.selectedBackgroundView = myBackView;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groupNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_groupedData objectForKey:[_groupNames objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _groupNames[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // Color
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    [headerView setBackgroundColor:[[UIColor flatWatermelonColor] colorWithAlphaComponent:0.4f]];
    
    
    // Text
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, tableView.width-30, 50)];
    label.text = _groupNames[section];
    label.textColor = [UIColor flatRedColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:25];
    [headerView addSubview:label];
    
    [bgView addSubview:headerView];
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString * phonemeGroup = [_sortedWordGroup objectAtIndex:indexPath.section];
//    NSArray * sounds = [_groupedWordData objectForKey:phonemeGroup];
//    Word * w = [sounds objectAtIndex:indexPath.row];
//    self.lbSoundPreview.text = w.sound;
//    self.lbPhoneticPreview.text = [NSString stringWithFormat:@"/%@/",w.phonetic];
//    
//    self.imgPreview.image = [UIImage imageNamed:w.imgFilePath];
//    _selectedWord = w;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
