//
//  Mushroom.swift
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 15.12.16.
//  Copyright © 2016 user. All rights reserved.
//

class Mushroom {

    var name: String
    var wiki: String
    var poisonous: Bool
    var round: Bool
    var lamell: Bool
    var nodule: Bool
    var stalk: String

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
