//
//  AddBookViewController.m
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import "AddBookViewController.h"
#import "Prolific_Library-Swift.h"

@interface AddBookViewController ()

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UITextField *publisherTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoriesTextField;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Book";
    [self configureNavigation];
}

- (void)configureNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelBarButtonItemDidPress)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(confirmBarButtonItemDidPress)];
}

- (void)cancelBarButtonItemDidPress {
    if ([self validationState] == AddBookValidationStateIncomplete) {
        [self handleIncompleteState];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)confirmBarButtonItemDidPress {
    switch ([self validationState]) {
        case AddBookValidationStateRequiredFieldsIncomplete:
            [self handleRequiredFieldsIncompleteState];
            break;
        case AddBookValidationStateIncomplete:
        case AddBookValidationStateComplete:
            [self handleCompleteState];
            break;
    }
}

- (AddBookValidationState)validationState {
    return [AddBookValidator validateWithTitleText:self.titleTextField.text
                                        authorText:self.authorTextField.text
                                     publisherText:self.publisherTextField.text
                                    categoriesText:self.categoriesTextField.text];
}

- (void)handleRequiredFieldsIncompleteState {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Fields Required"
                                                                             message:@"Title and Author are required to add a new book"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleIncompleteState {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unsaved Changes"
                                                                             message:@"You will lose unsaved changes. Are you sure?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleCompleteState {
    // TODO: Send a Network Request to Add Book
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: Alert View

@end
