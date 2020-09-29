//
//  ViewController.swift
//  EurekaTwolineSliderRow
//
//  Created by rinsuki on 09/29/2020.
//  Copyright (c) 2020 rinsuki. All rights reserved.
//

import UIKit
import Eureka
import EurekaTwolineSliderRow

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        form.append(Section() { section in
            section.append(TwolineSliderRow() {
                $0.title = "TwolineSliderRow"
                $0.value = 0
            })
            section.append(SliderRow() {
                $0.title = "Eureka.SliderRow"
                $0.value = 0
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

