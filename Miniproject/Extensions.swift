//
//  Extensions.swift
//  Miniproject
//
//  Created by apple on 11/11/24.
//

import Foundation
import UIKit

extension UIView{
    
    public var width : CGFloat{
        return frame.size.width
    }
    public var height : CGFloat{
        return frame.size.height
    }
    public var top : CGFloat{
        return frame.origin.y
    }
    public var bottom : CGFloat{
        return frame.size.height + frame.origin.y
    }
    public var left : CGFloat{
        return frame.origin.x
        
    }
    public var right : CGFloat{
        return frame.size.width + frame.origin.x
        
    }

}

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        // Create the toast label
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0

        // Adjust label size
        let padding: CGFloat = 16
        toastLabel.frame = CGRect(
            x: padding,
            y: self.view.frame.size.height - 100,
            width: self.view.frame.size.width - (padding * 2),
            height: 50
        )
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        // Add label to view
        self.view.addSubview(toastLabel)

        // Set fade in and fade out animations
        toastLabel.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
