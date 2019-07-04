import UIKit
import ARKit

//global variables
struct Hunt: Decodable {
    let name:String
    let description:String
    let paintings:[Paintings]
}
struct Paintings: Decodable {
    let name:String
    let artist:String
    let imageUrl:String
    let description:String
}
var arrOfArt: [Paintings] = []
class HomeViewController: UIViewController, URLSessionDownloadDelegate {
    var index = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        let jsonUrlString = "http://scavengart.herokuapp.com/api/hunt/\(museum)"

        guard let url = URL(string: jsonUrlString) else {
            return }
        let imageFetchingGroup = DispatchGroup()
        
        imageFetchingGroup.enter()
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else { return }
            do {
                let hunt = try JSONDecoder().decode(Hunt.self, from: data)
                for i in hunt.paintings {
                    arrOfArt.append(i)
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            print(arrOfArt)
            imageFetchingGroup.leave()
        }.resume()
        
        imageFetchingGroup.notify(queue: .main) {
         self.downloadImageTask(media:arrOfArt)
        }
    }
    
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
 
}
