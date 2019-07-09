import UIKit
var museum:String = ""


class MuseumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // CHOOSE A MUSEUM: This will pass the museum ID to the API call to fetch the corresponding artwork
    
    @IBAction func TheMet(_ sender: UIButton) {
        museum = "1"
    }
    
    @IBAction func MOMA(_ sender: UIButton) {
        museum = "2"
    }
    
    @IBAction func TheWhitney(_ sender: UIButton) {
        museum = "3"
    }

}
