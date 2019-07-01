
import UIKit
import SceneKit
import ARKit
import AVFoundation

struct ImageInformation {
    let name: String
    let description: String
    let image: UIImage
}

let urls : NSArray = ["https://collectionapi.metmuseum.org/api/collection/v1/iiif/12127/33591/restricted", "https://collectionapi.metmuseum.org/api/collection/v1/iiif/436532/1671316/main-image", "https://collectionapi.metmuseum.org/api/collection/v1/iiif/438158/799953/main-image"]

class ViewController: UIViewController, ARSCNViewDelegate {
    var configuration = ARWorldTrackingConfiguration()

    @IBOutlet var sceneView: ARSCNView!
    var selectedImage : ImageInformation?
    
    let images = ["mdmX" : ImageInformation(name: "Madame X", description: "Portrait of Madame X is the title of a portrait painting by John Singer Sargent of a young socialite, Virginie Amélie Avegno Gautreau, wife of the French banker Pierre Gautreau. Madame X was painted not as a commission, but at the request of Sargent. It is a study in opposition. Sargent shows a woman posing in a black satin dress with jeweled straps, a dress that reveals and hides at the same time. The portrait is characterized by the pale flesh tone of the subject contrasted against a dark colored dress and background. The scandal resulting from the painting's controversial reception at the Paris Salon of 1884 amounted to a temporary set-back to Sargent while in France, though it may have helped him later establish a successful career in Britain and America.", image: UIImage(named: "ColormdmX")!)]
    
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    
    var captureDevice: AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//         Create a new scene
        let successScene = SCNScene(named: "art.scnassets/success.scn")!
        
  
//         Set the scene to the view
        sceneView.scene = successScene
       
        self.addReferences(media: urls)
        
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
    }
    
    func addReferences(media: NSArray) {
        var imageSet = Set<ARReferenceImage>()
        let imageFetchingGroup = DispatchGroup()
        for medium in media {
            let ref = medium as! String
            let url = URL(string: ref)
            let session = URLSession(configuration: .default)
            
            imageFetchingGroup.enter()
            let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                    imageFetchingGroup.leave()
                }else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            let image = UIImage(data: imageData)!
                            let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(image.cgImage!.width) )
                            arImage.name = "mdmX"
                            print("arImage", arImage)
                            imageSet.insert(arImage)
                            imageFetchingGroup.leave()
                        }else {
                            print("Couldn't get image: Image is nil")
                            imageFetchingGroup.leave()
                        }
                    }else {
                        print("Couldn't get response code")
                        imageFetchingGroup.leave()
                    }
                }
            }
            downloadPicTask.resume()
        }
        self.configuration = ARWorldTrackingConfiguration()
        imageFetchingGroup.notify(queue: .main) {
            self.configuration.detectionImages = imageSet
            self.sceneView.session.run(self.configuration)
        }
    }
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
        let scannedImage = self.images[referenceImageName] {
            self.selectedImage = scannedImage
            self.performSegue(withIdentifier: "showImageInfo", sender: self)
            guard let thumb = sceneView.scene.rootNode.childNode(withName: "thumb", recursively: false) else { return }
            thumb.removeFromParentNode()
            node.addChildNode(thumb)
            thumb.isHidden = false
        
        }
 

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInfo" {
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage {
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }

    
}
