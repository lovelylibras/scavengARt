import UIKit
import SceneKit
import ARKit
import AVFoundation

//global variables
var images : [String: UIImage] = [:]
var visitedNames : [String] = []
var visitedImages : [UIImage] = []

class ViewController: UIViewController, ARSCNViewDelegate, URLSessionDownloadDelegate {
    @IBOutlet var sceneView: ARSCNView!
    let imageFetchingGroup = DispatchGroup()
    var selectedImage : [Paintings]?
    var index = 1
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
        
        imageFetchingGroup.enter()
        downloadImageTask(media:arrOfArt)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        imageFetchingGroup.notify(queue: .main) {
            let configuration = ARWorldTrackingConfiguration()
            let detectionImages = self.loadedImagesFromDirectoryContents()
            configuration.detectionImages = detectionImages
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
//    func addReferences(media: [Paintings]) {
//        var imageSet = Set<ARReferenceImage>()
//        let imageFetchingGroup = DispatchGroup()
//        for medium in media {
//
//            let name = medium.name
//            let imageUrl = medium.imageUrl
//            let url = URL(string: imageUrl)
//            let session = URLSession(configuration: .default)
//
//            imageFetchingGroup.enter()
//            let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
//                if let e = error {
//                    print("Error downloading picture: \(e)")
//                    imageFetchingGroup.leave()
//                }else {
//                    if let res = response as? HTTPURLResponse {
//                        print("Downloaded picture with response code \(res.statusCode)")
//                        if let imageData = data {
//                            let image = UIImage(data: imageData)!
//                            images.updateValue(image, forKey: medium.name)
//                            let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(image.cgImage!.width) )
//                            arImage.name = name
//                            imageSet.insert(arImage)
//                            imageFetchingGroup.leave()
//                        }else {
//                            print("Couldn't get image: Image is nil")
//                            imageFetchingGroup.leave()
//                        }
//                    }else {
//                        print("Couldn't get response code")
//                        imageFetchingGroup.leave()
//                    }
//                }
//            }
//            downloadPicTask.resume()
//        }
//        self.configuration = ARWorldTrackingConfiguration()
//        imageFetchingGroup.notify(queue: .main) {
//            self.configuration.detectionImages = imageSet
//            self.sceneView.session.run(self.configuration)
//        }
//    }
    
    
    
    func downloadImageTask(media: [Paintings]){
        
        for medium in media {
            let imageUrl = medium.imageUrl
            //1. Get The URL Of The Image
            guard let url = URL(string: imageUrl) else {
                return
            }
            //2. Create The Download Session
            let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            //3. Create The Download Task & Run It
            let downloadTask = downloadSession.downloadTask(with: url)
            downloadTask.resume()
            print("My image url:", imageUrl)
        }
        print("1")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        imageFetchingGroup.enter()
        //1. Create The Filename
        let fileURL = getDocumentsDirectory().appendingPathComponent("image\(index).png")
        //2. Copy It To The Documents Directory
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
            print("Successfuly Saved File \(fileURL)")
            index = index + 1
        } catch {
            print("Error Saving: \(error)")
        }
        print("3")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("2")
        return documentsDirectory
    }
    
    /// Creates A Set Of ARReferenceImages From All PNG Content In The Documents Directory
    ///
    /// - Returns: Set<ARReferenceImage>
    func loadedImagesFromDirectoryContents() -> Set<ARReferenceImage>?{
        var index = 0
        var customReferenceSet = Set<ARReferenceImage>()
        let documentsDirectory = getDocumentsDirectory()
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            let filteredContents = directoryContents.filter{ $0.pathExtension == "png" }
            filteredContents.forEach { (url) in
                do{
                    //1. Create A Data Object From Our URL
                    let imageData = try Data(contentsOf: url)
                    guard let image = UIImage(data: imageData) else { return }
                    //2. Convert The UIImage To A CGImage
                    guard let cgImage = image.cgImage else { return }
                    //3. Get The Width Of The Image
                    let imageWidth = CGFloat(cgImage.width)
                    //4. Create A Custom AR Reference Image With A Unique Name
                    let customARReferenceImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: imageWidth)
                    customARReferenceImage.name = "MyCustomARImage\(index)"
                    //4. Insert The Reference Image Into Our Set
                    customReferenceSet.insert(customARReferenceImage)
                    print("ARReference Image == \(customARReferenceImage)")
                    index += 1
                }catch{
                    print("Error Generating Images == \(error)")
                }
            }
        } catch {
            print("Error Reading Directory Contents == \(error)")
        }
        //5. Return The Set
        print("HELLOOOOOO")
        return customReferenceSet
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor,
        let referenceImageName = imageAnchor.referenceImage.name {
            let scannedImage = arrOfArt.filter({$0.name == referenceImageName})
            self.selectedImage = scannedImage
//            self.performSegue(withIdentifier: "showImageInfo", sender: self)
            guard let thumb = sceneView.scene.rootNode.childNode(withName: "thumb", recursively: false) else { return }
//            thumb.removeFromParentNode()
            node.addChildNode(thumb)
            thumb.isHidden = false
            
//            if !visitedNames.contains(referenceImageName) {
//                visitedNames.append(referenceImageName)
//                visitedImages.append(images[referenceImageName]!)
//            }
        }
        print("recognized the image!")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showImageInfo" {
//            if let imageInformationVC = segue.destination as? ImageInformationViewController,
//                let actualSelectedImage = selectedImage {
//                imageInformationVC.imageInformation = actualSelectedImage
//            }
//        }
//    }

}
