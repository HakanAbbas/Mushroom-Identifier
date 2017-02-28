//
//  TableViewController.swift
//  CamApp
//
//  Created by mbkair02 on 15.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController /*, XMLParserDelegate */ {
    
    var a = OpenCVWrapper();
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()
    var pilz = Pilz()
    var pilze = Array<Pilz>()
    
    var name = false
    var wiki = false
    var giftigkeit = false
    var rund = false
    var lamelle = false
    var knolle = false
    var stiel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = ThemeManager.currentTheme()
        
        self.view.backgroundColor = theme.viewbackground
        
        parseXml()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pilze.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = pilze[indexPath.row].Name
        
        let bundle = Bundle.main
        
        if let url = (bundle.url(forResource: pilze[indexPath.row].Name, withExtension: "png")) {
            cell.imageView?.image = UIImage(contentsOfFile: url.path)
        }
        else{
            let url = (bundle.url(forResource: "mushident", withExtension: "png"))
            cell.imageView?.image = UIImage(contentsOfFile: (url?.path)!)
        }
        
        return cell
    }
    
    func parseXml(){
        let bundle = Bundle.main
        
        let url:URL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as URL
        
        var a:NSMutableArray  = OpenCVWrapper.allMushs(url.path)
        
        mutToArray(mutArr: a, pilzArr: &pilze)
        
        print("")
    }
    
    func mutToArray(mutArr: NSMutableArray, pilzArr: inout Array<Pilz>){
        var p = Pilz()
        
        let to = mutArr.count - 1
        
        for i in 0...to {
            p.Name = (mutArr[i] as! PilzC).name
            p.Wiki = (mutArr[i] as! PilzC).wiki
            p.Stiel = (mutArr[i] as! PilzC).stiel
            
            if((mutArr[i] as! PilzC).giftigkeitt == 0){
                p.Giftigkeit = false
            }
            else{
                p.Giftigkeit = true
            }
            
            if((mutArr[i] as! PilzC).rund == 0){
                p.Rund = false
            }
            else{
                p.Rund = true
            }
            
            if((mutArr[i] as! PilzC).lamellen == 0){
                p.Lamellen = false
            }
            else{
                p.Lamellen = true
            }
            
            if((mutArr[i] as! PilzC).knolle == 0){
                p.Knolle = false
            }
            else{
                p.Knolle = true
            }
            
            pilzArr.append(p)
            
            p = Pilz()
        }
    }

    
    /*func parseXml(){
        let bundle = Bundle.main
        
        let url:URL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as URL
        
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        print(url.path)
        
        if success {
            print("parse success!")
            
            print(strXMLData)
            
            print("count: " + String(pilze.count))
            print((pilze.first?.Name)!)
        } else {
            print("parse failure!")
        }
    }
    
    func fillArray(){
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        /*currentElement=elementName;
        //if(elementName=="Farbe" || elementName=="Name" || elementName=="HSV-von" || elementName=="HSV-bis" || elementName=="HSV-von2" || elementName=="HSV-bis2" || elementName=="Wiki" || elementName=="Giftigkeit" || elementName=="Rund" || elementName=="Lamellen" || elementName=="Knolle" || elementName=="Stiel")
        if(elementName=="Name" || elementName=="Wiki" || elementName=="Giftigkeit" || elementName=="Rund" || elementName=="Lamellen" || elementName=="Knolle" || elementName=="Stiel")
        {
            /*if(elementName=="Wiki"){
                passName=true;
            }*/
            passData=true;
        }*/
        
        if(elementName=="Name"){
            self.name = true
        }
        else if(elementName=="Wiki"){
            self.wiki = true
        }
        else if(elementName=="Giftigkeit"){
            self.giftigkeit = true
        }
        else if(elementName=="Rund"){
            self.rund = true
        }
        else if(elementName=="Lamellen"){
            self.lamelle = true
        }
        else if(elementName=="Knolle"){
            self.knolle = true
        }
        else if(elementName=="Stiel"){
            self.stiel = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName=="Name"){
            self.name = false
        }
        else if(elementName=="Wiki"){
            self.wiki = false
        }
        else if(elementName=="Giftigkeit"){
            self.giftigkeit = false
        }
        else if(elementName=="Rund"){
            self.rund = false
        }
        else if(elementName=="Lamellen"){
            self.lamelle = false
        }
        else if(elementName=="Knolle"){
            self.knolle = false
        }
        else if(elementName=="Stiel"){
            self.stiel = false
            pilze.append(pilz)
            pilz = Pilz()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(self.name){
            pilz.Name = pilz.Name + string
        }
        else if(self.wiki){
            pilz.Wiki = pilz.Wiki + string
        }
        else if(self.giftigkeit){
            if(Int(string) == 0){
                pilz.Giftigkeit = false
            }
            else{
                pilz.Giftigkeit = true
            }
        }
        else if(self.rund){
            if(Int(string) == 0){
                pilz.Rund = false
            }
            else{
                pilz.Rund = true
            }
        }
        else if(self.lamelle){
            if(Int(string) == 0){
                pilz.Lamellen = false
            }
            else{
                pilz.Lamellen = true
            }
        }
        else if(self.knolle){
            if(Int(string) == 0){
                pilz.Knolle = false
            }
            else{
                pilz.Knolle = true
            }
        }
        else if(self.stiel){
            pilz.Stiel = pilz.Stiel + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "showDetail") {
            let indexPath = self.tableView.indexPathForSelectedRow
            let destViewController = segue.destination as! DetailViewController
            //let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
            
            destViewController.pilz = pilze[(indexPath?.row)!]
            destViewController.indexPilz = (indexPath?.row)!
            
            print("Zelle: ")
            print(indexPath?.row)
            print(destViewController.pilz)
        }
    }

}
