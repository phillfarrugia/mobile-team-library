//
//  TagBubbleViewContainer.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit

class TagBubbleViewContainer: UIView {

    func layoutTagViews(forTags tags: [String], withColor color: UIColor, displayMultiLine: Bool = false) {
        var xOrigins: CGFloat = bounds.origin.x
        var yOrigins: CGFloat = bounds.origin.y
        let kHoriontalMargin: CGFloat = 8.0
        let kVerticalMargin: CGFloat = 8.0
        
        removeTagViews()
        
        for tag in tags {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = tag
            label.sizeToFit()
            
            let circularViewWidth = label.frame.width + 20
            let circularViewHeight = label.frame.height + 8
            
            var labelFrame = label.frame
            label.textColor = .white
            labelFrame.origin = CGPoint(x: 10, y: 4)
            label.frame = labelFrame
            
            // Only adds tag if it fits within the remaining space of container width
            if (xOrigins + circularViewWidth + kHoriontalMargin < bounds.size.width) {
                let circularViewFrame = CGRect(x: xOrigins, y: yOrigins, width: circularViewWidth, height: circularViewHeight)
                addCircularView(withFrame: circularViewFrame, color: color, label: label)
                xOrigins += (circularViewWidth + kHoriontalMargin)
            }
            else {
                if (displayMultiLine) {
                    xOrigins = bounds.origin.x
                    yOrigins += circularViewHeight + kVerticalMargin
                    let circularViewFrame = CGRect(x: xOrigins, y: yOrigins, width: circularViewWidth, height: circularViewHeight)
                    addCircularView(withFrame: circularViewFrame, color: color, label: label)
                    xOrigins += (circularViewWidth + kHoriontalMargin)
                }
            }
        }
    }
    
    private func addCircularView(withFrame frame: CGRect, color: UIColor, label: UILabel) {
        let circularView = UIView()
        let circularViewFrame = frame
        circularView.frame = circularViewFrame
        circularView.backgroundColor = color
        circularView.layer.cornerRadius = circularView.frame.height/2
        circularView.addSubview(label)
        addSubview(circularView)
    }
    
    private func removeTagViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

}
