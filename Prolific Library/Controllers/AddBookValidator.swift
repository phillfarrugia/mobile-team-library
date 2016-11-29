//
//  AddBookValidator.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

@objc
public enum AddBookValidationState: Int {
    case Empty
    case RequiredFieldsIncomplete
    case Incomplete
    case Complete
}

@objc public class AddBookValidator: NSObject {
    
    public static func validate(titleText: String, authorText: String, publisherText: String, categoriesText: String) -> AddBookValidationState {
        let hasTitleText = titleText.characters.count > 0
        let hasAuthorText = authorText.characters.count > 0
        let hasPublisherText = publisherText.characters.count > 0
        let hasCategoriesText = categoriesText.characters.count > 0
        
        if (!hasTitleText && !hasAuthorText && !hasPublisherText && !hasCategoriesText) {
            return .Empty
        }
        else if (!hasTitleText || !hasAuthorText) {
            return .RequiredFieldsIncomplete
        }
        else if (!hasPublisherText || !hasCategoriesText) {
            return .Incomplete
        }
        else {
            return .Complete
        }
    }
    
}
