//
//  TableViewController.swift
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 15.02.17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController /*, XMLParserDelegate */ {
    
/*
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()
 */
    
    var clickedMushroom = Mushroom()
    var mushrooms = Array<Mushroom>()
    
    var name = false
    var wiki = false
    var poisonous = false
    var round = false
    var lamell = false
    var nodule = false
    var stalk = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let theme = ThemeManager.currentTheme()
        
        self.view.backgroundColor = theme.viewbackground
        
        loadMushrooms()
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
        return mushrooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = mushrooms[indexPath.row].name
        
        let bundle = Bundle.main
        
        if let url = (bundle.url(forResource: mushrooms[indexPath.row].name, withExtension: "png")) {
            cell.imageView?.image = UIImage(contentsOfFile: url.path)
        }
        else{
            let url = (bundle.url(forResource: "mushident", withExtension: "png"))
            cell.imageView?.image = UIImage(contentsOfFile: (url?.path)!)
        }
        
        return cell
    }
    
    func loadMushrooms(){
        let bundle = Bundle.main
        
        let url:URL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as URL
        
        let mushroomsC:NSMutableArray  = OpenCVWrapper.allMushrooms(url.path)
        
        mutToArray(mutArr: mushroomsC, mushroomArr: &mushrooms)
        
    }
    
    func mutToArray(mutArr: NSMutableArray, mushroomArr: inout Array<Mushroom>){
        var tempMushroom = Mushroom()
        
        let arrSize = mutArr.count - 1
        
        for i in 0...arrSize {
            tempMushroom.name = (mutArr[i] as! MushroomC).name
            tempMushroom.wiki = (mutArr[i] as! MushroomC).wiki
            tempMushroom.stalk = (mutArr[i] as! MushroomC).stalk
            
            if((mutArr[i] as! MushroomC).poisonous == 0){
                tempMushroom.poisonous = false
            }
            else{
                tempMushroom.poisonous = true
            }
            
            if((mutArr[i] as! MushroomC).round == 0){
                tempMushroom.round = false
            }
            else{
                tempMushroom.round = true
            }
            
            if((mutArr[i] as! MushroomC).lamell == 0){
                tempMushroom.lamell = false
            }
            else{
                tempMushroom.lamell = true
            }
            
            if((mutArr[i] as! MushroomC).nodule == 0){
                tempMushroom.nodule = false
            }
            else{
                tempMushroom.nodule = true
            }
            
            mushroomArr.append(tempMushroom)
            
            tempMushroom = Mushroom()
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
            
            destViewController.mushroom = mushrooms[(indexPath?.row)!]
            destViewController.indexMushroom = (indexPath?.row)!
        }
    }

}
