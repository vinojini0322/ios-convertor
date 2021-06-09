//
//  FirstViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

class ConvertionsVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var conversionTV: UITableView! {
        didSet {
            conversionTV.dataSource = self
            conversionTV.delegate = self
        }
    }
    var conversions = [Conversion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateConversions()
    }
    
    func generateConversions() {
        let weight = Conversion(name: "Weight", icon: #imageLiteral(resourceName: "weight"), segueID: "openWeight", cellColour: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00))
        let temperature = Conversion(name: "Tempertaure", icon: #imageLiteral(resourceName: "temperature1"), segueID: "openTemperature", cellColour: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00))
        let volume = Conversion(name: "Volume", icon: #imageLiteral(resourceName: "volume"), segueID: "openVolume", cellColour: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00))
        let distance = Conversion(name: "Distance", icon: #imageLiteral(resourceName: "distance"), segueID: "openDistance", cellColour: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00))
        let speed = Conversion(name: "Speed", icon: #imageLiteral(resourceName: "speed1"), segueID: "openSpeed", cellColour: UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00))
        
        conversions += [weight, temperature, volume, distance, speed]
        self.conversionTV.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionTableViewCell", for: indexPath) as! ConversionsTableViewCell
        cell.conversionsLbl.text = conversions[indexPath.row].getConversionName()
        cell.conversionsIV.image = conversions[indexPath.row].getConversionIcon()
        
        cell.contentView.backgroundColor = conversions[indexPath.row].getCellColour()
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: conversions[indexPath.row].getSegueID(), sender: self)
    }
}

