//
//  GameStatsViewController.m
//  SpeechTherapyGame
//
//  Created by Vit on 9/23/15.
//  Copyright © 2015 SUTD. All rights reserved.
//

#import "GameStatsViewController.h"
#import "ActionSheetPicker.h"
#import "Games.h"
#import "Sounds.h"
#import "GameStatistics.h"
#import "PNChart.h"


@interface GameStatsViewController ()
{
    
    NSArray* _gameStatData;
    NSMutableArray* _lineBottomLabels;
    NSMutableArray* _barBottomLabels;
    
    PNLineChart * _lineChart;
    PNBarChart  * _barChart;
    
    IBOutlet UIButton* _playedTimeButton;
    IBOutlet UIButton* _pointButton;
    
    IBOutlet UILabel* _chartNoDataLabel;
    IBOutlet UILabel* _barNoDataLabel;
}

@end

@implementation GameStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(47,139,193);
    
    _gameStatData = [GameStatistics MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"dateAdded == %@", [[NSDate date] beginningOfDay]]];
    
    if (_gameStatData.count > 0) {
        // Get played time first
        [self enableButton:_playedTimeButton];
        [self disableButton:_pointButton];
        // First line data
        [self loadDataForPlayedTimeLineChart:_gameStatData];
        // Bar data
        [self loadDataForWordsBarChart:_gameStatData];
        // setup chart
        [self drawLineChart];
        [self drawBarChart];
        _chartNoDataLabel.hidden = YES;
        _barNoDataLabel.hidden = YES;
    } else{
        _chartNoDataLabel.hidden = NO;
        _barNoDataLabel.hidden = NO;
    }
    
    _lineGraphContainer.layer.cornerRadius = 10;
    _barGraphContainer.layer.cornerRadius = 10;
}

- (void)drawLineChart {
    if (_lineBottomLabels.count > 0) {
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNLightBlue;
        data01.itemCount = _lineBottomLabels.count;
        data01.inflexionPointStyle = PNLineChartPointStyleCircle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [_lineGraphData[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        if (!_lineChart) {
            _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 100 - 30, _lineGraphContainer.width, _lineGraphContainer.height - 100)];
            _lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica" size:15];
            [_lineChart setXLabels:_lineBottomLabels];
            _lineChart.chartData = @[data01];
            [_lineChart strokeChart];
            [_lineGraphContainer addSubview:_lineChart];
        } else {
            [_lineChart setXLabels:_lineBottomLabels];
            [_lineChart updateChartData:@[data01]];
        }
    }
}

- (void)drawBarChart {
    if (_barBottomLabels.count > 0) {
        if (!_barChart) {
            _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 90 - 30, _barGraphContainer.width - 100, _barGraphContainer.height - 90)];
            _barChart.yChartLabelWidth = 20;
            _barChart.barBackgroundColor = PNWhite;
            _barChart.labelTextColor = PNBlack;
            _barChart.isShowNumbers = NO;
            _barChart.xLabels = _barBottomLabels;
            _barChart.yValues = _barGraphData;
            
            [_barChart strokeChart];
            [_barGraphContainer addSubview:_barChart];
        } else {
            _barChart.xLabels = _barBottomLabels;
            [_barChart updateChartData:_barGraphData];
        }
    }
}

- (void) loadDataForPlayedTimeLineChart:(NSArray*)gameStatData {
    
    if (gameStatData.count == 0) {
        return;
    }
    
    _lineBottomLabels = nil;
    _lineGraphData = nil;
    
    _lineBottomLabels = [NSMutableArray array];
    _lineGraphData = [NSMutableArray array];
    
    for (GameStatistics* gs in gameStatData) {
        [_lineGraphData addObject:gs.totalPlayedCount];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE"];
        NSString *dateString = [dateFormatter stringFromDate:gs.dateAdded];
        
        [_lineBottomLabels addObject:dateString];
    }
}

- (void) loadDataForPointsLineChart:(NSArray*)gameStatData {
    
    if (gameStatData.count == 0) {
        return;
    }
    
    _lineBottomLabels = nil;
    _lineGraphData = nil;
    
    _lineBottomLabels = [NSMutableArray array];
    _lineGraphData = [NSMutableArray array];
    
    for (GameStatistics* gs in gameStatData) {
        [_lineGraphData addObject:gs.correctCount];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE"];
        NSString *dateString = [dateFormatter stringFromDate:gs.dateAdded];
        
        [_lineBottomLabels addObject:dateString];
    }
}

- (void) loadDataForWordsBarChart:(NSArray*) gameStatData {
    
    if (gameStatData.count == 0) {
        return;
    }
    
    _barBottomLabels = nil;
    _barGraphData = nil;
    _barBottomLabels = [NSMutableArray array];
    _barGraphData = [NSMutableArray array];
    
    for (GameStatistics* gs in gameStatData) {
        
        if (![_barBottomLabels containsObject:gs.letter]) {
            [_barBottomLabels addObject:gs.letter];
        }
    }
    
    for (NSString* letter in _barBottomLabels) {
        for (GameStatistics* gs in gameStatData) {
            if ([gs.letter isEqualToString:letter]) {
                [_barGraphData addObject:@((gs.correctCount.integerValue / (float)gs.totalPlayedCount.integerValue) * 100)];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(IBAction) playedTimeButton_action {
    [self enableButton:_playedTimeButton];
    [self disableButton:_pointButton];
    // Reload data
    [self loadDataForPlayedTimeLineChart:_gameStatData];
    // Update line chart
    [self drawLineChart];
}

-(IBAction) pointButton_action {
    [self enableButton:_pointButton];
    [self disableButton:_playedTimeButton];
    // Reload data
    [self loadDataForPointsLineChart:_gameStatData];
    // Update line chart
    [self drawLineChart];

}

- (void) enableButton:(UIButton*) button {
    button.backgroundColor = RGB(47,139,193);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.selected = YES;
}

- (void) disableButton:(UIButton*) button {
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:RGB(47,139,193) forState:UIControlStateNormal];
    button.selected = NO;
}


#pragma mark - Action methods
- (IBAction) timeRange_pressed:(id)sender {
    __block NSArray *rangeData = [NSArray arrayWithObjects:@"Today",@"Yesterday",@"Last 7 days", @"Last 2 weeks",@"Last 30 days", @"Last month", @"All time", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Date ranges"
                                            rows:rangeData
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [(UIButton*)sender setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           [self fetchDataByDateRange:selectedIndex];
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:sender];
}

- (void) fetchDataByDateRange:(NSInteger) index {
    NSPredicate *predicate = nil;
    switch (index) {
        case 0: // Today
            predicate = [NSPredicate predicateWithFormat:@"dateAdded == %@", [[NSDate date] beginningOfDay]];
            break;
        case 1: // Yesterday
            predicate = [NSPredicate predicateWithFormat:@"dateAdded == %@", [self getDateByDaysInterval:-1 andCurrentDate:[[NSDate date] beginningOfDay]]];
            break;
        case 2: // Last 7 days
            predicate = [NSPredicate predicateWithFormat:@"(dateAdded >= %@) AND (dateAdded <= %@)", [self getDateByDaysInterval:-7 andCurrentDate:[[NSDate date] beginningOfDay]], [self getDateByDaysInterval:-1 andCurrentDate:[[NSDate date] beginningOfDay]]];
            break;
        case 3: // Last 2 weeks
            predicate = [NSPredicate predicateWithFormat:@"(dateAdded >= %@) AND (dateAdded <= %@)", [self getDateByDaysInterval:-14 andCurrentDate:[[NSDate date] beginningOfDay]], [self getDateByDaysInterval:-1 andCurrentDate:[[NSDate date] beginningOfDay]]];
            break;
        case 4: // Last 30 days
            predicate = [NSPredicate predicateWithFormat:@"(dateAdded >= %@) AND (dateAdded <= %@)", [self getDateByDaysInterval:-30 andCurrentDate:[[NSDate date] beginningOfDay]], [self getDateByDaysInterval:-1 andCurrentDate:[[NSDate date] beginningOfDay]]];
            break;
        case 5: // Last month
            predicate = [NSPredicate predicateWithFormat:@"(dateAdded >= %@) AND (dateAdded <= %@)", [self getFirstDayOfPreviousMonth], [self getLastDayOfPreviousMonth]];
            break;
        case 6: // All time
            break;
        default:
            break;
    }
    
    if (predicate) {
        _gameStatData = [GameStatistics MR_findAllWithPredicate:predicate];
    } else {
        _gameStatData = [GameStatistics MR_findAll];
    }
    
    // Reload data
    if (_playedTimeButton.selected)
        [self loadDataForPlayedTimeLineChart:_gameStatData];
    else
        [self loadDataForPointsLineChart:_gameStatData];
    [self loadDataForWordsBarChart:_gameStatData];
    
    // setup chart
    [self drawLineChart];
    [self drawBarChart];
}

- (NSDate*) getFirstDayOfPreviousMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [components setDay:1];
    [components setMonth:components.month-1];
    
    NSDate *targetedDate = [cal dateFromComponents:components];
    
    return targetedDate;
}

- (NSDate*) getLastDayOfPreviousMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [components setDay:0];
    
    NSDate *targetedDate = [cal dateFromComponents:components];
    
    return targetedDate;
}

- (NSDate*) getDateByDaysInterval:(int) days andCurrentDate:(NSDate*) aDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:aDate];
    
    [components setDay:days];
    NSDate *targetedDate = [cal dateByAddingComponents:components toDate: aDate options:0];
    
    return targetedDate;
}

@end
