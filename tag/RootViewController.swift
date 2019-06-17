//
//  ViewController.swift
//  tag
//
//  Created by Yoseph Wijaya on 2019/06/16.
//  Copyright © 2019 curcifer. All rights reserved.
//

import UIKit
import CoreNFC

class RootViewController: UIViewController {
  var session:NFCNDEFReaderSession?
  
  @IBOutlet weak var scanMeButton: UIButton!
  @IBOutlet weak var detectionInfoLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func tapScanMe(_ sender: UIButton) {
    guard session == nil else { return }
    session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
    session?.alertMessage = "Put the device near tag"
    session?.begin()
  }
  
}

extension RootViewController:NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    if let readerError = error as? NFCReaderError {
      // Show an alert when the invalidation reason is not because of a success read
      // during a single tag read mode, or user canceled a multi-tag read mode session
      // from the UI or programmatically using the invalidate method call.
      if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
        && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
        let alertController = UIAlertController(
          title: "Session Invalidated",
          message: error.localizedDescription,
          preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
          self.present(alertController, animated: true, completion: nil)
        }
      }
    }
    self.session = nil
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    detectionInfoLabel.text = "messages \(messages)"
    self.session = nil
  }
  
  
}


