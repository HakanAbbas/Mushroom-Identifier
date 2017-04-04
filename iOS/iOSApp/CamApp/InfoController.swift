//
//  InfoController.swift
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 17.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var nodule: UITextView!
    @IBOutlet weak var lamell: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Hintergrundfarben der Textfelder und View
        let theme = ThemeManager.currentTheme()
        
        self.view.backgroundColor = theme.viewbackground
        nodule.backgroundColor = theme.viewbackground
        lamell.backgroundColor = theme.viewbackground
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
