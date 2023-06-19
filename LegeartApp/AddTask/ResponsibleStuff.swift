//
//  ResponsibleStuff.swift
//  LegeartApp
//
//  Created by PRGR on 04.03.2022.
//

import UIKit

class ResponsibleStuff: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let NotificationImage = [UIImage(named: "Anna")]
    let roles = ["Ответственный", "Постановщик", "Соисполнитель", "Наблюдатель"]
    
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        addNavBarButtonItems()
        tbView.delegate = self
        tbView.dataSource = self
        
        let nib = UINib(nibName: "ParticipantsCell", bundle: nil)
        tbView.register(nib, forCellReuseIdentifier: "ParticipantsCell")
        
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        tbView.layer.cornerRadius = 10
        tbView.layer.shadowColor = UIColor.black.cgColor
        tbView.layer.shadowOffset = .zero
        tbView.layer.shadowOpacity = 0.2
        tbView.layer.shadowRadius = 6.0
        tbView.layoutMargins = UIEdgeInsets.zero
        tbView.separatorInset = UIEdgeInsets.zero
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Участники"
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
        but2.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        
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
    @objc func notificationTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tbView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStuff") as! SelectedStuff
        vc.headerLabel = roles[indexPath.row]
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath) as! ParticipantsCell
        cell.labelRoles.text = roles[indexPath.row]
        cell.labelRoles.textColor = UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00)
        cell.labelRoles.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
}
