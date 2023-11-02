//
//  ActionSheetVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 23/02/22.
//

import UIKit

class ActionSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var countryList = [countryStruct]()
    var filteredList = [countryStruct]()
    
    var isFrom = ""
    var completionHandlerCallback:((NSDictionary?) ->Void)?
    var dispatchWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.countryList.count > 0 {
            self.listTableView.isHidden = false
            self.emptyView.isHidden = true
        } else {
            self.listTableView.isHidden = true
            self.emptyView.isHidden = false
        }
        
        self.searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFrom == "Search" {
            return self.filteredList.count
        } else {
            return self.countryList.count
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionSheetCell", for: indexPath) as! ActionSheetCell
        var countryListObj = countryStruct()
        if self.isFrom == "Search" {
            countryListObj = self.filteredList[indexPath.row]
            cell.cellLbl.text = countryListObj.title
        } else {
            countryListObj = self.countryList[indexPath.row]
            cell.cellLbl.text = countryListObj.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedObjDic = NSMutableDictionary()
        
        if self.isFrom == "Search" {
            selectedObjDic.setValue(self.filteredList[indexPath.row].title, forKey: "title")
            selectedObjDic.setValue(Int(self.filteredList[indexPath.row].id), forKey: "id")
        } else {
            selectedObjDic.setValue(self.countryList[indexPath.row].title, forKey: "title")
            selectedObjDic.setValue(Int(self.countryList[indexPath.row].id), forKey: "id")
        }
        if self.completionHandlerCallback != nil {
            self.completionHandlerCallback!(selectedObjDic)
        }
        self.dismiss(animated: true)
    }

}

extension ActionSheetVC: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            dispatchWorkItem?.cancel()
//            let totalChar = searchBar.text!.count
            let productSearchWorkItem = DispatchWorkItem{
                if searchText.count > 0{
                    self.isFrom = "Search"
                    self.filteredList = self.countryList.filter({ $0.title.hasPrefix(searchText) })
                }else if searchText.count == 0{
                    self.isFrom = ""
                    self.searchBar.endEditing(true)
                    
                    
                }
                self.listTableView.reloadData()
            }
            
            dispatchWorkItem = productSearchWorkItem
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: productSearchWorkItem)
            
        }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        return !shouldKeyboardOpen
//    }
//
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        shouldKeyboardOpen = false
//        self.searchBar.endEditing(true)
//        shouldKeyboardOpen = true
//    }
     
}
