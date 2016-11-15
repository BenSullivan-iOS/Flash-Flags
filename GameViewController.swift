//
//  GameViewController.swift
//  PBROrbs
//
//  Created by Avihay Assouline on 23/07/2016.
//  Copyright © 2016 MediumBlog. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let materialPrefixes : [String] = ["bamboo-wood-semigloss",
                                       "oakfloor2",
                                       "scuffed-plastic",
                                       "rustediron-streaks"];
    
    func setupGlobe() {
        
        // create a new scene
        let scene = SCNScene(named: "sphere.obj")!
        
        // select the sphere node - As we know we only loaded one object
        // we select the first item on the children list
        let sphereNode = scene.rootNode.childNodes[0]
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 100)
        
        let material = sphereNode.geometry?.firstMaterial
        
        // Declare that you intend to work in PBR shading mode
        // Note that this requires iOS 10 and up
      if #available(iOS 10.0, *) {
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
      } else {
        // Fallback on earlier versions
      }
        
        // Setup the material maps for your object
        let materialFilePrefix = materialPrefixes[3];
        material?.diffuse.contents = UIImage(named: "\(materialFilePrefix)-albedo.png")
      if #available(iOS 10.0, *) {
        material?.roughness.contents = UIImage(named: "\(materialFilePrefix)-roughness.png")
        material?.metalness.contents = UIImage(named: "\(materialFilePrefix)-metal.png")

      } else {
        // Fallback on earlier versions
      }
        material?.normal.contents = UIImage(named: "\(materialFilePrefix)-normal.png")
        
        // Setup background - This will be the beautiful blurred background
        // that assist the user understand the 3D envirnoment
        let bg = UIImage(named: "sphericalBlurred.png")
        scene.background.contents = bg;
        
        // Setup Image Based Lighting (IBL) map
        let env = UIImage(named: "spherical.jpg")
      if #available(iOS 10.0, *) {
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 2.0

      } else {
        // Fallback on earlier versions
      }
      
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        
        /*
         * The following was not a part of my blog post but are pretty easy to understand:
         * To make the Orb cool, we'll add rotation animation to it
         */
        
        sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 10)))
    }
    


    
}

extension MainVC {
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
}
