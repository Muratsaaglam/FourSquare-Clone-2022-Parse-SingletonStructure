//
//  PlacesVS.swift
//  FourSquare-Clone-2022
//
//  Created by Murat Sağlam on 4.02.2022.
//

import UIKit
import Parse


class PlacesVS: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var seleectedPlaceId = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Buttons
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    @objc func addButtonClicked()
    {
        //Segue
        self.performSegue(withIdentifier: "toAddPlaceVS", sender: nil)
    }
    
    
    // Data Parse
    
    func getDataFromParse()
    {
        let query = PFQuery(className: "Places")
               query.findObjectsInBackground { (objects, error) in
                   if error != nil {
                       self.makeAlert(titleınput: "Error", messageInput: error?.localizedDescription ?? "Error")
                   } else {
                       if objects != nil {
                           
                           self.placeIdArray.removeAll(keepingCapacity: false)
                           self.placeNameArray.removeAll(keepingCapacity: false)
                           
                           for object in objects! {
                               if let placeName = object.object(forKey: "name") as? String {
                                   if let placeId = object.objectId {
                                       self.placeNameArray.append(placeName)
                                       self.placeIdArray.append(placeId)
                                   }

                               }
                           }
                           
                           self.tableView.reloadData()
                       }
                   }
               }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDeatilsVS"
        {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = seleectedPlaceId
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDeatilsVS", sender: nil)
    }
    
    
    
    @objc func logoutButtonClicked()
    {
        PFUser.logOutInBackground { (error) in
            if error != nil
            {
                self.makeAlert(titleınput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }
            else
            {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                
            }
                
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func makeAlert(titleınput: String, messageInput: String)
    {
        let alert = UIAlertController(title: titleınput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
