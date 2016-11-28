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
                                                  maximumActiveDownloads: 10,
                                                  imageCache: AutoPurgingImageCache())
    
    public typealias DownloadAndCacheImageRequestCompletion = (_ image: UIImage?, _ error: Error?) -> Void
    
    public func downloadAndCacheImage(withImageURL imageURL: URL, completion: @escaping DownloadAndCacheImageRequestCompletion) {
        if let cachedImage = cachedImage(forURLString: imageURL.absoluteString) {
            completion(cachedImage, nil)
        }
        else {
            let urlRequest = URLRequest(url: imageURL)
            imageDownloader.download(urlRequest, completion: {
                response in
                switch (response.result) {
                case .success(let image):
                    self.cache(image: image, forURLString: imageURL.absoluteString)
                    completion(image, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            })
        }
    }
    
    private func cache(image: UIImage, forURLString urlString: String) {
        if let imageCache = imageDownloader.imageCache {
            imageCache.add(image, withIdentifier: urlString)
        }
    }
    
    public func cachedImage(forURLString urlString: String) -> UIImage? {
        if let imageCache = imageDownloader.imageCache {
            return imageCache.image(withIdentifier: urlString)
        }
        return nil
    }
    
    public static func downloadAndCacheCoverImage(forQueryString queryString: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        GoogleImageSearch.performSearch(forQuery: queryString, completion: {
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
    
}
