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

- (void)configureForViewModel:(BookCellViewModel *)book;

@end
