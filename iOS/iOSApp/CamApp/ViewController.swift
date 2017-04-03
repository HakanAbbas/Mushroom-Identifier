//
//  ViewController.swift
//  CamApp
//
//  Created by mbkair02 on 18.08.16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var possibleMushrooms = Array<Mushroom>()
    
    @IBOutlet weak var mushroomImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    @IBOutlet weak var showResultLabel: UITextView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    
    @IBOutlet weak var spaceTopLabel: UIView!
    @IBOutlet weak var spaceBottomLabel: UIView!
    @IBOutlet weak var spaceBottomButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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

    
    @IBAction func selectPhoto(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        mushroomImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        //mushroomImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        getMushroom()
    }
    
    func getMushroom(){
        let bundle = Bundle.main
        
        let url1:NSURL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as NSURL
        let url2:NSURL = bundle.url(forResource: "mushroom_cascade", withExtension: "xml")! as NSURL
        possibleMushrooms = Array<Mushroom>()

        let mushrooms:NSMutableArray = OpenCVWrapper.detectMushroom(mushroomImage.image, url1.path, url2.path)
        
        mutToArray(mutArr: mushrooms, mushroomArr: &possibleMushrooms)
        
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
    
    func mutToArray(mutArr: NSMutableArray, mushroomArr: inout Array<Mushroom>){
        var tempMushroom = Mushroom()
        
        let arrSize = mutArr.count - 1
        
        if(arrSize >= 0){
            for i in 0...arrSize {
                tempMushroom.name = (mutArr[i] as! PilzC).name
                tempMushroom.wiki = (mutArr[i] as! PilzC).wiki
                tempMushroom.stalk = (mutArr[i] as! PilzC).stalk
            
                if((mutArr[i] as! PilzC).poisonous == 0){
                    tempMushroom.poisonous = false
                }
                else{
                    tempMushroom.poisonous = true
                }
            
                if((mutArr[i] as! PilzC).round == 0){
                    tempMushroom.round = false
                }
                else{
                    tempMushroom.round = true
                }
            
                if((mutArr[i] as! PilzC).lamell == 0){
                    tempMushroom.lamell = false
                }
                else{
                    tempMushroom.lamell = true
                }
            
                if((mutArr[i] as! PilzC).nodule == 0){
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

