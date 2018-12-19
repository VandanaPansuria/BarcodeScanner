//
//  BardCodeDetailViewController.swift
//  IDMScan
//
//  Created by Administrator on 20/06/18.
//  Copyright © 2018 TMFC. All rights reserved.
//

import UIKit
class DetailCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
}
class BardCodeDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var aTableView: UITableView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    // MARK: - Variables
    var arrName  = [NSLocalizedString("NAME", comment: ""),NSLocalizedString("DATE OF BIRTH", comment: ""),NSLocalizedString("ISSUE DATE", comment: ""),NSLocalizedString("EXPIRE DATE", comment: ""),NSLocalizedString("COUNTRY", comment: ""),NSLocalizedString("LICENCE NO.", comment: ""),NSLocalizedString("ADDRESS", comment: "")]
    
    // MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        pagecontrol.transform = CGAffineTransform(scaleX: 1.4, y: 1.4);
        aTableView.tableFooterView = UIView()
        aTableView.rowHeight = UITableView.automaticDimension
        self.aTableView.estimatedRowHeight = 200.0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        pagecontrol.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }
    }
    //MARK:- Next Tap method
    @IBAction func btnNextTap(_ sender: Any) {
        
        arrbarcodedetail.removeAll()
        URLCache.shared.removeAllCachedResponses()
        dictQRdetail.removeAll()
        let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = testController
      
    }
   
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        cell.lblTitle.text = self.arrName[indexPath.row]
        if arrbarcodedetail.count > 0{
            cell.lblValue.text = arrbarcodedetail[indexPath.row]
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
