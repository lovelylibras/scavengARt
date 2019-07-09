//
//  SuccessNode.swift
//  scavengARt
//
//  Created by Ahsun on 7/5/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation
import ARKit

// CREATES THE TROPHY NODE FOR SUCCESSFUL RECOGNITION
class SuccessNode: SCNNode{
    init(withReferenceImage target:ARReferenceImage) {
        super.init()
        
        let successScene = SCNScene(named: "art.scnassets/trophyScene.scn")
        var successNode: SCNNode?
        successNode = successScene?.rootNode.childNode(withName: "trophy", recursively: false)
        self.addChildNode(successNode!)
    }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}
