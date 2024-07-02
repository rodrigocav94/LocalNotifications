//
//  ButtonCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 02/07/24.
//

import UIKit

class SegmentedCell: UITableViewCell {

    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        segmentedControl.setTitle("Date", forSegmentAt: 0)
        segmentedControl.setTitle("Interval", forSegmentAt: 1)
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        
    }
}
