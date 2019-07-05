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
        DispatchQueue.main.async{
        guard let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.name else { return }
        if(imageName == clues[0].name){
        let scannedImage = arrOfArt.filter({$0.name == imageName})
        self.selectedImage = scannedImage
       
        node.addChildNode(SuccessNode(withReferenceImage: imageAnchor.referenceImage))
    
        
        
        if (!visitedNames.contains(imageName) && clues[0].name == imageName) {
            visitedNames.append(imageName)
            visitedImages.append(images[imageName]!)
            clues.remove(at: 0)
        }
        self.performSegue(withIdentifier: "showImageInfo", sender: self)
        }
        }
        
    }
}

class ViewController: UIViewController  {
    
    var augmentedRealityConfiguration = ARWorldTrackingConfiguration()
    var augmentedRealitySession = ARSession()
    
    @IBOutlet weak var clueDisplayLabel: UILabel!
    @IBOutlet weak var augmentedRealityView: ARSCNView!
    @IBOutlet weak var homeButton: UIButton!
    

    
    var selectedImage : [Paintings]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startARSession()
        generateImagesFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if clues.isEmpty {
            homeButton.isHidden = false
            clueDisplayLabel.text = "You found all the paintings!!!!!! "
        }else {
            homeButton.isHidden = true
             clueDisplayLabel.text = "Find \(clues[0].name)"
        }
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
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }
}

    
    
    
    
    

