//
//  DeleteButtonSubClass.swift
//  kanbanv2
//
//  Created by Ryan on 2018-11-07.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class DeleteButtonSubClass: UIButton {
    
    var passedName:String
    
    required init?(coder aDecoder: NSCoder) {
        // set myValue before super.init is called
        self.passedName = "Testing"
        
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
