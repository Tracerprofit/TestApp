//
//  ContactsViewController.swift
//  LegeartApp
//
//  Created by PRGR on 31.01.2022.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var SControl: UISegmentedControl!
    @IBOutlet weak var tableViewContacts: UITableView!
    
    let clients = ["Ольга Эковент", "ДФЗ Владимир Александрович", "Галелит Евгений", "Галелит Евгений"]
    let stuff = ["Денис Бураков", "Максим Каптановский", "Андрей Алексеев", "Анна Бичерова"]
    var twoTables = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        SetupSControl()
        tableViewContacts.delegate = self
        tableViewContacts.dataSource = self
        
        tableViewContacts.tableFooterView = UIView()
        tableViewContacts.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        tableViewContacts.layer.cornerRadius = 10
        tableViewContacts.backgroundColor = .white
        
        let nib = UINib(nibName: "ContactsViewCell", bundle: nil)
        tableViewContacts.register(nib, forCellReuseIdentifier: "ContactsViewCell")
        
        
        
    }
    @IBAction func segmentChanged(_ sender: Any) {
        tableViewContacts.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SControl.selectedSegmentIndex {
        case 0:
            twoTables = true
            return clients.count
        case 1:
            twoTables = false
            return stuff.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewContacts.dequeueReusableCell(withIdentifier: "ContactsViewCell", for: indexPath) as! ContactsViewCell
        cell.CellImageView.image = UIImage(named: "Ellipse")
        cell.labelDicr.textColor = UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00)
        cell.labelDicr.textAlignment = .right
        cell.labelDicr.font = UIFont.systemFont(ofSize: 10)
        
        switch SControl.selectedSegmentIndex {
        case 0:
            cell.labelName.text = clients[indexPath.row]
            cell.labelDicr.text = "Написать"
        case 1:
            cell.labelName.text = stuff[indexPath.row]
            cell.labelDicr.text = "Поставить задачу"
        default:
            break
        }
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewContacts.deselectRow(at: indexPath, animated: true)
        if twoTables == true{
            print("Написать \(clients[indexPath.row])")
        } else{
            print("Поставить задачу \(stuff[indexPath.row])")
        }
        
        
        
    }
    func addViewNavBar(){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Контакты"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        view.addSubview(mainView)
    }
    func SetupSControl(){
        SControl.layer.cornerRadius = 10
        SControl.layer.masksToBounds = false
        SControl.layer.shadowColor = UIColor.black.cgColor
        SControl.layer.shadowOffset = CGSize(width: 3, height: 3);
        SControl.layer.shadowRadius = 5;
        SControl.layer.shadowOpacity = 0.2;
        self.tableViewContacts.reloadData()
        
        
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
}

