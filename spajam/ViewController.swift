//
//  ViewController.swift
//  spajam
//
//  Created by Oshima Haruna on 2018/06/16.
//  Copyright © 2018年 Oshima Haruna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    
    @IBAction func didTapSendButton(_ sender: Any) {
        // 送信ボタンが押された時の処理
        if let message = inputTextField.text, message != "" {
            ConnectionManager.sendMessageEvent(message: message)
            inputTextField.text = ""

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConnectionManager.onConnect{ _, _ in
            print("特定の端末が接続された")
            self.updatePeers()
        }
        
        ConnectionManager.onDisconnect { _, _ in
            print("特定の端末が切断された")
            self.updatePeers()
        }
        
        ConnectionManager.onEvent(.Message) { [unowned self] _, object in
            self.receiveMassage(object: object)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ConnectionManager.onConnect(nil)
        ConnectionManager.onDisconnect(nil)
        
        super.viewWillDisappear(animated)
    }
    
    private func receiveMassage(object: AnyObject?) {
        print("@@recieve")
        guard let data = object else {
            return
        }
        if let message = data["message"] as? String, let from = data["from"] as? String{
            printMessage(message:message, from)
        }
    }
    
    private func printMessage(message: String, _ from: String) {
        logTextView.text = logTextView.text + from + ":" + message + "\n"
    }
    
    private func updatePeers() {
        // TODO: コネクション一覧が更新された場合の処理を実装する
        print(ConnectionManager.peers)
    }
    

}

