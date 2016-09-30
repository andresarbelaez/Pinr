//
//  CustomInfoWindow.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/29/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventPictureView: UIImageView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        eventPictureView.layer.cornerRadius = eventPictureView.frame.size.width / 2
        eventPictureView.clipsToBounds = true
    }
    

}
