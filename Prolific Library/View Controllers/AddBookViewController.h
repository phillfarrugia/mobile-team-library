//
//  AddBookViewController.h
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UIViewController

@property (nonatomic) void (^bookAddedAction)(void);

@end
