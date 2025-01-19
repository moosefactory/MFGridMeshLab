# MFGridMeshLab

A demo app that demonstrates the **MFGridMeshNode** object, based on the Apple **SceneKit** sample.

**MFSCNGridNode** is defined in the **MFSCNExtensions** package.

<https://github.com/moosefactory/MFSCNExtensions>

The code is slightly modified to insert a mesh under the rotating plane.

```

// Add a mesh node ( must import MFSCNExtension and MFGridUtils )

// 1 - Create a grid object
let grid = MFGrid(gridSize: 40, cellSize: 2)

// 2 - Create a mesh using the grid
let meshNode = MFSCNGridMeshNode(grid: grid)

// 3 - Slightly move the mesh down so wee see it in perspective
meshNode.position.y = -3.0

sceneRenderer.scene = scene

```

Build and run.

![MeshLabScreenshot Image](MeshLabScreenshot.jpg)

--

*©2024 Moose Factory Software*
