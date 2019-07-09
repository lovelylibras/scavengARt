import UIKit

class ImageInformationViewController: UIViewController {
    
    // OUTLETS FOR UI ELEMENTS
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    
    // IMAGEINFORMATION PASSED FROM ARVIEWCONTROLLER
    var imageInformation : [Paintings]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Distributes information to appropriate display fields
        if let actualImageInformation = imageInformation {
            self.imageView.image = images[actualImageInformation[0].name]
            self.nameLabel.text = actualImageInformation[0].name
            self.artistLabel.text = actualImageInformation[0].artist
            self.descLabel.text = actualImageInformation[0].description
        }
    }
    
    // HANDLES CLOSE
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
