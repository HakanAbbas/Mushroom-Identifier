//
//  DetailViewController.swift
//  MushroomIdentifier
//
//  Created by mbkair02 on 21.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var mushroom = Mushroom()   //Pilz zu dem details angezeigt werden
    var cells = Array<String>() //angezeigter Text
    var indexMushroom:Int = 0   //Zeile in der der Pilz angezeigt wird
    let theme = ThemeManager.currentTheme()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Design
        
        self.view.backgroundColor = theme.viewbackground
        
        initView()
        
        self.tableView.separatorStyle = .none
        
        self.tableView.isScrollEnabled = false
        
        self.tableView.contentInset = UIEdgeInsets(top: 10,left: 0,bottom: 0,right: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Spalten: 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Zeilen: 7
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    //Aufbau der einzelnen Tabellenzeilen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = self.cells[indexPath.row]
        
        cell.isUserInteractionEnabled = false
        
        //Überschrift
        if(indexPath.row == 0){
            cell.textLabel?.font = cell.textLabel?.font.withSize(30)
        }
        //Wiki Link
        else if(indexPath.row == 6){
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textColor = theme.secondaryColor
        }
        //Sonst: Aufzählungspunkt
        else{
            cell.textLabel?.text = "\u{2022}  " + (cell.textLabel?.text)!
        }
        
        cell.backgroundColor = theme.viewbackground
        
        return cell
    }
    
    //Wikipedia Link
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.openUrl(url: mushroom.wiki)
    }
    
    //Aufbau des anzuzeigenden Textes
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
    }
    
    //Wikipedia Link
    func openUrl(url:String!) {
        
        let targetURL=NSURL(string: url)
        
        let application=UIApplication.shared
        
        application.openURL(targetURL as! URL);
        
    }
    
    
}
