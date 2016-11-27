//
//  GoogleImageSearchController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 27/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

public class GoogleImageSearch {
    
    public static let baseURL = "https://www.googleapis.com/customsearch/v1"
    
    public static let apiKey = "AIzaSyD6qXAmmrWw_KXlLemW2hJePaM5uVnl9Rw"
    public static let customSearchEngineId = "005205891837075401404:beshpf1s_1e"
    
    public typealias PerformSearchRequestCompletion = (_ imageURL: String?, _ error: Error?) -> Void
    
    public static func performSearch(forQuery query: String, completion: @escaping PerformSearchRequestCompletion) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "\(GoogleImageSearch.baseURL)?q=\(encodedQuery)&searchtype=image&key=\(GoogleImageSearch.apiKey)&cx=\(GoogleImageSearch.customSearchEngineId)") else { return }
        Alamofire.request(url).responseJSON {
            response in
            switch response.result {
            case .success(let data):
                guard let json = data as? JSON, let imageURL = GoogleImageSearch.parseImageURL(fromJSON: json) else {
                    completion(nil, nil)
                    return
                }
                completion(imageURL, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private static func parseImageURL(fromJSON JSON: JSON) -> String? {
        guard let results = JSON["items"] as? [JSON],
            let firstResult = results.first,
        let pageMap = firstResult["pagemap"] as? JSON,
        let scraped = pageMap["scraped"] as? [JSON],
        let imageURL = scraped.first?["image_link"] as? String else { return nil }
        return imageURL
    }
    
    public typealias LoadImageRequestCompletion = (_ image: UIImage?, _ error: Error?) -> Void
    
    public static func loadImage(forImageURL imageURL: String, completion: @escaping LoadImageRequestCompletion) {
        guard let url = URL(string: imageURL) else { return }
        Alamofire.request(url).responseData {
            response in
            switch response.result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(nil, nil)
                    return
                }
                completion(image, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
