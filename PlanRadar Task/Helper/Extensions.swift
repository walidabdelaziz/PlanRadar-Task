//
//  extensions.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    @nonobjc class var primaryColor: UIColor {
        return UIColor(hexString: "#2388C7")
    }
    @nonobjc class var secondaryColor: UIColor {
        return UIColor(hexString: "#3d4548")
    }
    @nonobjc class var lightGrayColor: UIColor {
        return UIColor(hexString: "#e8e6eb")
    }
}
extension UIView {
    func dropShadow(radius: CGFloat, opacity: Float = 0.3, offset: CGSize = CGSize(width: 1.5, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .primaryColor
    }
    func paddingLeft(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func paddingRight(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}

extension UIColor {
    
    @nonobjc class var PrimaryColor: UIColor {
        return UIColor(hexString: "#3484F0")
    }
    @nonobjc class var SecondaryColor: UIColor {
        return UIColor(hexString: "#F33829")
    }
    @nonobjc class var black55: UIColor {
        return UIColor(white: 0.0, alpha: 0.55)
    }
    @nonobjc class var PlaceHolderColor: UIColor {
        return UIColor(hexString: "#707070")
    }
}
extension UIDevice{
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

extension UIFont {
    
    static func noc_mediumSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        var font: UIFont
        if #available(iOS 8.2, *) {
            font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        } else {
            font = UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
        }
        return font
    }
    
}
