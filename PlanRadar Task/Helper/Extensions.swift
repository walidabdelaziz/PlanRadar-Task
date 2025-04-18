//
//  extensions.swift
//  PlanRadar Task
//
//  Created by Walid Ahmed on 17/04/2025.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import Kingfisher

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
private var loaderKey: UInt8 = 0
extension UIView {
    func dropShadow(radius: CGFloat, opacity: Float = 0.3, offset: CGSize = CGSize(width: 1.5, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = UIScreen.main.scale
    }
    private var loader: NVActivityIndicatorView? {
        get { objc_getAssociatedObject(self, &loaderKey) as? NVActivityIndicatorView }
        set { objc_setAssociatedObject(self, &loaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func showLoader() {
        guard loader == nil else { return }

        let width = frame.width * 0.15
        let frame = CGRect(
            origin: CGPoint(x: self.frame.midX - width / 2, y: self.frame.midY - width / 2),
            size: CGSize(width: width, height: width)
        )
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineScale, color: .primaryColor, padding: 8)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.loader = activityIndicator
    }

    func hideLoader() {
        loader?.stopAnimating()
        loader?.removeFromSuperview()
        loader = nil
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
extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
extension Double {
    var toCelsius: Double {
        return self - 273.15
    }
    var toCelsiusString: String {
        return String(format: "%.1f°C", self.toCelsius)
    }
}

extension UIImageView {
    func setImageFromUrl(
        imageStr: String,
        placeholder: String? = nil) {
        guard let imageURL = URL(string: imageStr) else {
            self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
            return
        }
        self.kf.setImage(
            with: imageURL,
            placeholder: placeholder != nil ? UIImage(named: placeholder!) : nil,
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(1))
            ]
        ) { result in
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure(let error):
                if !error.isTaskCancelled && !error.isNotCurrentTask {
                    self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
                    self.contentMode = .scaleAspectFit
                }
            }
        }
    }
}
