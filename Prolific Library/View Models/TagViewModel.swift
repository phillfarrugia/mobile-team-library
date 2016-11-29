//
//  TagViewModel.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

public class TagViewModel: NSObject {
    
    public let title: String
    
    init(title: String) {
        self.title = title
    }
    
    public static func tagViewModels(fromBookCellViewModels bookViewModels: [BookCellViewModel]) -> [TagViewModel] {
        var tagViewModels: [TagViewModel] = []
        for bookViewModel in bookViewModels {
            if let categories = bookViewModel.categories {
                let tags = categories.map { TagViewModel(title: $0) }.filter {
                    return !tagViewModels.contains($0)
                }
                tagViewModels.append(contentsOf: tags)
            }
        }
        return tagViewModels
    }
    
    public static func downloadAndCacheCoverImage(forViewModel viewModel: BookCellViewModel, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        GoogleImageSearch.performSearch(forQuery: "\(viewModel.title) \(viewModel.authors)", completion: {
            imageURL, error in
            if let imageURL = imageURL {
                ImageHandler.sharedInstance.downloadAndCacheImage(withImageURL: imageURL, completion: {
                    image, error in
                    guard let image = image else {
                        completion(nil, error)
                        return
                    }
                    completion(image, nil)
                })
            }
            else {
                completion(nil, error)
            }
        })
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? TagViewModel else {
            return false
        }
        let lhs = self
        return lhs.title == rhs.title
    }
    
}
