/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
  
  // MARK: - Properties
    
    var trackingStatus: String = ""
  
  // MARK: - Outlets
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var styleButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  
  // MARK: - Actions
  
  @IBAction func startButtonPressed(_ sender: Any) {
  }
  
  @IBAction func styleButtonPressed(_ sender: Any) {
  }
  
  @IBAction func resetButtonPressed(_ sender: Any) {
  }
  
  // MARK: - View Management
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initSceneView()
    initScene()
    initARSession()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("*** ViewWillAppear()")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("*** ViewWillDisappear()")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("*** DidReceiveMemoryWarning()")
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Initialization
  
  func initSceneView() {
    sceneView.delegate = self
    sceneView.showsStatistics = true
  }
  
  func initScene() {
    let scene = SCNScene(named: "PokerDice.scnassets/SimpleScene.scn")!
    scene.isPaused = false
    sceneView.scene = scene
  }
  
  func initARSession() {
    guard ARWorldTrackingConfiguration.isSupported else {
        print("****** AR Config: AR World Tracking not supported")
        return
    }
    let config = ARWorldTrackingConfiguration()
    config.worldAlignment = .gravity
    config.providesAudioData = false
    sceneView.session.run(config)
  }
}

extension ViewController : ARSCNViewDelegate {
  
  // MARK: - SceneKit Management
    
    func renderer(_ renderer: SCNSceneRenderer,
                     updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.statusLabel.text = self.trackingStatus
        }
    }
    
  // MARK: - Session State Management
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            //“The AR session is unable to track due to unforeseen reasons. There’s nothing much you can do in this condition but to hope that the state changes to something more manageable.”
            trackingStatus = "Tracking: Not available"
        case .normal:
            trackingStatus = "Tracking: All good!"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                trackingStatus = "Tracking limited due to excessive motion"
            case .insufficientFeatures:
                trackingStatus = "Tracking: limited due to insufficient features"
            case .initializing:
                trackingStatus = "Tracking: Initializing..."
            case .relocalizing:
                trackingStatus = "Tracking: Relocalizing..."
            }
        }
    }
  
  // MARK: - Session Error Managent
    
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("session error management")
        trackingStatus = "AR Session Failure: \(error)"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("session error management")
        trackingStatus = "AR Session was interrupted"
    }
  
  // MARK: - Plane Management
  
}

