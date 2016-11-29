//
//  AddBookViewController.m
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import "AddBookViewController.h"
#import "ProlificLibraryCore.h"

@interface AddBookViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UITextField *publisherTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoriesTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomVerticalConstraint;

@property (nonatomic) BOOL isEditingBookMode;
@property (nonatomic) Book *existingBookModel;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditingBookMode) {
        self.title = @"Edit Book";
    }
    else {
        self.title = @"Add Book";
    }
    
    [self configureNavigation];
    [self configureTextFields];
}

- (void)configureNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelBarButtonItemDidPress)];
    
    NSString *confirmButtonTitle = @"Add";
    if (self.isEditingBookMode) {
        confirmButtonTitle = @"Update";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:confirmButtonTitle
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(confirmBarButtonItemDidPress)];
}

- (void)configureTextFields {
    self.titleTextField.delegate = self;
    self.authorTextField.delegate = self;
    self.publisherTextField.delegate = self;
    self.categoriesTextField.delegate = self;
    
    if (self.isEditingBookMode) {
        self.titleTextField.text = self.existingBookModel.title;
        self.authorTextField.text = self.existingBookModel.author;
        self.publisherTextField.text = self.existingBookModel.publisher;
        self.categoriesTextField.text = self.existingBookModel.categories;
    }
}

- (void)configureForEditingExistingBook:(Book *)existingBook {
    self.isEditingBookMode = YES;
    self.existingBookModel = existingBook;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.titleTextField becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)cancelBarButtonItemDidPress {
    AddBookValidationState validationState = [self validationState];
    if (validationState == AddBookValidationStateIncomplete || validationState == AddBookValidationStateRequiredFieldsIncomplete) {
        [self handleIncompleteState];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)confirmBarButtonItemDidPress {
    switch ([self validationState]) {
        case AddBookValidationStateEmpty:
        case AddBookValidationStateRequiredFieldsIncomplete:
            [self handleRequiredFieldsIncompleteState];
            break;
        case AddBookValidationStateIncomplete:
        case AddBookValidationStateComplete:
            [self handleCompleteState];
            break;
    }
}

// MARK: - Validation State

- (AddBookValidationState)validationState {
    return [AddBookValidator validateWithTitleText:self.titleTextField.text
                                        authorText:self.authorTextField.text
                                     publisherText:self.publisherTextField.text
                                    categoriesText:self.categoriesTextField.text];
}

// MARK: Required Fields Incomplete State

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

// MARK: Incomplete State

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

// MARK: Complete State

- (void)handleCompleteState {
    NSString *title = self.titleTextField.text;
    NSString *author = self.authorTextField.text;
    NSString *publisher = self.publisherTextField.text;
    NSString *categories = self.categoriesTextField.text;
    
    Book *book = [[Book alloc] initWithTitle:title author:author publisher:publisher categories:categories];
    
    if (self.isEditingBookMode) {
        [self updateExistingBook:book];
    }
    else {
        [self addNewBook:book];
    }
}

- (void)updateExistingBook:(Book *)existingBook {
    [NetworkRequestManager updateBookRequestWithBook:existingBook completion:^(Book * _Nullable book, NSError * _Nullable error) {
        if (book == nil) {
            [self handleAddBookRequestError];
        }
        else {
            if (self.bookAddedAction) {
                self.bookAddedAction();
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)addNewBook:(Book *)newBook {
    [NetworkRequestManager postNewBookRequestWithBook:newBook completion:^(Book * _Nullable book, NSError * _Nullable error) {
        if (book == nil) {
            [self handleAddBookRequestError];
        }
        else {
            if (self.bookAddedAction) {
                self.bookAddedAction();
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)handleAddBookRequestError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                             message:@"That request failed. Would you like to try again?"
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

// MARK: UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.authorTextField becomeFirstResponder];
    }
    else if (textField == self.authorTextField) {
        [self.publisherTextField becomeFirstResponder];
    }
    else if (textField == self.publisherTextField) {
        [self.categoriesTextField becomeFirstResponder];
    }
    else if (textField == self.categoriesTextField) {
        [self.view endEditing:YES];
    }
    return YES;
}

@end
