import UIKit
var museum:String = ""


class MuseumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func TheMet(_ sender: UIButton) {
        museum = "1"
    }
    @IBAction func MOMA(_ sender: UIButton) {
        museum = "2"
    }
    @IBAction func TheWhitney(_ sender: UIButton) {
        museum = "3"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
