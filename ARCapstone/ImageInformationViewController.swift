import UIKit

class ImageInformationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    
    var imageInformation : [Paintings]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let actualImageInformation = imageInformation {
            self.imageView.image = images[actualImageInformation[0].name]
            self.nameLabel.text = actualImageInformation[0].name
            self.artistLabel.text = actualImageInformation[0].artist
            self.descLabel.text = actualImageInformation[0].description
        }
     
    }
    
    @IBAction func closeModal(_ sender: Any) {
    
    }
    
    
}
