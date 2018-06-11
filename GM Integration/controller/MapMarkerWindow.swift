//
//  MapMarkerWindow.swift
//  GM Integration
//
//  Created by Shafeer Puthalan on 10/06/18.
//  Copyright © 2018 Shafeer Puthalan. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapDirectionButton()
}

class MapMarkerWindow: UIView {

   
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var directionButton: UIButton!
    
    weak var delegate: MapMarkerDelegate?
    
    @IBAction func showDirection(_ sender: Any) {
        delegate?.didTapDirectionButton()
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
