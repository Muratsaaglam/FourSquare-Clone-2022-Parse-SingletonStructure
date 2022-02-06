//
//  ViewController.swift
//  FourSquare-Clone-2022
//
//  Created by Murat Sağlam on 3.02.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    
    
    
    @IBAction func signInClicked(_ sender: Any)
    {
        
        if userNameText.text != "" && passwordText.text != ""
        {
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil
                {
                    self.makeALert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else
                {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
        }
        else
        {
            
            makeALert(titleInput: "Error", messageInput: "Usreame / Passowrd Ist Not Null")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any)
    {
        if userNameText.text != "" && passwordText.text != ""
        {
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { (succes, error) in
                if error != nil
                {
                    self.makeALert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                }
                else
                {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else
        {
            makeALert(titleInput: "Error", messageInput: "UserName / Password Is Not Null")
        }
        
    }
    
    func makeALert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

