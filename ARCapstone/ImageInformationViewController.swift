//
//  ImageInformationViewController.swift
//  scavengARt
//
//  Created by Audra Kenney on 6/28/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class ImageInformationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!
    
    var imageInformation : ImageInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        if let actualImageInformation = imageInformation {
            self.nameLabel.text = actualImageInformation.name
            self.imageView.image = actualImageInformation.image
            self.infoText.text = actualImageInformation.description
        }
        print(imageInformation)
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
