//
//  ViewController.swift
//  fifa commition calc
//
//  Created by 최혁 on 2017. 3. 24..
//  Copyright © 2017년 Hearimm. All rights reserved.
//

import Firebase
import GoogleMobileAds
import UIKit


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
    @IBOutlet weak var couponSegment: UISegmentedControl!
    
    @IBOutlet var segmetCollection: [UISegmentedControl]!
    var interstitial: GADInterstitial!
    var doCalcCnt:Int = 0;
    let DEV_STATE = "LIVE"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if DEV_STATE == "DEV"{
            return
        }else{
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            bannerView.adUnitID = "ca-app-pub-8793713887337890/4356369960"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        
            createAndLoadInterstitial()
        }
    }
    
    fileprivate func createAndLoadInterstitial() {
        if DEV_STATE == "DEV"{
            return
        }else{
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-8793713887337890/8646968768")
            let request = GADRequest()
            // Request test ads on devices you specify. Your test device ID is printed to the console when
            // an ad request is made.
            // request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
            interstitial.load(request)
        }
    }
    func presentInterstitial() {
        if DEV_STATE == "DEV"{
            return
        }
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        // Give user the option to start the next game.
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
        discountRateSegmentChanged()//할인율 세그먼트, 쿠폰세그먼트 변경시, 할인율 값 입력 함수
        let idx = segment.selectedSegmentIndex
        
        if idx == 4 { //할인율 직접입력 시, enable
            discountRateTxt.isEnabled = true
            discountRateTxt.text = String(0)
        }else{
            discountRateTxt.isEnabled = false
        }
    }
    @IBAction func couponRateSegmentChanged(_ sender: UISegmentedControl) {
        discountRateSegmentChanged()//할인율 세그먼트, 쿠폰세그먼트 변경시, 할인율 값 입력 함수
    }
    
    //할인율 세그먼트, 쿠폰세그먼트 변경시, 할인율 값 입력 함수
    func discountRateSegmentChanged(){
        let discountRateArr = [0,30,40,50,0] //할인율 상수
        let couponArr = [0,10,20,30,50] //쿠폰 상수
        //할인율 세그먼트
        let discountRateIdx = discountRateSegment.selectedSegmentIndex
        let discountRateVal = discountRateArr[discountRateIdx] //tostring
        //쿠폰 세그먼트
        let couponIdx = couponSegment.selectedSegmentIndex
        let couponVal = couponArr[couponIdx] //tostring
        discountRateTxt.text = String(discountRateVal + couponVal)//할인율 텍스트필드 입력
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
    
    //호출용 계산 로직
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
        
        commitionTxt.text = decimalFormatter(largeNumber: defaultCommition)
        discountCommitionTxt.text = decimalFormatter(largeNumber: discountCommition)
        receivedAmountTxt.text = decimalFormatter(largeNumber: receviedAmount)
        doCalcCnt = doCalcCnt+1
        if doCalcCnt % 20 == 0{
            presentInterstitial()
            createAndLoadInterstitial()
        }
    }
    
    //콤마 표시 변경하기
    func decimalFormatter(largeNumber: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: largeNumber))!
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

