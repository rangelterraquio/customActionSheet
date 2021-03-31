//
//  CustomActionSheetSettings.swift
//  CustomActionSheet
//
//  Created by Rangel Cardoso Dias on 27/03/21.
//

import Foundation
import UIKit

public struct CustomActionSheetSettings {
   
    public struct HeaderSettings {
        public var backgroundColor: UIColor = .gray
        public var title: String = "Select  an option"
        public var font: UIFont =  UIFont.systemFont(ofSize: 16, weight: .bold)
        public var isHidden: Bool = false
        public var textColor: UIColor = .black
        public var headerHeight: CGFloat = 50
    }
    
    public struct CancelButtonSettings {
        public var title: String = "Cancel"
        public var font: UIFont =  UIFont.systemFont(ofSize: 14, weight: .regular)
        public var textColor: UIColor = .black
        public var backGorundColor: UIColor = .clear
    }
    
    public struct ConfimButtonSettings {
        public var title: String = "Ok"
        public var font: UIFont =  UIFont.systemFont(ofSize: 14, weight: .regular)
        public var textColor: UIColor = .black
        public var backGorundColor: UIColor = .clear
    }
    public struct TableViewStyle {
        public var lateralMargin: CGFloat = 0
        public var maximumHeight: CGFloat = UIScreen.main.bounds.height * 0.55
    }
    public struct PresentAnimationStyle {
        public var delay = TimeInterval(0.0)
        public var duration = TimeInterval(0.5)
        public var options = UIView.AnimationOptions.curveEaseOut
    }
    
    public struct DismissAnimationStyle {
        public var delay = TimeInterval(0.0)
        public var duration = TimeInterval(0.5)
        public var options = UIView.AnimationOptions.curveEaseIn
    }
    
    
    public struct AnimationStyle {
        public var present = PresentAnimationStyle()
        public var dismiss = DismissAnimationStyle()
    }
 
    public var cancelButton = CancelButtonSettings()
    
    public var confirmButton = ConfimButtonSettings()
    
    public var tableViewStyle = TableViewStyle()
    
    public var animation = AnimationStyle()
    
    public var header = HeaderSettings()
    
    public static func defaultSettings() -> CustomActionSheetSettings {
        return CustomActionSheetSettings()
    }
    
}
