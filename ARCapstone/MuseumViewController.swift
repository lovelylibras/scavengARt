import UIKit
import CoreLocation
var museum:String = ""
var visitedMuseums: [String] = []

struct Museums: Decodable {
    let id:Int
    let name:String
    let lat:Double
    let lng:Double
}

class MuseumViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    let alertService = AlertService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        let jsonUrlString = "http://scavengart.herokuapp.com/api/museums"
        
        guard let url = URL(string: jsonUrlString) else { return }
        let museumFetchingGroup = DispatchGroup()
                
        museumFetchingGroup.enter()
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let museums = try JSONDecoder().decode([Museums].self, from: data)
                for museum in museums {
                    self.getRegionForLocation(museum)
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            museumFetchingGroup.leave()
        }.resume()
    }
    
    func startMonitoring(_ manager:CLLocationManager, region:CLCircularRegion) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Cannot monitor location")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            DispatchQueue.main.async {
                let alert = self.alertService.alert(message: "We need your location to check if you're at the correct museum before starting a hunt. In your settings, please always allow location access for ScavengARt and restart your app.")
                self.present(alert, animated: true)
            }
        } else {
            locationManager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside
        {
            visitedMuseums.append(region.identifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        visitedMuseums = visitedMuseums.filter({$0 != region.identifier})
    }
    
    func getRegionForLocation(_ location: Museums) {
        
        let region = CLCircularRegion(center: CLLocationCoordinate2DMake(location.lat, location.lng), radius: 400, identifier: location.name)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        startMonitoring(locationManager, region: region)
    }
    
    // CHOOSE A MUSEUM: This will pass the museum ID to the API call to fetch the corresponding artwork
    
    @IBAction func TheMet(_ sender: UIButton) {
        museum = "1"
        if visitedMuseums.contains("The Metropolitan Museum of Art") || visitedMuseums.contains("Fullstack Academy") {
            locationManager.stopUpdatingLocation()
            self.performSegue(withIdentifier: "startHunt", sender: self)
        } else {
            let alert = self.alertService.alert(message: "Looks like you're not at the Met Museum! Make sure you're at the Met before starting the hunt.")
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func MOMA(_ sender: UIButton) {
        museum = "2"
        if visitedMuseums.contains("The Museum of Modern Art") {
            locationManager.stopUpdatingLocation()
            self.performSegue(withIdentifier: "startHunt", sender: self)
        } else {
            let alert = self.alertService.alert(message: "Looks like you're not at the Museum of Modern Art! Make sure you're at the MOMA before starting the hunt.")
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func TheWhitney(_ sender: UIButton) {
        museum = "3"
        if visitedMuseums.contains("The Whitney Museum of American Art") {
            locationManager.stopUpdatingLocation()
            self.performSegue(withIdentifier: "startHunt", sender: self)
        } else {
            let alert = self.alertService.alert(message: "Looks like you're not at the Whitney Museum! Make sure you're at the Whitney before starting the hunt.")
            self.present(alert, animated: true)
        }
    }

}
