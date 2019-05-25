//
//  ViewController.swift
//  EyeSliderView
//
//  Created by Furkan Kaynar on 25.05.2019.
//  Copyright © 2019 furrki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var sliderView: EyeSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderView.delegate = self
        minValueLabel.text = "\(sliderView.minimumValue)"
        maxValueLabel.text = "\(sliderView.maximumValue)"
    }
}

extension ViewController: EyeSliderDelegate {
    func eyeSlider(_ eyeSliderView: EyeSliderView, didValueChange value: Float) {
        currentValueLabel.text = "\(sliderView.value)"
    }
}
