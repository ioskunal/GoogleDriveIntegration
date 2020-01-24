//
//  CloudFilesVC.swift
//  GoogleDriveIntegration
//
//  Created by Kunal Gupta on 15/01/20.
//  Copyright © 2020 Kunal Gupta. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import SVPullToRefresh

class CloudFilesVC: UIViewController {

    @IBOutlet weak var tableViewFiles: UITableView!
    
    //MARK:- VARIABLES
    
    internal var arrFiles = [GTLRDrive_File]()
    internal let service = GTLRDriveService()
    internal var searchText = ""
    internal var token: String?

    //MARK:- PREDEFINED
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    private func initialise() {
        let nib = UINib(nibName: "CloudFileTableCell", bundle: nil)
        tableViewFiles.register(nib, forCellReuseIdentifier: "CloudFileTableCell")
        tableViewFiles.addInfiniteScrolling {
            self.tableViewFiles.showsPullToRefresh = false
            self.fetchFromDrive()
        }
        fetchFromDrive()
    }
    
    func fetchFromDrive() {
        let drive = CloudFilesManager(service)
        drive.listAllFiles(searchText, token: token) { [weak self] (files, pageToken, error) in
            if let arrFiles = files {
                pageToken != nil ? (self?.arrFiles += arrFiles) :  (self?.arrFiles = arrFiles)
                self?.token = pageToken
                self?.tableViewFiles.reloadData()
            } else {
                Alert.show(message: error?.localizedDescription ?? "")
            }
            self?.tableViewFiles.showsInfiniteScrolling = self?.token == nil ? false : true // disable infinite scrolling if the limit has been reached
            self?.tableViewFiles.infiniteScrollingView.stopAnimating()
        }
    }

}

extension CloudFilesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrFiles.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "CloudFileTableCell") as? CloudFileTableCell else { return UITableViewCell()}
         cell.configureCell(arrFiles[indexPath.row])
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print(arrFiles[indexPath.row])
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80
     }
    
}
