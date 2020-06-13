//
//  ViewController.swift
//  Demo_PayU
//
//  Created by Saurabh Sharma on 11/06/20.
//  Copyright © 2020 saurabh. All rights reserved.
//

import UIKit
import PlugNPlay
import CommonCrypto

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonPayU: UIButton!
    
    @IBAction func PayUAction(_ sender: Any) {
        continueWithCardPayment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    func continueWithCardPayment()

    {
        let paymentParam = PUMTxnParam()
        
            paymentParam.key = "WSBz0Dtn" //"your merhcant key"
            paymentParam.merchantid = "7114012" //" merchant id"
            paymentParam.txnID = "xyz123"
            paymentParam.phone = "9711349774"
            paymentParam.amount = "1"
            paymentParam.productInfo = "Nokia"
            paymentParam.surl = "https://test.payumoney.com/mobileapp/payumoney/success.php"
            paymentParam.furl = "https://test.payumoney.com/mobileapp/payumoney/failure.php"
            paymentParam.firstname = "saurabh"
            paymentParam.email = "saurabh.sharma@birdapps.in"
            paymentParam.environment = PUMEnvironment.production
            paymentParam.udf1 = "udf1"
            paymentParam.udf2 = "udf2"
            paymentParam.udf3 = "udf3"
            paymentParam.udf4 = "udf4"
            paymentParam.udf5 = "udf5"
            paymentParam.udf6 = ""
            paymentParam.udf7 = ""
            paymentParam.udf8 = ""
            paymentParam.udf9 = ""
            paymentParam.udf10 = ""
            paymentParam.hashValue = self.getHashForPaymentParams(paymentParam)
           // paymentParam.offerKey = ""              // Set this property if you want to give offer:
           // paymentParam.userCredentials = ""



                PlugNPlay.presentPaymentViewController(withTxnParams: paymentParam, on: self, withCompletionBlock: { paymentResponse, error, extraParam in
                    if error != nil {
                        UIUtility.toastMessage(onScreen: error?.localizedDescription, from: self)
                    } else {
                        var message = ""
                        if paymentResponse?["result"] != nil && (paymentResponse?["result"] is [AnyHashable : Any]) {
                            print(paymentResponse!)
                            message = "Hello Asad sucess"
                            //                    message = paymentResponse?["result"]?["error_Message"] as? String ?? ""
                            //                    if message.isEqual(NSNull()) || message.count == 0 || (message == "No Error") {
                            //                        message = paymentResponse?["result"]?["status"] as? String ?? ""
                            //                    }
                        } else {
                            message = paymentResponse?["status"] as? String ?? ""
                        }
                        UIUtility.toastMessage(onScreen: message, from: self)
                    }
                })

            //PlugNPlay.presentPaymentViewController(withTxnParams: paymentParam, on: self, withCompletionBlock: )
        }
    
    
    func sha512(_ str: String) -> String {

        let data = str.data(using:.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    func getHashForPaymentParams(_ txnParam: PUMTxnParam?) -> String? {
        let salt = "7BPeKEmjQL"
        var hashSequence: String? = nil
        if let key = txnParam?.key, let txnID = txnParam?.txnID, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstname, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5, let udf6 = txnParam?.udf6, let udf7 = txnParam?.udf7, let udf8 = txnParam?.udf8, let udf9 = txnParam?.udf9, let udf10 = txnParam?.udf10 {
            hashSequence = "\(key)|\(txnID)|\(amount)|\(productInfo)|\(firstname)|\(email)|\(udf1)|\(udf2)|\(udf3)|\(udf4)|\(udf5)|\(udf6)|\(udf7)|\(udf8)|\(udf9)|\(udf10)|\(salt)"
        }



        let hash = self.sha512(hashSequence!).description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")

        return hash
    }

}

