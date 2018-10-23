//
//  UIViewController+ModalAlertView.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

extension UIViewController {
    
    internal func presentModalAlertView(withMessage message: ModalAlertMessage, completion: @escaping (_ result: ModalAlertResult) -> Void) {
        let modalAlertViewController = ModalAlertViewController(message: message, completion: completion)
        modalAlertViewController.modalPresentationStyle = .overFullScreen
        modalAlertViewController.modalTransitionStyle = .crossDissolve
        present(modalAlertViewController, animated: false, completion: {
            modalAlertViewController.animateModalView()
        })
    }
    
    internal func presentModalTextInputAlertView(withMessage message: ModalAlertMessage, completion: @escaping (_ result: ModalAlertResult, _ textFieldText: String?) -> Void) {
        let modalAlertViewController = ModalAlertViewController(message: message, completion: {
            completionResult in
            completion(completionResult, message.textFieldText)
        })
        modalAlertViewController.modalPresentationStyle = .overFullScreen
        modalAlertViewController.modalTransitionStyle = .crossDissolve
        present(modalAlertViewController, animated: false, completion: {
            modalAlertViewController.animateModalView()
        })
    }
    
}
