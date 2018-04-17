//
//  ProfileViewController.swift
//  OpenTalk
//
//  Created by SUBRAT on 4/16/18.
//  Copyright © 2018 Open Talk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import RKPieChart
import CoreLocation

class ProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var EduTableView: UITableView!
    @IBOutlet var groupTableView: UITableView!
    @IBOutlet var circelHeader: UIView!
    @IBOutlet var mapWebView: UIWebView!
    
    
    @IBOutlet var piCharView: UIView!
    
    @IBOutlet var englishPieChartView: UIView!
    @IBOutlet var enlgishTalkLabel: UILabel!
    
    
    @IBOutlet var mapLabel: UILabel!
    @IBOutlet var personalityLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var noOfThumpsUp: UILabel!
    @IBOutlet var noOfLevel: UILabel!
    @IBOutlet var profImage: UIImageView!
    @IBOutlet var opentalkID: UILabel!
    @IBOutlet var displayLocation: UILabel!
    @IBOutlet var backViewDropDown: UIView!
    
    @IBOutlet var noOfOpenTalks: UILabel!
    @IBOutlet var minutsOfOpenTalk: UILabel!
    @IBOutlet var OneMinutCalls: UILabel!
    @IBOutlet var fiveMinutCalls: UILabel!
    @IBOutlet var creditsInAccounts: UILabel!
    @IBOutlet var buyMoreCreditButnOutlet: UIButton!
    
    var listofEducations: Array<Education>?
    var listofGroups: Array<Groups>?
    let locationManager = CLLocationManager()
    
    
    var countriesinEurope = ["France","Spain","Germany"]
    var countriesinAsia = ["Japan","China","India"]
    var countriesInSouthAmerica = ["Argentia","Brasil","Chile"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        EduTableView.delegate = self
        EduTableView.dataSource = self
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        EduTableView.tag = 101
        groupTableView.tag = 102
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callNetwork { (dt) in
            if let jsonString = dt as? String {
                let profileDt  = Mapper<Profile>().map(JSONString: jsonString)
                self.updateDetail(profile: profileDt)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    } 
    
    @IBAction func getCurrentLocClicked(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateDetail(profile: Profile?){
        if let pf = profile{
            nameLbl.text = pf.name
            noOfLevel.text = String(pf.level)
            profImage.imageFromServerURL(urlString: pf.profile_pic)
            profImage.clipsToBounds = true
            backViewDropDown.layer.cornerRadius = 10
            backViewDropDown.layer.borderWidth = 1
            backViewDropDown.layer.borderColor = UIColor.white.cgColor
            buyMoreCreditButnOutlet.layer.shadowOpacity = 0.8
            buyMoreCreditButnOutlet.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            displayLocation.text = pf.display_location
            opentalkID.text = pf.opentalk_id_url
            listofEducations = pf.education
            if let mapDt = pf.map_data {
                mapLabel.text = "\(pf.name) has talked to people from \(String(describing: mapDt.country_count)) contries on Opentalk"
                let encoded = mapDt.geo_chart
                let decoded = encoded.stringByDecodingHTMLEntities
                mapWebView.loadHTMLString(decoded,baseURL: nil)
            }
            self.createPieChart(comp: pf.compliments, fromWhich: "complimet")
            personalityLbl.text = "\(pf.name) personality on opentalk"
            enlgishTalkLabel.text = "\(pf.name) is rated 7/10 on English communication on Opentalk"
            creditsInAccounts.text = String(pf.total_gems)
             self.createPieChart(comp: pf.compliments, fromWhich: "English")
            EduTableView.reloadData()
            listofGroups = pf.groups
            groupTableView.reloadData()
            
            if let userActivity = pf.user_activity_analysis{
                noOfOpenTalks.text = String(userActivity.total_call)
                minutsOfOpenTalk.text = String(userActivity.minutes_of_call)
                fiveMinutCalls.text = String(userActivity.minutes_5_of_call)
                OneMinutCalls.text = String(userActivity.minutes_1_of_call)
                noOfThumpsUp.text = String(userActivity.thumb_up)
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func createPieChart(comp: Array<Compliments>?, fromWhich: String){
        var items = [RKPieChartItem]()
        if fromWhich == "English"{
            let firstItem: RKPieChartItem = RKPieChartItem(ratio: uint(70), color: hexStringToUIColor(hex: "#0086AE"), title: "")
            let secondItem: RKPieChartItem = RKPieChartItem(ratio: uint(30), color: hexStringToUIColor(hex: "#2DA8FF"), title: "")
            items.append(firstItem)
            items.append(secondItem)
        }else{
            
            comp?.forEach({ (com) in
                let firstItem: RKPieChartItem = RKPieChartItem(ratio: uint(com.rating_count), color: hexStringToUIColor(hex: com.color), title: com.rating_text)
                items.append(firstItem)
            })
            
        }
        
        if fromWhich == "English"{
            let chartView = RKPieChartView(items: items, centerTitle: "7/10 GOOD")
            chartView.circleColor = .clear
            chartView.translatesAutoresizingMaskIntoConstraints = false
            chartView.isIntensityActivated = false
            chartView.style = .butt
            chartView.arcWidth = 30
            chartView.isTitleViewHidden = true
            englishPieChartView.addSubview(chartView)
            chartView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            chartView.centerXAnchor.constraint(equalTo: self.englishPieChartView.centerXAnchor).isActive = true
            chartView.centerYAnchor.constraint(equalTo: self.englishPieChartView.centerYAnchor).isActive = true
        }else{
            let chartView = RKPieChartView(items: items, centerTitle: "")
            chartView.circleColor = .clear
            chartView.translatesAutoresizingMaskIntoConstraints = false
            chartView.isIntensityActivated = false
            chartView.style = .butt
            chartView.arcWidth = 50
            chartView.isTitleViewHidden = false
            piCharView.addSubview(chartView)
            chartView.widthAnchor.constraint(equalToConstant: 320).isActive = true
            chartView.heightAnchor.constraint(equalToConstant: 320).isActive = true
            chartView.centerXAnchor.constraint(equalTo: self.piCharView.centerXAnchor).isActive = true
            chartView.centerYAnchor.constraint(equalTo: self.piCharView.centerYAnchor).isActive = true
        }
        
    }
    
    
    func callNetwork(completionHandler: @escaping (Any?)->()){
        ViewUtils.addActivityView(view: self.view)
        Alamofire.request("https://opentalk.to/api/rahulj00", method: .get, parameters: [:], encoding: URLEncoding.default, headers: nil)
            .responseString { response in
            }
            .responseJSON { response in
                ViewUtils.removeActivityView(view: self.view)
                if let data = response.result.value{
                    let json = JSON(data)
                    if let code = json["code"].rawString(){
                        if(code == "200"){
                            let data = json["data"]
                            if let prf = data["profile"].rawString() {
                                completionHandler(prf)
                            }
                        }
                    }
                }
        }
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 102{
            if let cnt = self.listofGroups?.count{
                return cnt
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101{
            if let cnt = self.listofEducations?.count{
                return cnt
            }
        }else if tableView.tag == 102{
            if let cnt = self.listofGroups?.count{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 101{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EducationCell", for: indexPath) as! EducationCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if let edu = self.listofEducations?[indexPath.row]{
                cell.nameLbl.text = edu.institute_name
                cell.addressLbl.text  = edu.location
            }
            return cell
        }else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderCellTableViewCell", for: indexPath) as! CustomHeaderCellTableViewCell
            
            // Need to check
            let sect = indexPath.section
            if let count = self.listofGroups?.count {
                for i in sect ..< count{
                    if let grp = self.listofGroups?[i]{
                    var txt = ""
                    let tgs = grp.tags
                        tgs?.forEach({ (tg) in
                            txt += tg.tag_name + ","
                        })
                        cell2.textLabel?.numberOfLines = 0
                        cell2.textLabel?.text = txt
                    }
                }
            }
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 102{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
            headerCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            headerCell.textLabel?.sizeToFit()
//            headerCell.textLabel?.backgroundColor = UIColor(displayP3Red: 154, green: 154, blue: 154, alpha: 20)
            if let grp = self.listofGroups?[section]{
                headerCell.textLabel?.text = grp.group_name
            }
            return headerCell
        }else{
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.tag == 102{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            footerView.backgroundColor = UIColor.white
            return footerView
        }else{
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
}

class EducationCell: UITableViewCell{
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    
}

class GroupCell: UITableViewCell{
    
}


// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}

