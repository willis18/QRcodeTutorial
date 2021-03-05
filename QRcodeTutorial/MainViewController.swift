//
//  ViewController.swift
//  QRcodeTutorial
//
//  Created by 김송현 on 2021/03/05.
//

import UIKit
import WebKit

class MainViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL (string: "https://m.naver.com")
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }


}

