//
//  DetailViewController.swift
//  MushroomIdentifier
//
//  Created by mbkair02 on 21.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var mushroom = Mushroom()
    var cells = Array<String>()
    var indexMushroom:Int = 0
    let theme = ThemeManager.currentTheme()
    
    /*
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rund: UILabel!
    @IBOutlet weak var lamellen: UILabel!
    @IBOutlet weak var knolle: UILabel!
    @IBOutlet weak var stiel: UILabel!
    @IBOutlet weak var wiki: UIButton!
    @IBOutlet weak var giftigkeit: UILabel!
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = theme.viewbackground
        
        initView()
        
        self.tableView.separatorStyle = .none
        
        self.tableView.isScrollEnabled = false
        
        self.tableView.contentInset = UIEdgeInsets(top: 10,left: 0,bottom: 0,right: 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = self.cells[indexPath.row]
        
        cell.isUserInteractionEnabled = false
        
        if(indexPath.row == 0){
            cell.textLabel?.font = cell.textLabel?.font.withSize(30)
        }
        else if(indexPath.row == 6){
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textColor = theme.secondaryColor
        }
        else{
            cell.textLabel?.text = "\u{2022}  " + (cell.textLabel?.text)!
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.openUrl(url: mushroom.wiki)
    }
    
    func initView(){
        
        self.cells.append(self.mushroom.name)
        
        
        if(self.mushroom.poisonous){
            self.cells.append("giftig")
        }
        else{
            self.cells.append("nicht giftig")
        }
        
        self.cells.append(self.mushroom.stalk)
        
        if(self.mushroom.round){
            self.cells.append("rund")
        }
        else{
            self.cells.append("nicht rund")
        }
        
        if(self.mushroom.lamell){
            self.cells.append("hat Lamellen")
        }
        else{
            self.cells.append("hat keine Lamellen")
        }
        
        if(self.mushroom.nodule){
            self.cells.append("hat eine Knolle")
        }
        else{
            self.cells.append("hat keine Knolle")
        }
        
        self.cells.append("hier klicken für Wikipedia Link")
        
        /*
        self.name.sizeToFit()
        self.rund.sizeToFit()
        self.lamellen.sizeToFit()
        self.knolle.sizeToFit()
        self.giftigkeit.sizeToFit()
        self.stiel.sizeToFit()
        self.wiki.sizeToFit()*/
    }
    /*
    @IBAction func wikiLink(_ sender: UIButton) {
        self.openUrl(url: pilz.Wiki)
    }*/
    
    func openUrl(url:String!) {
        
        let targetURL=NSURL(string: url)
        
        let application=UIApplication.shared
        
        application.openURL(targetURL as! URL);
        
    }
    
    
}
