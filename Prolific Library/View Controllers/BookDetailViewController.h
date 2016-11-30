//
//  BookDetailViewController.h
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookCellViewModel;
@interface BookDetailViewController : UIViewController

@property (nonatomic) void (^bookUpdateDeleteAction)(void);

@property (nonatomic) BookCellViewModel *viewModel;

@end
