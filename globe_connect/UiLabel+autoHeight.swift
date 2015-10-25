//
//  UiLabel+autoHeight.swift
//  globe_connect
//
//  Created by Jonas Torfs on 25/10/15.
//  Copyright © 2015 Jonas Torfs. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}
