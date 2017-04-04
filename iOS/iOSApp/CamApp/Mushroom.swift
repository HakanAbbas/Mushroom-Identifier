//
//  Mushroom.swift
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 15.12.16.
//  Copyright © 2016 user. All rights reserved.
//

class Mushroom {

    var name: String    //Name
    var wiki: String    //Wiki Link
    var poisonous: Bool //giftig?
    var round: Bool     //rund?
    var lamell: Bool    //Lamellen?
    var nodule: Bool    //Knolle?
    var stalk: String   //Stiel

    init(){
        self.name = ""
        self.wiki = ""
        self.poisonous = true
        self.round = true
        self.lamell = true
        self.nodule = true
        self.stalk = ""
    }
    
    init(name: String, wiki: String, poisonous:Bool, round:Bool, lamell:Bool, nodule:Bool, stalk: String) {
        self.name = name
        self.wiki = wiki
        self.poisonous = poisonous
        self.round = round
        self.lamell = lamell
        self.nodule = nodule
        self.stalk = stalk
    }
}
