//
//  BookDetailViewController.m
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import "BookDetailViewController.h"
#import "AddBookViewController.h"
#import "ProlificLibraryCore.h"
#import "Prolific_Library-Swift.h"

@interface BookDetailViewController ()

@property (nonatomic, weak) BookCellViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UIView *coverImageHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *coverImageUnavailableLabel;
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
    [self configureNavigation];
    [self configureCoverImage];
}

- (void)configureNavigation {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more-dots-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBarButtonItemDidPress)];
}

- (void)configureCoverImage {
    if (self.viewModel.coverImage) {
        self.coverImageView.image = self.viewModel.coverImage;
    }
    else {
        NSString *queryString = [NSString stringWithFormat:@"%@ %@", self.viewModel.title, self.viewModel.authors];
        [ImageHandler cachedImageOrDownloadImageForQueryString:queryString completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                self.coverImageView.image = image;
            }
            else {
                self.coverImageView.hidden = true;
                self.coverImageUnavailableLabel.hidden = false;
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.titleLabel setText:self.viewModel.title];
    [self.authorLabel setText:self.viewModel.authors];
    [self.lastCheckedOutLabel setText:self.viewModel.lastCheckedOut];
    
    self.coverImageUnavailableLabel.hidden = true;
    
    if (self.viewModel.publisher) {
        [self.publisherLabel setText:self.viewModel.publisher];
    }
    else {
        self.publisherLabelTopConstraint.constant = 0;
        self.publisherLabelHeightConstraint.constant = 0;
    }
    
    self.checkoutButton.layer.cornerRadius = self.checkoutButton.frame.size.height/2;
    [self.tagViewContainer layoutTagViewsForTags:self.viewModel.categories withColor:self.viewModel.detailColor displayMultiLine:YES];
    self.bodyViewHeightConstraint.constant = self.view.bounds.size.height - self.coverImageView.bounds.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.navigationBar setBarTintColor:self.viewModel.primaryColor];
        self.coverImageHeaderView.backgroundColor = self.viewModel.secondaryColor;
        self.checkoutButton.backgroundColor = self.viewModel.primaryColor;
    }];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [self.navigationController.navigationBar setBarTintColor:nil];
}

- (void)moreBarButtonItemDidPress {
    ModalAlertMessage *alertMessage = [[ModalAlertMessage alloc] initWithTitle:nil body:nil topButtonTitle:@"Share" middleButtonTitle:@"Edit" bottomButtonTitle:@"Delete" primaryColor:self.viewModel.primaryColor secondaryColor:self.viewModel.secondaryColor detailColor:self.viewModel.detailColor];
    [self presentModalAlertViewWithMessage:alertMessage completion:^(enum ModalAlertResult completion) {
        switch (completion) {
            case ModalAlertResultTop:
                [self shareButtonDidPress];
                break;
            case ModalAlertResultMiddle:
                [self editButtonDidPress];
                break;
            case ModalAlertResultBottom:
                [self deleteButtonDidPress];
                break;
        }
    }];
}

- (void)editButtonDidPress {
    [self performSegueWithIdentifier:@"EditBook" sender:self];
}

- (void)deleteButtonDidPress {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                             message:@"Deleting a book cannot be undone."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteBookWithCompletion:^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareButtonDidPress {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.viewModel.shareableMessage] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditBook"]) {
        UINavigationController *destinationViewController = [segue destinationViewController];
        AddBookViewController *addBookViewController = destinationViewController.viewControllers.firstObject;
        [addBookViewController configureForEditingExistingBook:self.viewModel.book];
    }
}

- (void)configureForViewModel:(BookCellViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (IBAction)checkoutButtonDidPress:(id)sender {
    [self presentCheckoutAlert];
}

- (void)presentCheckoutAlert {
    ModalAlertMessage *alertMessage = [[ModalAlertMessage alloc] initWithTitle:@"More Options" body:@"Select an option" topButtonTitle:@"Cancel" middleButtonTitle:nil bottomButtonTitle:@"Confirm" primaryColor:self.viewModel.secondaryColor secondaryColor:self.viewModel.secondaryColor detailColor:self.viewModel.primaryColor];
    [self presentModalAlertViewWithMessage:alertMessage completion:^(enum ModalAlertResult result) {
        if (result == ModalAlertResultBottom) {
            // TODO: Send Network Request to Checkout Book
//            [NetworkRequestManager checkoutBookRequestWithBook:self.viewModel.book checkedOutBy:@"Phill Farrugia" completion:^(Book * _Nullable book, NSError * _Nullable error) {
//                NSLog(@"%@", book.lastCheckedOutBy);
//                if (error) {
//                    NSLog(@"%@", book);
//                }
//            }];
        }
    }];
}

- (void)deleteBookWithCompletion:(void (^)())completion {
    [NetworkRequestManager deleteBookRequestWithBook:self.viewModel.book completion:^(NSError * _Nullable error) {
        if (error) {
            [self handleDeleteBookError];
        }
        else {
            completion();
        }
    }];
}

- (void)handleDeleteBookError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                             message:@"We were unable to delete this book. Would you like to try again?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
