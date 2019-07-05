//
//  SuccessNode.swift
//  scavengARt
//
//  Created by Ahsun on 7/5/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation
import ARKit

class SuccessNode: SCNNode{
    init(withReferenceImage target:ARReferenceImage) {
        super.init()
        
        let thumbScene = SCNScene(named: "art.scnassets/success.scn")
        var thumbNode: SCNNode?
        thumbNode = thumbScene?.rootNode.childNode(withName: "thumb", recursively: false)
        self.addChildNode(thumbNode!)
    }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}
