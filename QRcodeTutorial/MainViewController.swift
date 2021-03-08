//
//  ViewController.swift
//  QRcodeTutorial
//
//  Created by 김송현 on 2021/03/05.
//

import UIKit
import WebKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var qrcodeBtn: UIButton!
    
    // qr코드 리더 뷰컨트롤러를 만든다
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    //MARK: - 오버라이드 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL (string: "https://m.naver.com")
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
        qrcodeBtn.layer.borderWidth = 3
        qrcodeBtn.layer.borderColor = UIColor.blue.cgColor
        qrcodeBtn.layer.cornerRadius = 10
        qrcodeBtn.addTarget(self, action: #selector(qrcodeLaunch), for: .touchUpInside)
    
    }
    
    //MARK: - fileprivate 메소드
    @objc fileprivate func qrcodeLaunch()
    {
        print("MainViewController - qrcodeLaunch() called")
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
            
            guard let scannedUrlString = result?.value
            else{ return }
            print("scannedUrlString = \(scannedUrlString)")
            let scannedUrl = URL(string: scannedUrlString)
            self.webView.load(URLRequest(url: scannedUrl!))
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        
        // 설정된 뷰 컨트롤러를 화면에 보여줌
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - qrcode리더 델리게이트 메소드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}

