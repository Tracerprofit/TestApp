//
//  ContactInfo.swift
//  LegeartApp
//
//  Created by PRGR on 04.03.2022.
//

import UIKit

class ContactInfo: UIViewController {

    
    let NotificationImage = [UIImage(named: "Anna")]
    let BigPicture = [UIImage(named: "DenisBigPic"), UIImage(named: "maks"), UIImage(named: "alex"), UIImage(named: "AnnaBig")]
    let fullName = ["Денис Бураков"]
    let role = ["Директор", "Менеджер", "Веб-дизайнер", "Дизайнер"]
    let number = ["+7 926 602 16 00", "+7 914 582 22 17", "+7 951 581 44 86", "+7 911 611 11 11"]
    let numberOfAttachments = ["37", "12", "18", "22"]
    
    
    var user_name = ""
    var roles = ""
    var numberTelephone = ""
    var attach = ""
    var img = UIImage()
    var bigPic = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        addNavBarButtonItems()
        setupViews()
        
    }
    func setupViews(){
//        var picture = UIImageView(image: BigPicture[0])
        let picture = UIImageView(image: bigPic)
        picture.frame = CGRect(x: 0, y: 39, width: view.frame.width, height: 276)
        view.addSubview(picture)
        
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        
        let view1 = UIView(frame: CGRect(x: 11, y: 330, width: view.frame.width - 22, height: 133))
        
        let name = UILabel(frame: CGRect(x: 14, y: 15, width: 150, height: 30))
        name.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 0.2))
        name.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
//        name.text = fullName[0]
        name.text = user_name
        
        let roleLabel = UILabel(frame: CGRect(x: 14, y: 35, width: 150, height: 30))
        roleLabel.font = UIFont.systemFont(ofSize: 10)
        roleLabel.textColor = UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00)
//        roleLabel.text = role[0]
        roleLabel.text = roles
        
        let numberOfTelephone = UILabel(frame: CGRect(x: 14, y: 56, width: 150, height: 30))
        numberOfTelephone.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 0.2))
        numberOfTelephone.textColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
//        numberOfTelephone.text = number[0]
        numberOfTelephone.text = numberTelephone
        
        let callButton = UIButton(frame: CGRect(x: view1.frame.maxX - 56, y: 36, width: 20, height: 20))
        callButton.setBackgroundImage(UIImage(named: "telephoneBlue"), for: .normal)
        callButton.addTarget(self, action: #selector(tapACallButton), for: .touchUpInside)
        callButton.tintColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        
        let line = CALayer()
        line.frame = CGRect(x: 0, y: numberOfTelephone.frame.maxY + 5, width: view1.frame.width, height: 1)
        line.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00).cgColor
        view1.layer.addSublayer(line)
        
        let OnCall = UILabel(frame: CGRect(x: 17, y: numberOfTelephone.frame.maxY + 10, width: 50, height: 30))
        OnCall.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        OnCall.font = UIFont.systemFont(ofSize: 10)
        OnCall.text = "На связи"
        
        for obj in [name, roleLabel, numberOfTelephone, callButton, OnCall]{
            view1.addSubview(obj)
        }
        view.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 11, y: view1.frame.maxY + 15, width: view.frame.width - 22, height: 108))
        
        let centerLine = CALayer()
        centerLine.frame = CGRect(x: 0, y: 54, width: view2.frame.width, height: 1)
        centerLine.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00).cgColor
        view2.layer.addSublayer(centerLine)
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: view2.frame.width, height: view2.frame.height / 2 - 1))
        button1.addTarget(self, action: #selector(tapOn1Button), for: .touchUpInside)
        button1.setTitle("", for: .normal)
        button1.layer.cornerRadius = 10
        
        let button2 = UIButton(frame: CGRect(x: 0, y: view2.frame.height / 2 + 1, width: view2.frame.width, height: view2.frame.height / 2 - 1))
        button2.addTarget(self, action: #selector(tapOn2Button), for: .touchUpInside)
        button2.setTitle("", for: .normal)
        button2.layer.cornerRadius = 10
        
        let label1 = UILabel(frame: CGRect(x: 14, y: 0, width: 180, height: 30))
        label1.center.y = button1.center.y
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.text = "Медиа, ссылки, и документы"
        
        let countOfAttachments = UILabel(frame: CGRect(x: button1.bounds.size.width - 55, y: 0, width: 15, height: 25))
//        countOfAttachments.text = numberOfAttachments[0]
        countOfAttachments.text = attach
        countOfAttachments.center.y = button1.center.y
        countOfAttachments.textColor = UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00)
        countOfAttachments.font = UIFont.systemFont(ofSize: 12)
        
        let vectorImg = UIImageView(image: UIImage(named: "VectorGray"))
        vectorImg.frame = CGRect(x: button1.bounds.size.width - 20, y: 0, width: 8, height: 12)
        vectorImg.center.y = button1.center.y
        
        let vectorImg2 = UIImageView(image: UIImage(named: "VectorGray"))
        vectorImg2.frame = CGRect(x: button2.bounds.size.width - 20, y: 0, width: 8, height: 12)
        vectorImg2.center.y = button2.center.y
        
        let label2 = UILabel(frame: CGRect(x: 14, y: 0, width: 100, height: 30))
        label2.center.y = button2.center.y
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.text = "Поиск в чате"
        
        for obj in [button1, button2, label1, label2, countOfAttachments, vectorImg, vectorImg2]{
            view2.addSubview(obj)
        }
        
        view.addSubview(view2)
        
        for views in [view1, view2]{
            views.backgroundColor = .white
            views.layer.cornerRadius = 10
            views.layer.shadowColor = UIColor.black.cgColor
            views.layer.shadowOffset = .zero
            views.layer.shadowOpacity = 0.2
            views.layer.shadowRadius = 6.0
        }
        
    }
    @objc func tapOn1Button(){
        print("tap on 1")
    }
    @objc func tapOn2Button(){
        print("tap on 2")
    }
    @objc func tapACallButton(){
        print("tap a call")
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Данные контакта"
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
}
