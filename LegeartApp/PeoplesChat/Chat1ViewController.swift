//
//  Chat1ViewController.swift
//  LegeartApp
//
//  Created by PRGR on 21.02.2022.
//

import UIKit
import MessageKit 

class Chat1ViewController: UIViewController {
    
    let NotificationImage = [UIImage(named: "Anna")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        addNavBarButtonItems()
        view.backgroundColor = .white
        
        
        
        
    }
    
    
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Денис Бураков"
        labelInView.textColor = .white
        labelInView.textAlignment = .center
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
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
