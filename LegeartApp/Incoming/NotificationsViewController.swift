//
//  NotificationsViewController.swift
//  LegeartApp
//
//  Created by PRGR on 31.01.2022.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var logo: UIBarButtonItem!
    @IBOutlet weak var profileLogoButton: UIBarButtonItem!
    
    let profilesLogo = [UIImage(named: "Anna")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        logo.setBackgroundImage(UIImage(named: "logoBlackNew"), for: .normal, barMetrics: .default)
        logo.title = " "
        profileLogoButton.setBackgroundImage(profilesLogo[0], for: .normal, barMetrics: .default)

    }
    
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Уведомления"
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
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ProfileLogoTapped(_ sender: UIBarButtonItem) {
        print("tap")
    }
}
