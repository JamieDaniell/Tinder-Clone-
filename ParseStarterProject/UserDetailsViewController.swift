//
//  UserDetailsViewController.swift
//  Tinder(Clone)
//
//  Created by James Daniell on 21/12/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    @IBOutlet weak var userImage: UIImageView!
    @IBAction func updateProfileImage(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            userImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestedInSwitch: UISwitch!
    
    @IBAction func update(_ sender: Any)
    {
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success,error) in
            if error != nil
            {
                var errorMessage = "Update failed - please try again"
                if let parseError = (error! as NSError).userInfo["error"] as? String
                {
                    errorMessage = parseError
                }
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert )
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("Updated")
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
            }
        })
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let isFemale = PFUser.current()?["isFemale"] as? Bool
        {
            genderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool
        {
            interestedInSwitch.setOn(isInterestedInWomen, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFile
        {
            photo.getDataInBackground(block: { ( data, error ) in
                if let imageData = data
                {
                    if let downloadedImage = UIImage(data: imageData)
                    {
                        self.userImage.image = downloadedImage
                    }
                }
            
            })
        }
        /*
        let urlArray = ["http://www.theunknownpen.com/wp-content/uploads/2013/03/Marge.jpg", "http://vignette2.wikia.nocookie.net/simpsons/images/7/73/Mindy_Simmons_updated.png/revision/latest?cb=20140205200229", "http://static4.comicvine.com/uploads/square_small/8/80778/2054878-judge_constance_harm.png", "http://vignette1.wikia.nocookie.net/simpsons/images/5/54/Temp.png/revision/latest?cb=20131208164211"]
        
        var counter = 0
        for urlString in urlArray
        {
            
            let url = URL(string: urlString)
            do
            {
                let data = try Data(contentsOf: url!)
                let imageFile = PFFile(name: "photo.png", data: data)
                let user = PFUser()
                user["photo"] = imageFile
                user.username = String(counter)
                user.password = "pass"
                user["isInterestedInWomen"] = false
                user["isFemale"] = true
                
                let acl = PFACL()
                acl.getPublicWriteAccess = true
                user.acl = acl
                
                user.signUpInBackground(block: { (success , error) in
                    if success
                    {
                        print("success user signed up")
                    }
                    else
                    {
                        if error != nil
                        {
                            var errorMessage = "Signup failed - please try again"
                            if let parseError = (error! as NSError).userInfo["error"] as? String
                            {
                                errorMessage = parseError
                            }
                            print(errorMessage)
                        }
                    }
                })
                counter += 1
                
            }
            catch
            {
                print("could not fetch data")
            }
        }
        
        */
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
