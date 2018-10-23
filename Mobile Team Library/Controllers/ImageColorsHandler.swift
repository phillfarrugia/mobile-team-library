//
//  ImageColorsHandler.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import UIImageColors

public class ImageColorsHandler: NSObject {
    
    public static func colors(forImage image: UIImage, completion: @escaping (_ primaryColor: UIColor, _ secondaryColor: UIColor, _ detailColor: UIColor) -> Void) {
        image.getColors { (colors) in
            completion(colors.primaryColor, colors.secondaryColor, colors.detailColor)
        }
    }
    
}
