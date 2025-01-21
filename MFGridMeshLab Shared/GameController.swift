//
//  GameController.swift
//  MFGridMeshLab Shared
//
//  Created by Tristan Leblanc on 19/01/2025.
//

import SceneKit
import MFFoundation
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
        
        let grid = MFGrid(gridSize: 150, cellSize: 0.8)
        
        // 2 - There we define a height function.
        //
        // It basically makes a linear clif with a bit of variation
        // So in one case a height with a bit of random is returned,
        // in the other case, we are at sea level, with a bit of random two to give a bit of waves effect
        
        let heightBlock: MFSCNHeightComputeBlock = { _, loc, locp in
            if (loc.h < Int(Double.random(3)) + loc.v / 2) {
                return 4.0 + Double.random(1.2)
            }
            return Double.random(0.25)
        }
        
        // 3 - We define a color compute function to set a color per vertice
        //
        // We choose blue if the level is 0, else we use a mixed red/green color

        let colorBlock: MFSCNColorComputeBlock = { value, gridLoc, location, vertice in
                        
            if vertice.z > 0.2 {
                return SCNVector4(x: vertice.z / 7, y: vertice.z / 3, z: 0, w: 1)
            } else {
                return SCNVector4(x: 0, y: 0, z: 1, w: 1)
            }
        }
        
        // 4 - Create a mesh using the grid

        let meshNode = MFSCNGridMeshNode(grid: grid,
                                         heightComputeBlock: heightBlock,
                                         colorComputeBlock: colorBlock)
        
        // 5 - That's it - Slightly move the mesh down so wee see it in perspective
        
        meshNode.position.y = -3.0
        if let material = meshNode.geometry?.materials.first {
            material.diffuse.contents = SCNMaterialProperty(contents: SCNColor.orange)
            material.isDoubleSided = true
            material.isLitPerPixel = true
        }
        
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
