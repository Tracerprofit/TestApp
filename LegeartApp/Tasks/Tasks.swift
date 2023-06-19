//
//  Tasks.swift
//  LegeartApp
//
//  Created by PRGR on 28.01.2022.
//

import UIKit
import Firebase

class Tasks: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var logo: UIBarButtonItem!
    @IBOutlet weak var profileLogoButton: UIBarButtonItem!
    @IBOutlet var mainTableView: UITableView!
    
    let database = Database.database().reference()
    let colorsOfTasks = [UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00), UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00), UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)]
    let profilesLogo = [UIImage(named: "Anna")]
    
    var namesTasks = ["Нарисовать страницу покупки электронного билета на сайте dfz.ru", "Нарисовать страницу покупки электронного билета на сайте polkan.ru", "Нарисовать страницу покупки электронного билета на сайте droforez.ru", "Нарисовать страницу покупки электронного билета на сайте wollter.ru", "Нарисовать страницу покупки электронного билета на сайте dowla.ru", "Нарисовать страницу покупки электронного билета на сайте legeart.ru", "Нарисовать страницу покупки электронного билета на сайте pascalABC.ru", "Нарисовать страницу покупки электронного билета на сайте plachem.ru"]
    var datesTasks = ["2 мая", "10 мая", "15 мая", "22 мая", "22 мая", "24 мая", "26 мая", "30 мая"]
    var statusTasks = "Принята к исполнению"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        logo.setBackgroundImage(UIImage(named: "logoBlackNew"), for: .normal, barMetrics: .default)
        logo.title = " "
        profileLogoButton.setBackgroundImage(profilesLogo[0], for: .normal, barMetrics: .default)
        
        getTask()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView()
        mainTableView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        
        let nib = UINib(nibName: "TasksTabViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "TasksTabViewCell")
        
    }
    
    func getTask(){
        
        database.child("Tasks").observe(.value, with: { snap in
            print(snap.value ?? "78")
            guard let value = snap.value as? [[String: String]] else {
                print("error filename")
                return
            }
            print(value)
            
            self.namesTasks.removeAll()
            self.datesTasks.removeAll()
//            statusTasks.removeAll()
            
            for i in 0..<value.count{
                self.namesTasks.append(value[i]["name"]!)
                self.datesTasks.append(value[i]["deadline"]!)
            }
            print("success")
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AnyTaskView") as! AnyTaskView
        
        vc.HeaderOfTaskLabel.text = namesTasks[indexPath.row]
        vc.dateLabel.text = datesTasks[indexPath.row]
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        mainTableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesTasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTabViewCell", for: indexPath) as! TasksTabViewCell
        
        if namesTasks[indexPath.row] != ""{
            cell.labelName.text = namesTasks[indexPath.row]
        } else {
            cell.labelName.text = "Ошибка получения данных или/n данные не были указаны."
        }
        if datesTasks[indexPath.row] != ""{
            cell.labelDate.text = "Крайний срок: \(datesTasks[indexPath.row])"
        } else {
            cell.labelDate.text = "Ошибка получения данных или/n данные не были указаны."
        }
        if statusTasks != ""{
            cell.labelStatus.text = statusTasks
        } else {
            cell.labelStatus.text = "Ошибка получения данных или/n данные не были указаны."
        }
        cell.contentView.layer.cornerRadius = 10
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        cell.selectedBackgroundView = bgColorView
        
        cell.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00) //MARK: COLOR OF CELLS
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.contentView.layer.shadowOpacity = 0.1
        cell.contentView.layer.shadowRadius = 4.0
        
        if cell.labelStatus.text == "Завершена"{
            cell.labelStatus.textColor = colorsOfTasks[1]
        } else if cell.labelStatus.text == "Принята к исполнению"{
            cell.labelStatus.textColor = colorsOfTasks[0]
        } else if cell.labelStatus.text == "Задача назначена"{
            cell.labelStatus.textColor = colorsOfTasks[2]
        } else{
            cell.labelStatus.textColor = UIColor.red
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 175
    }
    
    
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Мои задачи"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        let buttonBack = UIButton(frame: CGRect(x: 19, y: 0, width: 10, height: 15))
        buttonBack.setBackgroundImage(UIImage(named: "backVector"), for: .normal)
        buttonBack.center.y = mainView.center.y
        buttonBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(buttonBack)
        
        let buttonSettings = UIButton(frame: CGRect(x: mainView.bounds.size.width-40, y: 0, width: 20, height: 20))
        buttonSettings.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        buttonSettings.center.y = mainView.center.y
        buttonSettings.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        mainView.addSubview(buttonSettings)
        
        let bigBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        bigBackButton.center.y = mainView.center.y
        bigBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(bigBackButton)
        
        view.addSubview(mainView)
        
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func openSettings(sender: UIButton){
        performSegue(withIdentifier: "OpenFilter", sender: nil)
    }
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func profileLogoTapped(_ sender: UIBarButtonItem) {
        print("tap")
    }
}
