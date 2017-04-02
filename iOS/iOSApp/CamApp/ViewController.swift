//
//  ViewController.swift
//  CamApp
//
//  Created by mbkair02 on 18.08.16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var possiblePilze = Array<Pilz>()
    
    @IBOutlet weak var mushroomImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    @IBOutlet weak var showResultLabel: UITextView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    
    @IBOutlet weak var spaceTopLabel: UIView!
    @IBOutlet weak var spaceBottomLabel: UIView!
    
    var a = OpenCVWrapper();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mushroomImage.image = OpenCVWrapper.DetectByColor(2)
        // Do any additional setup after loading the view, typically from a nib.
        
        //mushroomImage.backgroundColor = theme.viewbackground
        
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
        /*let url:NSURL = Bundle.main.url(forResource: "mushident", withExtension: "png")! as NSURL
        
        let str:String = url.path!
        
        let logo = UIBarButtonItem(image: UIImage(named: str), style: UIBarButtonItemStyle.bordered, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = logo*/
        
        backgroundView.backgroundColor = theme.viewbackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        getPilz()
    }
    
    func getPilz(){
        let bundle = Bundle.main
        
        let url1:NSURL = bundle.url(forResource: "schwammerl", withExtension: "xml")! as NSURL
        let url2:NSURL = bundle.url(forResource: "mushroom_cascade", withExtension: "xml")! as NSURL
        possiblePilze = Array<Pilz>()
        
        //showResultLabel.text = String(describing: OpenCVWrapper.detect(byColor: mushroomImage.image, url1.path, url2.path))
        //mushroomImage.image = OpenCVWrapper.DetectByColor(mushroomImage.image)

        let a:NSMutableArray = OpenCVWrapper.detectMushroom(mushroomImage.image, url1.path, url2.path)
        
        mutToArray(mutArr: a, pilzArr: &possiblePilze)
        
        if(possiblePilze.count > 1){
            showResultLabel.text = "Hat ihr Pilz Lamellen?";
            buttonYes.isHidden = false
            buttonNo.isHidden = false
        }
        else if(possiblePilze.count == 1){
            showResultLabel.text = possiblePilze[0].Name
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
        else{
            showResultLabel.text = "Leider keine Übereinstimmung"
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
        
    }
    
    func mutToArray(mutArr: NSMutableArray, pilzArr: inout Array<Pilz>){
        var p = Pilz()
        
        let to = mutArr.count - 1
        
        if(to >= 0){
            for i in 0...to {
                p.Name = (mutArr[i] as! PilzC).name
                p.Wiki = (mutArr[i] as! PilzC).wiki
                p.Stiel = (mutArr[i] as! PilzC).stalk
            
                if((mutArr[i] as! PilzC).poisonous == 0){
                    p.Giftigkeit = false
                }
                else{
                    p.Giftigkeit = true
                }
            
                if((mutArr[i] as! PilzC).round == 0){
                    p.Rund = false
                }
                else{
                    p.Rund = true
                }
            
                if((mutArr[i] as! PilzC).lamell == 0){
                    p.Lamellen = false
                }
                else{
                    p.Lamellen = true
                }
            
                if((mutArr[i] as! PilzC).nodule == 0){
                    p.Knolle = false
                }
                else{
                    p.Knolle = true
                }
            
                pilzArr.append(p)
            
                p = Pilz()
            }
        }
    }
    
    @IBAction func clickedYes(_ sender: UIButton) {
        var possiblePilze2 = Array<Pilz>()
        let to = possiblePilze.count-1
        
        if(showResultLabel.text == "Hat ihr Pilz Lamellen?"){
            
            for i in 0...to {
                if(possiblePilze[i].Lamellen){
                    possiblePilze2.append(possiblePilze[i])
                }
            }
            possiblePilze = possiblePilze2
            
            if(possiblePilze.count > 1){
                showResultLabel.text = "Hat ihr Pilz eine Knolle?"
            }
            else if(possiblePilze.count == 1){
                showResultLabel.text = possiblePilze[0].Name
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
            
            for i in 0...to {
                if(possiblePilze[i].Knolle){
                    possiblePilze2.append(possiblePilze[i])
                }
            }
            possiblePilze = possiblePilze2
            
            if(possiblePilze.count > 1){
                showResultLabel.text = "Hat ihr Pilz " + possiblePilze[0].Stiel + "?"
            }
            else if(possiblePilze.count == 1){
                showResultLabel.text = possiblePilze[0].Name
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
            showResultLabel.text = possiblePilze[0].Name
            buttonYes.isHidden = true
            buttonNo.isHidden = true
        }
    }
    
    @IBAction func clickedNo(_ sender: UIButton) {
        var possiblePilze2 = Array<Pilz>()
        let to = possiblePilze.count-1
        
        if(showResultLabel.text == "Hat ihr Pilz Lamellen?"){
            for i in 0...to {
                if(!possiblePilze[i].Lamellen){
                    possiblePilze2.append(possiblePilze[i])
                }
            }
            possiblePilze = possiblePilze2
            
            if(possiblePilze.count > 1){
                showResultLabel.text = "Hat ihr Pilz eine Knolle?";
            }
            else if(possiblePilze.count == 1){
                showResultLabel.text = possiblePilze[0].Name
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
            for i in 0...to {
                if(!possiblePilze[i].Knolle){
                    possiblePilze2.append(possiblePilze[i])
                }
            }
            possiblePilze = possiblePilze2
            
            if(possiblePilze.count > 1){
                showResultLabel.text = "Hat ihr Pilz " + possiblePilze[0].Stiel + "?"
            }
            else if(possiblePilze.count == 1){
                showResultLabel.text = possiblePilze[0].Name
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
            if(possiblePilze.count > 1){
                for i in 1...to {
                    possiblePilze2.append(possiblePilze[i])
                }
                possiblePilze = possiblePilze2
            
            
                showResultLabel.text = "Hat ihr Pilz " + possiblePilze[0].Stiel + "?"
            }
            else{
                showResultLabel.text = "Leider keine Übereinstimmung"
                buttonYes.isHidden = true
                buttonNo.isHidden = true
            }
        }
    }
    
}

