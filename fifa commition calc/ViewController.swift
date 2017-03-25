//
//  ViewController.swift
//  fifa commition calc
//
//  Created by 최혁 on 2017. 3. 24..
//  Copyright © 2017년 Hearimm. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var commitionTxt: UITextField!
    @IBOutlet weak var discountRateTxt: UITextField!
    @IBOutlet weak var discountCommitionTxt: UITextField!
    @IBOutlet weak var receivedAmountTxt: UITextField!
    
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var discountRateSegment: UISegmentedControl!
    
    @IBOutlet var segmetCollection: [UISegmentedControl]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-8793713887337890/4356369960"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    //키보드 외부 터치시 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        priceTxt.resignFirstResponder()
        discountRateTxt.resignFirstResponder()
    }
    
    @IBAction func priceTxtEditingChanged(_ sender: UITextField) {
        checkMaxLength(textField: sender, maxLength: 11)
    }
    @IBAction func discountRateTxtEditingChanged(_ sender: UITextField) {
        if let rateStr = sender.text
           ,let rateDouble = Double(rateStr)
            ,rateDouble > 100{
            sender.deleteBackward()
        }
        checkMaxLength(textField: sender, maxLength: 4)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.characters.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    //할인율 세그먼트 변경시 이벤트
    @IBAction func discountRateSegmentChanged(_ segment: UISegmentedControl) {
        
        let discountRateArr = [0,30,40,50,0] //할인율 상수
        let idx = segment.selectedSegmentIndex
        let val = discountRateArr[idx].description //tostring
        discountRateTxt.text = val //할인율 텍스트필드 입력
        
        if idx == 4 { //할인율 직접입력 시, enable
            discountRateTxt.isEnabled = true
        }else{
            discountRateTxt.isEnabled = false
        }
    }
    
    
    
    @IBAction func calcButtonTouchDown(_ sender: UIButton) {
        doCalc()
    }
    @IBAction func txtDoCalc(_ txt:UITextField){
        doCalc()
    }
    @IBAction func segmentDoCalc(_ segment: UISegmentedControl){
        doCalc()
    }
    
    func doCalc() {
        
        if let priceString = priceTxt.text,
            let price = Double(priceString),
            let unit = getUnitVal(idx: unitSegment.selectedSegmentIndex),
            let discountRateString = discountRateTxt.text ,
            let discountRate = Double(discountRateString){
                calc(price: price,unit: unit,discountRate: discountRate)
        }
        
        
    }
    
    func getUnitVal(idx : Int) -> Double? {
        
        switch idx {
        case 0:
            return 100000000
        case 1:
            
            return 1000000
        case 2:
            return 10000
        case 3:
            return 1
        default:
            return nil
        }
    }
    
    func calc(price: Double, unit: Double , discountRate: Double) {
        let priceVal = price * unit
        var defaultCommition = 0.0
        if priceVal < 1000 {
            //alert('1000 ep이상 입력해주세요')
        }
        if priceVal > 500000 {
            defaultCommition = 150000.0 + (priceVal - 500000.0) * 0.4
        }else{
            defaultCommition = priceVal * 0.3
        }
        
        let discountCommition = defaultCommition * (discountRate / 100 )
        let receviedAmount = priceVal - (defaultCommition - discountCommition)
        
        commitionTxt.text = Int64(defaultCommition).description
        discountCommitionTxt.text = Int64(discountCommition).description
        receivedAmountTxt.text = Int64(receviedAmount).description
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

