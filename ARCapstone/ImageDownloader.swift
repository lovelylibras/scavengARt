//
//  ImageDownloader.swift
//  scavengARt
//
//  Created by Ahsun on 7/5/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation
import UIKit
import ARKit

// HANDLES CONVERSION TO UIIMAGES AND DISTRIBUTES INTO ARREFERENCESET
class ImageDownloader{
    typealias completionHandler = (Result<Set<ARReferenceImage>, Error>) -> ()
    typealias ImageData = (image: UIImage, orientation: CGImagePropertyOrientation, physicalWidth: CGFloat, name: String)

    static var receivedImageData = [ImageData]()

    class func downloadImagesFromPaths(_ completion: @escaping completionHandler) {
        let operationQueue = OperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 6
        
        let completionOperation = BlockOperation {
            OperationQueue.main.addOperation({
                completion(.success(referenceImageFrom(receivedImageData)))
            })
        }
        
        arrOfArt.forEach { (art) in
            guard let url = URL(string: art.imageUrl) else { return }
            
            let operation = BlockOperation(block: {
                do{
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        receivedImageData.append(ImageData(image, .up, 0.1, art.name))
                        images.updateValue(image, forKey: art.name)
                    }
                }catch{
                    completion(.failure(error))
                }
            })
            completionOperation.addDependency(operation)
        }
        
        operationQueue.addOperations(completionOperation.dependencies, waitUntilFinished: true)
        operationQueue.addOperation(completionOperation)
    }

    class func referenceImageFrom(_ downloadedData: [ImageData]) -> Set<ARReferenceImage>{
        var referenceImages = Set<ARReferenceImage>()
        
        downloadedData.forEach {
            guard let cgImage = $0.image.cgImage else {return}
            let referenceImage = ARReferenceImage(cgImage, orientation: $0.orientation, physicalWidth: $0.physicalWidth)
            referenceImage.name = $0.name
            referenceImages.insert(referenceImage)
        }
        print("REFERENCEIMAGES", referenceImages)
        return referenceImages
    }
}
