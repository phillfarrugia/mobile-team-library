//
//  AddBookViewController.m
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

#import "AddBookViewController.h"

@interface AddBookViewController ()

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmBarButtonItemDidPress {
    // TODO: Send a Network Request to Add Book
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
