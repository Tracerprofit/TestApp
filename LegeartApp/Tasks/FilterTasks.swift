//
//  FilterTasks.swift
//  LegeartApp
//
//  Created by PRGR on 31.01.2022.
//

import UIKit

class FilterTasks: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var logo: UIBarButtonItem!
    @IBOutlet weak var profileLogoButton: UIBarButtonItem!
//    @IBOutlet weak var view1: UIView!
//    @IBOutlet weak var view2: UIView!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    let tableOne = ["Делаю", "Помогаю", "Получил", "Наблюдаю", "Комментарии"]
    let tableTwo = ["Приоритет", "Я постановщик", "Завершенные", "На паузе", "Горящие", "Все задачи"]
    let countOfTasksOne = [18, 22, 61, 0, 6]
    let countOfTasksTwo = [3, 5, 11, 9, 1, 154]
    let profilesLogo = [UIImage(named: "Anna")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileLogoButton.setBackgroundImage(profilesLogo[0], for: .normal, barMetrics: .default)
        addViewNavBar()
        setupViews()
        
        tableView1.layer.cornerRadius = 10
//        tableView1.tableFooterView = UIView()
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.layer.cornerRadius = 10
//        tableView2.tableFooterView = UIView()
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        tableView2.delegate = self
        tableView2.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == tableView1 {
                return tableOne.count
            }
            return tableTwo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == tableView1 {
                let cell = tableView1.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let bigString = "\(tableOne[indexPath.row]) (\(countOfTasksOne[indexPath.row]))"
                let smallString = "(\(countOfTasksOne[indexPath.row]))"
                
                let range = (bigString as NSString).range(of: smallString)
                let attributedString = NSMutableAttributedString(string: bigString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00) , range: range)
                
                cell.textLabel?.attributedText = attributedString
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            } else {
                let cell = tableView2.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
                let bigString = "\(tableTwo[indexPath.row]) (\(countOfTasksTwo[indexPath.row]))"
                let smallString = "(\(countOfTasksTwo[indexPath.row]))"
                
                let range = (bigString as NSString).range(of: smallString)
                let attributedString = NSMutableAttributedString(string: bigString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00) , range: range)
                
                cell.textLabel?.attributedText = attributedString
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == tableView1 {
                // you clicked the first table
                tableView1.deselectRow(at: indexPath, animated: true)
                print(tableOne[indexPath.row])
            } else {
                // you clicked the second table
                tableView2.deselectRow(at: indexPath, animated: true)
                print(tableTwo[indexPath.row])
            }
    }
    
    
    
    func setupViews(){
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: tableView1.frame.height))
        view1.backgroundColor = .systemPink
        view1.center = tableView1.center
        view1.layer.zPosition = -5
        view.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: tableView2.frame.width, height: tableView2.frame.height))
        view2.backgroundColor = .blue
        view2.center = tableView2.center
        view2.layer.zPosition = -5
        view.addSubview(view2)
        
        for views in [view1, view2]{
            views.layer.cornerRadius = 10
            views.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            views.layer.shadowOffset = CGSize(width: 0, height: 4)
            views.layer.shadowOpacity = 1
            views.layer.shadowRadius = 8
            views.isUserInteractionEnabled = false
        }
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Фильтр"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        let buttonBack = UIButton(frame: CGRect(x: 19, y: 0, width: 10, height: 15))
        buttonBack.setBackgroundImage(UIImage(named: "backVector"), for: .normal)
        buttonBack.center.y = mainView.center.y
        buttonBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(buttonBack)
        
        let bigBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        bigBackButton.center.y = mainView.center.y
        bigBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(bigBackButton)
        
        logo.setBackgroundImage(UIImage(named: "logoBlackNew"), for: .normal, barMetrics: .default)
        logo.title = " "
        view.addSubview(mainView)
        
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func profileLogoTapped(_ sender: UIBarButtonItem) {
        print("tap")
    }
}
