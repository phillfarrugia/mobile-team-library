//
//  ImageHandler.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import AlamofireImage

public class ImageHandler: NSObject {
    
    public static let sharedInstance = ImageHandler()
    
    private let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                  downloadPrioritization: .fifo,
                                                  maximumActiveDownloads: 20,
                                                  imageCache: AutoPurgingImageCache())
    
    public typealias DownloadAndCacheImageRequestCompletion = (_ image: UIImage?, _ error: Error?) -> Void
    
    public func downloadImage(withImageURL imageURL: URL, queryString: String, completion: @escaping DownloadAndCacheImageRequestCompletion) {
        let urlRequest = URLRequest(url: imageURL)
        imageDownloader.download(urlRequest, completion: {
            response in
            switch (response.result) {
            case .success(let image):
                completion(image, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    private func cache(image: UIImage, forQueryString queryString: String, withURL url: URL) {
        if let imageCache = imageDownloader.imageCache {
            imageCache.add(image, withIdentifier: queryString)
        }
        else {
            print("No cache")
        }
    }
    
    public func cachedImage(forQueryString queryString: String) -> UIImage? {
        if let imageCache = imageDownloader.imageCache {
            return imageCache.image(withIdentifier: queryString)
        }
        return nil
    }
    
    public static func cachedImageOrDownloadImage(forQueryString queryString: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        if let cachedImage = ImageHandler.sharedInstance.cachedImage(forQueryString: queryString) {
            completion(cachedImage, nil)
        }
        else {
            GoogleImageSearch.performSearch(forQuery: queryString, completion: {
                imageURL, error in
                if let imageURL = imageURL {
                    ImageHandler.sharedInstance.downloadImage(withImageURL: imageURL, queryString: queryString, completion: {
                        image, error in
                        guard let image = image else {
                            completion(nil, error)
                            return
                        }
                        ImageHandler.sharedInstance.cache(image: image, forQueryString: queryString, withURL: imageURL)
                        completion(image, nil)
                    })
                }
                else {
                    completion(nil, error)
                }
            })
        }
    }
    
}
