//
//  GameController.swift
//  MFGridMeshLab Shared
//
//  Created by Tristan Leblanc on 19/01/2025.
//

import SceneKit
import MFSCNExtensions
import MFGridUtils

#if os(macOS)
    typealias SCNColor = NSColor
#else
    typealias SCNColor = UIColor
#endif

@MainActor
class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene(named: "Art.scnassets/ship.scn")!
        
        super.init()
        
        sceneRenderer.delegate = self
        
        if let ship = scene.rootNode.childNode(withName: "ship", recursively: true) {
            ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        }
        
        // Add a mesh node ( must import MFSCNExtension and MFGridUtils )
        
        // 1 - Create a grid object
        let grid = MFGrid(gridSize: 40, cellSize: 2)
        
        // 2 - Create a mesh using the grid
        let meshNode = MFSCNGridMeshNode(grid: grid)
        
        // 3 - Slightly move the mesh down so wee see it in perspective
        meshNode.position.y = -3.0

        scene.rootNode.addChildNode(meshNode)
        
        sceneRenderer.scene = scene
    }
    
    func highlightNodes(atPoint point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        for result in hitResults {
            // get its material
            guard let material = result.node.geometry?.firstMaterial else {
                return
            }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = SCNColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = SCNColor.red
            
            SCNTransaction.commit()
        }
    }
    
    nonisolated func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Called before each frame is rendered on the SCNSceneRenderer thread
    }

}
