//
//  ModalAlertViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit

@objc
enum ModalAlertResult: Int {
    case Top
    case Middle
    case Bottom
}

class ModalAlertMessage: NSObject {
    
    var title: String?
    var body: String?
    
    let topButtonTitle: String?
    let middleButtonTitle: String?
    let bottomButtonTitle: String?
    
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let detailColor: UIColor
    
    var showTextField: Bool = false
    
    init(title: String?, body: String?, topButtonTitle: String?, middleButtonTitle: String?, bottomButtonTitle: String?, primaryColor: UIColor, secondaryColor: UIColor, detailColor: UIColor, showTextField: Bool) {
        self.title = title
        self.body = body
        self.showTextField = showTextField
        self.topButtonTitle = topButtonTitle
        self.middleButtonTitle = middleButtonTitle
        self.bottomButtonTitle = bottomButtonTitle
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.detailColor = detailColor
    }
    
}

typealias ModalAlertViewCompletion = (_ result: ModalAlertResult) -> Void

class ModalAlertViewController: UIViewController {
    
    static private let kBackgroundAlphaInitial: CGFloat = 0.0
    static private let kBackgroundAlphaFinal: CGFloat = 0.65
    
    static private let kModalViewAnimationDuration: TimeInterval = 0.5
    static private let kModalViewBounceThreshold: CGFloat = 0.4
    static private let kBackgroundAnimationDuration: TimeInterval = 0.2
    
    @IBOutlet internal var backgroundOverlayView: UIView!
    @IBOutlet internal var messageModalView: UIView!
    
    @IBOutlet var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bodyLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bodyLabelTopVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet internal var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var textFieldBottomConstraint: NSLayoutConstraint!

    @IBOutlet internal var topButton: UIButton!
    @IBOutlet var topButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet internal var middleButton: UIButton!
    @IBOutlet var middleVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var middleButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet internal var bottomButton: UIButton!
    @IBOutlet var bottomVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var bottomButtonHeightConstraint: NSLayoutConstraint!
    
    internal var alertMessage: ModalAlertMessage
    internal var completion: ModalAlertViewCompletion
    
    internal var tapGestureRecognizer: UIGestureRecognizer?
    
    init(message: ModalAlertMessage, completion: @escaping ModalAlertViewCompletion) {
        self.alertMessage = message
        self.completion = completion
        super.init(nibName: "ModalAlertViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundOverlayView.alpha = ModalAlertViewController.kBackgroundAlphaInitial
        messageModalView.isHidden = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModalAlertViewController.didTapOverlayView))
        if let tapGestureRecognizer = self.tapGestureRecognizer {
            backgroundOverlayView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    internal func didTapOverlayView() {
        view.endEditing(true)
        dismissModalView(completion: nil)
    }
    
    // MARK: Style
    
    private func configureStyles() {
        view.layer.cornerRadius = topButton.bounds.size.height/2
        view.backgroundColor = .clear
        view.isOpaque = false
        messageModalView.layer.cornerRadius  = 10.0
        messageModalView.layer.masksToBounds = true
    }
    
    // MARK: Message
    
    private func configure(alertMessage: ModalAlertMessage) {
        if let title = alertMessage.title {
            titleLabel.text = title
        }
        else {
            titleLabel.isHidden = true
            titleLabelHeightConstraint.isActive = true
            bodyLabelTopVerticalConstraint.constant = 0
            textFieldTopConstraint.constant = 0
        }
        
        if (!alertMessage.showTextField) {
            textFieldHeightConstraint.constant = 0
            textFieldBottomConstraint.constant = 0
        }
        else {
            textField.becomeFirstResponder()
        }
        
        if let body = alertMessage.body {
            bodyLabel.text = body
        }
        else {
            bodyLabel.isHidden = true
            bodyLabelHeightConstraint.isActive = true
        }
        
        if let topButtonTitle = alertMessage.topButtonTitle {
            topButton.setTitle(topButtonTitle, for: .normal)
            topButton.backgroundColor = alertMessage.primaryColor
            topButton.layer.cornerRadius = topButton.bounds.size.height/2
        }
        else {
            topButton.isHidden = true
            topButtonHeightConstraint.constant = 0
        }
        
        if let middleButtonTitle = alertMessage.middleButtonTitle {
            middleButton.setTitle(middleButtonTitle, for: .normal)
            middleButton.backgroundColor = alertMessage.secondaryColor
            middleButton.layer.cornerRadius = bottomButton.bounds.size.height/2
        }
        else {
            middleButton.isHidden = true
            middleButtonHeightConstraint.constant = 0
            middleVerticalConstraint.constant = 0
        }
        
        if let bottomButtonTitle = alertMessage.bottomButtonTitle {
            bottomButton.setTitle(bottomButtonTitle, for: .normal)
            bottomButton.backgroundColor = alertMessage.detailColor
            bottomButton.layer.cornerRadius = bottomButton.bounds.size.height/2
        }
        else {
            bottomButton.isHidden = true
            bottomButtonHeightConstraint.constant = 0
            textFieldTopConstraint.constant = 0
            bottomVerticalConstraint.constant = 0
        }
    }
    
    @IBAction func topButtonDidPress(_ sender: Any) {
        view.endEditing(true)
        dismissModalView {
            self.completion(.Top)
        }
    }
    
    @IBAction func middleButtonDidPress(_ sender: Any) {
        view.endEditing(true)
        dismissModalView {
            self.completion(.Middle)
        }
    }
    
    @IBAction func bottomButtonDidPress(_ sender: Any) {
        view.endEditing(true)
        dismissModalView {
            self.completion(.Bottom)
        }
    }
    
    // MARK: Animation
    
    func animateModalView() {
        configureStyles()
        configure(alertMessage: alertMessage)
        
        // Scale to 0.1 initially
        messageModalView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        messageModalView.isHidden = false
        
        // Animate to full size with bounce
        let modalViewTransformScale = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let modalViewCenter = messageModalView.center
        
        UIView.animate(withDuration: ModalAlertViewController.kModalViewAnimationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.messageModalView.transform = modalViewTransformScale
            self.messageModalView.center = modalViewCenter
        }, completion: {
            _ in
        })
        
        UIView.animate(withDuration: ModalAlertViewController.kBackgroundAnimationDuration, animations: {
            self.backgroundOverlayView.alpha = ModalAlertViewController.kBackgroundAlphaFinal
        })
    }
    
    func dismissModalView(completion: (() -> Void)?) {
        UIView.animate(withDuration: ModalAlertViewController.kBackgroundAnimationDuration, animations: {
            self.messageModalView.alpha = 0.0
            self.backgroundOverlayView.alpha = ModalAlertViewController.kBackgroundAlphaInitial
        }, completion: {
            _ in
            self.dismiss(animated: true, completion: completion)
        })
    }
    
}
