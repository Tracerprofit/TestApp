//
//  SelectedStuff.swift
//  LegeartApp
//
//  Created by PRGR on 05.03.2022.
//

import UIKit

class SelectedStuff: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mainTableView: UITableView!
    let NotificationImage = [UIImage(named: "Anna")]
    let data = ["Денис Бураков", "Максим Каптановский", "Андрей Алексеев", "Анна Бичерова"]
    let imgs = [UIImage(named: "denis"), UIImage(named: "maks"), UIImage(named: "alex"), UIImage(named: "AnnaBig")]
    var items = [String]()
    var headerLabel:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        addSelectButton()
        
        let nib = UINib(nibName: "SelectedStuffCells", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "SelectedStuffCells")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        mainTableView.layer.cornerRadius = 10
        mainTableView.layer.shadowColor = UIColor.black.cgColor
        mainTableView.layer.shadowOffset = .zero
        mainTableView.layer.shadowOpacity = 0.2
        mainTableView.layer.shadowRadius = 6.0
        mainTableView.layoutMargins = UIEdgeInsets.zero
        mainTableView.separatorInset = UIEdgeInsets.zero
        
    }
    func addSelectButton(){
        let selectButton = UIButton(frame: CGRect(x: 0, y: 300, width: 80, height: 38))
        selectButton.setTitle("Выбрать", for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectButton.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        selectButton.layer.cornerRadius = 10
        selectButton.center.x = view.center.x - 100
        selectButton.addTarget(self, action: #selector(selectMembers), for: .touchUpInside)
        view.addSubview(selectButton)
        
        let closeButton = UIButton(frame: CGRect(x: 0, y: 300, width: 80, height: 38))
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        closeButton.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        closeButton.layer.cornerRadius = 10
        closeButton.center.x = selectButton.center.x + 200
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        
    }
    
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 38))
        labelInView.center = mainView.center
        labelInView.text = headerLabel
        labelInView.textAlignment = .center
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        view.addSubview(mainView)
        
    }
    func addNavBarButtonItems(){
        
        let logo = UIImageView(image: UIImage(named: "logoBlackNew"))
        let viewForLogo = UIView(frame: CGRect(x: 0, y: 0, width: Int(logo.frame.width), height: Int(logo.frame.height)))
        viewForLogo.bounds = viewForLogo.bounds.offsetBy(dx: 3, dy: 0)
        viewForLogo.addSubview(logo)
        
        let MainLogoView = UIBarButtonItem(customView: viewForLogo)
        self.navigationItem.setLeftBarButton(MainLogoView, animated: true)
        
        let but1 = UIButton(type: .custom)
        but1.setTitle(" ", for: .normal)
        but1.setBackgroundImage(NotificationImage[0], for: .normal)
        but1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let but2 = UIButton(type: .custom)
        but2.setTitle(" ", for: .normal)
        but2.setBackgroundImage(UIImage(named: "notiifcations"), for: .normal)
        but2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let viewForBut1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewForBut1.bounds = viewForBut1.bounds.offsetBy(dx: 8, dy: 0)
        viewForBut1.addSubview(but1)
        
        let viewForBut2 = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        viewForBut2.bounds = viewForBut2.bounds.offsetBy(dx: 0, dy: 0.5)
        viewForBut2.addSubview(but2)
        
        let item1 = UIBarButtonItem(customView: viewForBut1)
        let item2 = UIBarButtonItem(customView: viewForBut2)
        
        self.navigationItem.setRightBarButtonItems([item2, item1], animated: true)
    }
    @objc func selectMembers(){
        items.removeAll()
        if let selectedRows = mainTableView.indexPathsForSelectedRows{
            for iPath in selectedRows{
                items.append(data[iPath.row])
            }
            print("Selected")
            for item in items{
                print(item)
            }
        } else{
            print("Nothing selected")
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        mainTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "SelectedStuffCells", for: indexPath) as! SelectedStuffCells
        cell.imageLogo.image = imgs[indexPath.row]!
        cell.nameLabel.text = data[indexPath.row]
        
        return cell
    }

}
