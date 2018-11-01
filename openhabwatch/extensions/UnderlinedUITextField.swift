//
//  UITextFieldExtension.swift
//  openhabwatch
//
//  Created by Dirk Hermanns on 01.11.18.
//  Copyright © 2018 private. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    func setBottomBorder(withColor color: UIColor)
    {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}
