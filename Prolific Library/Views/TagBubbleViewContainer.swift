//
//  TagBubbleViewContainer.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit

class TagBubbleViewContainer: UIView {

    func layoutTagViews(forTags tags: [String], withColor color: UIColor) {
        var xOrigins: CGFloat = bounds.origin.x
        let kHoriontalMargin: CGFloat = 8.0
        removeTagViews()
        
        for tag in tags {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = tag
            label.sizeToFit()
            
            let circularView = UIView()
            circularView.frame = CGRect(x: xOrigins, y: bounds.origin.y, width: label.frame.width + 20, height: label.frame.height + 8)
            circularView.backgroundColor = color
            circularView.layer.cornerRadius = circularView.frame.height/2
            circularView.addSubview(label)
            
            var labelFrame = label.frame
            label.textColor = .white
            labelFrame.origin = CGPoint(x: 10, y: 4)
            label.frame = labelFrame
            
            // Only adds tag if it fits within the remaining space of container width
            if (xOrigins + (circularView.frame.size.width + kHoriontalMargin) < bounds.size.width) {
                addSubview(circularView)
                xOrigins += (circularView.frame.size.width + kHoriontalMargin)
            }
        }
    }
    
    private func removeTagViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

}