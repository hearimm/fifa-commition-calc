//
//  ViewController.swift
//  fifa commition calc
//
//  Created by 최혁 on 2017. 3. 24..
//  Copyright © 2017년 Hearimm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var commition: UITextField!
    @IBOutlet weak var discountRate: UITextField!
    @IBOutlet weak var discountCommition: UITextField!
    @IBOutlet weak var receivedAmount: UITextField!
    
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var discountRateSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func discountRateSegmentChanged(segment: UISegmentedControl) {
        let discountRateArr = [0,0.3,0.4,0.5,0]
    
        discountRate.value(forKey: discountRateArr[segment.selectedSegmentIndex].description)
    }
    
    
    @IBAction func priceValueChanged(_ sender: UITextField) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

