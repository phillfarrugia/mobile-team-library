//
//  ImageHandler.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import AlamofireImage

public class ImageHandler {
    
    public static let sharedInstance = ImageHandler()
    
    private let imageDownloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                                  downloadPrioritization: .fifo,
                                                  maximumActiveDownloads: 10,
                                                  imageCache: AutoPurgingImageCache())
    
    public typealias DownloadAndCacheImageRequestCompletion = (_ image: UIImage?, _ error: Error?) -> Void
    
    public func downloadAndCacheImage(withImageURL imageURL: URL, completion: @escaping DownloadAndCacheImageRequestCompletion) {
        if let cachedImage = imageDownloader.imageCache?.image(withIdentifier: imageURL.absoluteString) {
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
    
}
