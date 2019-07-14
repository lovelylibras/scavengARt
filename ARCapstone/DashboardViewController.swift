//
//  DashboardViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/8/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//
import CoreLocation
import UIKit

var userNameGlobal:String = ""
var userGlobal = User(id: 0, name: "", userName: "")
var completedGames = [Game]()


class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    let gamesNetworkingService = GamesNetworkingService()
      let alertService = AlertService()
    

    // INITIALIZES USER
    var user = User(id: 0, name: "", userName: "")

    
    // OUTLET FOR UI ELEMENTS
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        gamesNetworkingService.request(endpoint:"api/games/\(userGlobal.id)") { (result) in
            switch result {
            case .success(let games):
                completedGames = games
               
            case .failure(let error):
                let alert = self.alertService.alert(message: error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
        
        

        // Set text for welcoming user
        welcomeText.text = "Welcome, \(userGlobal.name)"
    }
    

}
