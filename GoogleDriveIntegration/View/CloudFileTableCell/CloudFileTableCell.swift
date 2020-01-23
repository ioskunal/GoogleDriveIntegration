//
//  CloudFileTableCell.swift
//  GoogleDriveIntegration
//
//  Created by Kunal Gupta on 15/01/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import Kingfisher

class CloudFileTableCell: UITableViewCell {

    //MARK:- OUTLETS

    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var documentTitleLabel: UILabel!
    @IBOutlet weak var documentSubtitleLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!

    //MARK:- SELF MADE

    func configureCell(_ file: GTLRDrive_File) {
        
        documentTitleLabel.text = file.name
        documentSubtitleLabel.text = file.name
        documentSubtitleLabel.text = "Modified \(file.modifiedTime?.date.string(format: "MMM dd, yyyy") ?? "N.A")"
        fileSizeLabel.text = ""
        if let size = file.size?.doubleValue.getSize() {
            fileSizeLabel.text = "\(size.toString) MB"
        } else {
            fileSizeLabel.text = ""
        }
        
        if file.hasThumbnail == true {
            documentImageView?.kf.setImage(with: URL(string: file.thumbnailLink!))
        } else {
            documentImageView?.kf.setImage(with: URL(string: file.iconLink!))
        }
    }
    
}

extension Double {
    
    func getSize() -> Double {
           var fileSize = self/1048576 //Convert in to MB
           fileSize = (fileSize*100).rounded()/100
           return fileSize
    }

    public var toString: String { return String(self) }

}

extension Date {
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "format.rawValue"
        return formatter.string(from: self)
    }
}
