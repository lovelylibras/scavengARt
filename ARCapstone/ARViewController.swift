import UIKit
import SceneKit
import ARKit
import AVFoundation

//global variables
var images : [String: UIImage] = [:]
var visitedNames : [String] = []
var visitedImages : [UIImage] = []


extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node:SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.name else { return }
        let scannedImage = arrOfArt.filter({$0.name == imageName})
        self.selectedImage = scannedImage
        print("SCANNEDIMAGE", scannedImage)
        node.addChildNode(SuccessNode(withReferenceImage: imageAnchor.referenceImage))
        
        self.performSegue(withIdentifier: "showImageInfo", sender: self)
        
        if !visitedNames.contains(imageName) {
            visitedNames.append(imageName)
            visitedImages.append(images[imageName]!)
        }
        
    }
}

class ViewController: UIViewController  {
    
    var augmentedRealityConfiguration = ARWorldTrackingConfiguration()
    var augmentedRealitySession = ARSession()
    
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var augmentedRealityView: ARSCNView!
    var selectedImage : [Paintings]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startARSession()
        generateImagesFromServer()
    }

    func startARSession(){
        augmentedRealityView.session = augmentedRealitySession
        augmentedRealityView.delegate = self
        
        augmentedRealitySession.run(augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    func generateImagesFromServer(){
        ImageDownloader.downloadImagesFromPaths { (result) in
            switch result{
                
            case .success(let dynamicContent):
                
                self.augmentedRealityConfiguration.maximumNumberOfTrackedImages = arrOfArt.count
                self.augmentedRealityConfiguration.detectionImages = dynamicContent
                self.augmentedRealitySession.run(self.augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
                print("It was a success!!!!!")
            case .failure(let error):
                
                print("An Error Occured Generating The Dynamic Reference Images \(error)")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInfo" {
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage{
                print("ACTUALSELECTEDIMAGE", actualSelectedImage)
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }
}

    
    
    
    
    

