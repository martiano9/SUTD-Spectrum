//
//  WordCell.h
//  SpeechTherapyGame
//
//  Created by Hai Le on 1/4/16.
//  Copyright © 2016 SUTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* lbText;
@property (weak, nonatomic) IBOutlet UILabel* lbSubtext;
@property (weak, nonatomic) IBOutlet UIButton* btnPlay;
@property (weak, nonatomic) IBOutlet UIButton* btnActive;

@end