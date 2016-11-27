//
//  ProlificLibraryCoreTests.swift
//  ProlificLibraryCoreTests
//
//  Created by Phill Farrugia on 27/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Quick
import Nimble

class AddBookValidatorSpec: QuickSpec {
    override func spec() {

        describe("validate", {
            
            context("all empty", {
                it("should return required fields incompete", closure: {
                    expect(AddBookValidator.validate(titleText: "", authorText: "", publisherText: "", categoriesText: "")).to(equal(AddBookValidationState.RequiredFieldsIncomplete))
                })
            })
            
            context("title", {
                it("should return required fields incompete", closure: {
                    expect(AddBookValidator.validate(titleText: "random book title", authorText: "", publisherText: "", categoriesText: "")).to(equal(AddBookValidationState.RequiredFieldsIncomplete))
                })
            })
            
            context("title and author", {
                it("should return incompete", closure: {
                    expect(AddBookValidator.validate(titleText: "book name", authorText: "author name here", publisherText: "", categoriesText: "")).to(equal(AddBookValidationState.Incomplete))
                })
            })
            
            context("title, author and publisher", {
                it("should return incompete", closure: {
                    expect(AddBookValidator.validate(titleText: "book name", authorText: "author name here", publisherText: "publishing house", categoriesText: "")).to(equal(AddBookValidationState.Incomplete))
                })
            })
            
            context("title, author, publisher and categories", {
                it("should return complete", closure: {
                    expect(AddBookValidator.validate(titleText: "book name", authorText: "author name here", publisherText: "publishing house", categoriesText: "ios, dev, books")).to(equal(AddBookValidationState.Complete))
                })
            })
            
            context("no title", {
                it("should return required fields incompete", closure: {
                    expect(AddBookValidator.validate(titleText: "", authorText: "erica sadun", publisherText: "objcio", categoriesText: "ios, swift, programming")).to(equal(AddBookValidationState.RequiredFieldsIncomplete))
                })
            })
            
        })
        
    }
}
