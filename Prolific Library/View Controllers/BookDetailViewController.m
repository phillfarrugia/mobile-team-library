//
//  BookDetailViewController.m
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import "BookDetailViewController.h"
#import "ProlificLibraryCore.h"
#import "Prolific_Library-Swift.h"

@interface BookDetailViewController ()

@property (nonatomic, weak) BookCellViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UIView *coverImageHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bodyViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) IBOutlet UILabel *publisherLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *publisherLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *publisherLabelHeightConstraint;

@property (strong, nonatomic) IBOutlet TagBubbleViewContainer *tagViewContainer;

@property (strong, nonatomic) IBOutlet UILabel *lastCheckedOutLabel;

@property (strong, nonatomic) IBOutlet UIButton *checkoutButton;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.titleLabel setText:self.viewModel.title];
    [self.authorLabel setText:self.viewModel.authors];
    [self.lastCheckedOutLabel setText:self.viewModel.lastCheckedOut];
    
    if (self.viewModel.publisher) {
        [self.publisherLabel setText:self.viewModel.publisher];
    }
    else {
        self.publisherLabelTopConstraint.constant = 0;
        self.publisherLabelHeightConstraint.constant = 0;
    }
    
    self.checkoutButton.layer.cornerRadius = self.checkoutButton.frame.size.height/2;
    
    [self.tagViewContainer layoutTagViewsForTags:self.viewModel.categories];
    
    self.bodyViewHeightConstraint.constant = self.view.bounds.size.height - self.coverImageView.bounds.size.height;
}

- (void)configureForViewModel:(BookCellViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [BookCellViewModel downloadAndCacheCoverImageForViewModel:viewModel completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (image) {
            self.coverImageView.image = image;
        }
    }];
}

- (IBAction)checkoutButtonDidPress:(id)sender {
    // TODO: Send Network Request to Checkout Book
    [NetworkRequestManager checkoutBookRequestWithBook:self.viewModel.book checkedOutBy:@"Phill Farrugia" completion:^(Book * _Nullable book, NSError * _Nullable error) {
        NSLog(@"%@", book.lastCheckedOutBy);
        if (error) {
            NSLog(@"%@", book);
        }
    }];
}

- (IBAction)shareButtonDidPress:(id)sender {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.viewModel.shareableMessage] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end
