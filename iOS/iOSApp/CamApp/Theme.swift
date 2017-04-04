//
//  OpenCVWrapper.m
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 31.01.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

enum Theme:Int {
    case Default, Dark, Graphical
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 242.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Default, .Graphical:
            return .default
        case .Dark:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        //return self == .Graphical ? UIImage(named: "mushident") : nil
        
        let url:NSURL = Bundle.main.url(forResource: "mushident", withExtension: "png")! as NSURL
        
        let str:String = url.path!
        
        return UIImage(named: str)
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .Graphical ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default, .Graphical:
            return UIColor(white: 0.9, alpha: 1.0)
        case .Dark:
            return UIColor(white: 0.8, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        case .Graphical:
            return UIColor(red: 140.0/255.0, green: 50.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
    
    var buttonbackground: UIColor{
        return UIColor(red: 50.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    }
    
    var barcolor: UIColor{
        return UIColor(red: 242.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
    
    var viewbackground: UIColor{
        return UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
}

struct ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        // 1
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // 2
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.secondaryColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        //UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, forBarMetrics: .Default)
        UINavigationBar.appearance().barTintColor = theme.barcolor
        
        
        //UINavigationBar.appearance().setBackgroundImage(backgroundImage: UIImage?, forBarMetrics: <#T##UIBarMetrics#>)

        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")

        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        UITabBar.appearance().barTintColor = theme.barcolor
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        /*UIButton.appearance().backgroundColor = UIColor.white
        UIButton.appearance().tintColor = theme.secondaryColor*/
        
        //UITableViewCell.appearance().backgroundColor = theme.viewbackground
        
        //UIButton.appearance().layer.cornerRadius = 50
        
        //UIView.appearance().backgroundColor = theme.viewbackground
        
        //UIImageView.appearance().backgroundColor = UIColor.redColor()
        
    }
}




