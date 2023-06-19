//
//  ApiViewController.swift
//  LegeartApp
//
//  Created by PRGR on 20.01.2022.
//

import UIKit
import Alamofire

struct WelcomeElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
typealias Welcome = [WelcomeElement]

// MARK: https://app.quicktype.io/

class ApiViewController: UIViewController {
    
    @IBOutlet weak var logo: UIBarButtonItem!
    @IBOutlet weak var label: UILabel!
    
    let json = "https://jsonplaceholder.typicode.com/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        logo.setBackgroundImage(UIImage(named: "logonavBar"), for: .normal, barMetrics: .default)
        logo.title = " "
        //getData(url: urlTest)
        GetJson(url: json)
    }
    
    func GetJson(url: String){
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            let way = response.value!
            print(way[0])
            print("\"\(way[0].id as Int)\"\n\"\(way[0].userID as Int)\"\n\"\(way[0].title as String)\"\n\"\(way[0].body as String)\"")
            
        }
    }
    
//    func getData(url: String){
//        AF.request(url).responseDecodable(of: DecodableType.self) { response in
//            let array = response.value!.headers
//            print("Response:\n\(array)\n")
//            self.label.text = ""
//            for (name, value) in array{
//                //print("\(name) = \(value)")
//                self.label.text! += "\(name) = \(value)\n\n"
//            }
//        }
//    }

    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Запросы"
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
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowMessager", sender: nil)
    }
    
}
