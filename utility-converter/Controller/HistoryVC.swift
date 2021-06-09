//
//  HistoryViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

class HistoryVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var histories = [History]()
    var conversionType = WEIGHTS_USER_DEFAULTS_KEY
    var icon: UIImage = #imageLiteral(resourceName: "weight")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generateHistory(type: conversionType, icon: icon)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    @IBAction func handleSegmentControlIndexChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            conversionType = WEIGHTS_USER_DEFAULTS_KEY
            icon = #imageLiteral(resourceName: "weight")
        case 1:
            conversionType = TEMP_USER_DEFAULTS_KEY
            icon = #imageLiteral(resourceName: "temperature1")
        case 2:
            conversionType = VOLUME_USER_DEFAULTS_KEY
            icon = #imageLiteral(resourceName: "volume")
        case 3:
            conversionType = SPEED_USER_DEFAULTS_KEY
            icon = #imageLiteral(resourceName: "speed1")
        case 4:
            conversionType = DISTANCE_USER_DEFAULTS_KEY
            icon = #imageLiteral(resourceName: "distance")
        default:
            break
        }
        generateHistory(type: conversionType, icon: icon)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func generateHistory(type: String, icon: UIImage) {
        histories = []
        let historyList = UserDefaults.standard.value(forKey: conversionType) as? [String]
        
        if historyList?.count ?? 0 > 0 {
            for conersion in historyList! {
                let history = History(type: type,icon: icon,conversion: conersion)
                histories += [history]
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if histories.count == 0 {
            self.tableView.setEmptyMessage("No saved conversions found", UIColor.white)
        } else {
            self.tableView.restore()
        }
        
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        cell.historyConversionText.text = histories[indexPath.row].getHistoryConversion()
        cell.historyTypeIcon.image = histories[indexPath.row].getHistoryIcon()
      
        cell.isUserInteractionEnabled = false
        cell.contentView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
 

}
