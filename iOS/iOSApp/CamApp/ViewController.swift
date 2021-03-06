//
//  ViewController.swift
//  MushroomIdentifier
//
//  Created by Markus Arbeithuber on 18.08.16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var possibleMushrooms = Array<Mushroom>()   //darin werden die von der Bilderkennung erkannten Pilze gespeichert
    
    @IBOutlet weak var mushroomImage: UIImageView!  //Bild vom fotografierten/aus der Galerie ausgewählten Pilz
    @IBOutlet weak var cameraButton: UIButton!      //Button zum Foto machen
    @IBOutlet weak var selectPhotoButton: UIButton! //Button zum Foto aus Galerie auswählen
    
    @IBOutlet weak var showResultLabel: UITextView! //Anzeige von Fragen und Ergebnis der Erkennung
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var buttonYes: UIButton!         //Button für Benutzerfragen
    @IBOutlet weak var buttonNo: UIButton!          //Button für Benutzerfragen
    
    @IBOutlet weak var spaceTopLabel: UIView!
    @IBOutlet weak var spaceBottomLabel: UIView!
    @IBOutlet weak var spaceBottomButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Design (Hintergrund, Buttons, ...)
        let theme = ThemeManager.currentTheme()
        
        buttonYes.isHidden = true
        buttonNo.isHidden = true
        
        cameraButton.backgroundColor = theme.viewbackground
        cameraButton.tintColor = theme.secondaryColor
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = theme.secondaryColor.cgColor
        
        selectPhotoButton.backgroundColor = theme.viewbackground
        selectPhotoButton.tintColor = theme.secondaryColor
        selectPhotoButton.layer.borderWidth = 1
        selectPhotoButton.layer.borderColor = theme.secondaryColor.cgColor
        
        showResultLabel.textAlignment = .center
        showResultLabel.backgroundColor = theme.viewbackground
        
        showResultLabel.sizeToFit()
        showResultLabel.layoutIfNeeded()
        showResultLabel.isScrollEnabled = false
        showResultLabel.isEditable = false
        
        showResultLabel.font?.withSize(10)
        
        spaceBottomLabel.backgroundColor = theme.viewbackground
        spaceTopLabel.backgroundColor = theme.viewbackground
        spaceBottomButton.backgroundColor = theme.viewbackground
        
        backgroundView.backgroundColor = theme.viewbackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Foto aus Galerie auswählen
    @IBAction func selectPhoto(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    //Foto machen
    @IBAction func takePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    //wenn das Foto geladen ist, kann mit dieser Methode damit gearbeitet werden
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        mushroomImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        //mushroomImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        getMushroom()
    }
    
    //Aufruf der Pilzerkennung
    func getMushroom(){
        
        let bundle = Bundle.main
        
        let urlMushrooms:NSURL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as NSURL
        let urlHaar:NSURL = bundle.url(forResource: "mushroom_cascade", withExtension: "xml")! as NSURL
        possibleMushrooms = Array<Mushroom>()

        let mushrooms:NSMutableArray = OpenCVWrapper.detectMushroom(mushroomImage.image, urlMushrooms.path, urlHaar.path)
        
        mutToArray(mutArr: mushrooms, mushroomArr: &possibleMushrooms)
        
        //Bei nicht eindeutiger Erkennung werden die Buttons eingeblendet und die erste Frage (Hat ihr Pilz Lammelen) gestellt, ansonsten kann bereits der Name des Pilzes, bzw bei keiner Übereinstimmung eine Meldung ausgegeben werden.
        if(possibleMushrooms.count > 1){
            showResultLabel.text = "Hat ihr Pilz Lamellen?";
            buttonYes.isHidden = false
            buttonNo.isHidden = false
        }
        else if(possibleMushrooms.count == 1){
            showResultLabel.text = possibleMushrooms[0].name
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
        else{
            showResultLabel.text = "Leider keine Übereinstimmung"
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
        
    }
    
    //Umwandlung des Objective C Arrays in ein Swift Array
    func mutToArray(mutArr: NSMutableArray, mushroomArr: inout Array<Mushroom>){
        var tempMushroom = Mushroom()
        
        let arrSize = mutArr.count - 1
        
        if(arrSize >= 0){
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
    }
    
    //Benutzerfragen bei KLick auf Ja
    @IBAction func clickedYes(_ sender: UIButton) {
        var possibleMushrooms2 = Array<Mushroom>()
        let arrSize = possibleMushrooms.count-1
        
        if(showResultLabel.text == "Hat ihr Pilz Lamellen?"){
            
            for i in 0...arrSize {
                if(possibleMushrooms[i].lamell){
                    possibleMushrooms2.append(possibleMushrooms[i])
                }
            }
            possibleMushrooms = possibleMushrooms2
            
            if(possibleMushrooms.count > 1){
                showResultLabel.text = "Hat ihr Pilz eine Knolle?"
            }
            else if(possibleMushrooms.count == 1){
                showResultLabel.text = possibleMushrooms[0].name
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            
            print("")
        }
        else if(showResultLabel.text == "Hat ihr Pilz eine Knolle?"){
            
            for i in 0...arrSize {
                if(possibleMushrooms[i].nodule){
                    possibleMushrooms2.append(possibleMushrooms[i])
                }
            }
            possibleMushrooms = possibleMushrooms2
            
            if(possibleMushrooms.count > 1){
                showResultLabel.text = "Hat ihr Pilz " + possibleMushrooms[0].stalk + "?"
            }
            else if(possibleMushrooms.count == 1){
                showResultLabel.text = possibleMushrooms[0].name
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            
            print("")
        }
        else{
            showResultLabel.text = possibleMushrooms[0].name
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
    }
    
    //Benutzerfragen bei Klick auf Nein
    @IBAction func clickedNo(_ sender: UIButton) {
        var possibleMushrooms2 = Array<Mushroom>()
        let arrSize = possibleMushrooms.count-1
        
        if(showResultLabel.text == "Hat ihr Pilz Lamellen?"){
            for i in 0...arrSize {
                if(!possibleMushrooms[i].lamell){
                    possibleMushrooms2.append(possibleMushrooms[i])
                }
            }
            possibleMushrooms = possibleMushrooms2
            
            if(possibleMushrooms.count > 1){
                showResultLabel.text = "Hat ihr Pilz eine Knolle?";
            }
            else if(possibleMushrooms.count == 1){
                showResultLabel.text = possibleMushrooms[0].name
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            print("")
        }
            
        else if(showResultLabel.text == "Hat ihr Pilz eine Knolle?"){
            for i in 0...arrSize {
                if(!possibleMushrooms[i].nodule){
                    possibleMushrooms2.append(possibleMushrooms[i])
                }
            }
            possibleMushrooms = possibleMushrooms2
            
            if(possibleMushrooms.count > 1){
                showResultLabel.text = "Hat ihr Pilz " + possibleMushrooms[0].stalk + "?"
            }
            else if(possibleMushrooms.count == 1){
                showResultLabel.text = possibleMushrooms[0].name
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
            print("")
        }
        else{
            if(possibleMushrooms.count > 1){
                for i in 1...arrSize {
                    possibleMushrooms2.append(possibleMushrooms[i])
                }
                possibleMushrooms = possibleMushrooms2
            
            
                showResultLabel.text = "Hat ihr Pilz " + possibleMushrooms[0].stalk + "?"
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
        }
    }
    
}

