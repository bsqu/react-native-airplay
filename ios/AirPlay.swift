import Foundation
import MediaPlayer

@objc(RCTAirPlay)
class RCTAirPlay: RCTEventEmitter {

  @objc func startScan() -> Void {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(RCTAirPlay.airplayChanged(sender:)),
                                           name: NSNotification.Name.AVAudioSessionRouteChange,
                                           object: AVAudioSession.sharedInstance())
  }

  func airplayChanged(sender: NSNotification) {
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    var isAirPlayPlaying = false
    for output in currentRoute.outputs {
      if output.portType == AVAudioSessionPortAirPlay {
        print("Airplay Device connected with name: \(output.portName)")
        isAirPlayPlaying = true
        break;
      }
    }

    self.sendEvent(withName: "airplayConnected",
                   body: ["connected": isAirPlayPlaying])
  }

  @objc func isAlreadyConnected(callback: RCTResponseSenderBlock) -> Void {
    let currentRoute = AVAudioSession.sharedInstance().currentRoute
    for output in currentRoute.outputs {
      if output.portType == AVAudioSessionPortAirPlay {
        print("Airplay Device connected with name: \(output.portName)")
        callback([true])
        //return true
      }
    }
    callback([false])
    //return false
  }

  override func supportedEvents() -> [String]! {
    return ["airplayConnected"]
  }

}

@objc(RCTAirPlayButton)
class RCTAirPlayButton: RCTViewManager {
  override func view() -> UIView! {
    let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 66.5, height: 34))
    wrapperView.backgroundColor = UIColor.red
    wrapperView.translatesAutoresizingMaskIntoConstraints = false

    let volumneView = MPVolumeView(frame: wrapperView.bounds)
    volumneView.showsVolumeSlider = false
    wrapperView.addSubview(volumneView)

    volumneView.sizeToFit()

    return wrapperView
  }
}
