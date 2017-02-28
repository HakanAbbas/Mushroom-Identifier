//
//  InfoController.swift
//  CamApp
//
//  Created by mbkair02 on 17.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = ThemeManager.currentTheme()
        
        self.view.backgroundColor = theme.viewbackground
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
