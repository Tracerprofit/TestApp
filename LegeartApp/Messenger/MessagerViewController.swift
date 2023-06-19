//
//  MessagerViewController.swift
//  LegeartApp
//
//  Created by PRGR on 28.01.2022.
//

import UIKit
import Firebase
import MessageKit

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}
struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class MessagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let storage = Storage.storage().reference()
    static let shared = MessagerViewController()
    
    private var conversations = [Conversation]()
    
    @IBOutlet weak var logo: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    let data = ["Денис Бураков", "Максим Каптановский", "Андрей Алексеев", "Анна Бичерова"]
    let imgs = [UIImage(named: "denis"), UIImage(named: "maks"), UIImage(named: "alex"), UIImage(named: "AnnaBig")]
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 51, width: 0, height: 36))
    let noResultLabel = UILabel(frame: CGRect(x: 0, y: 250, width: 200, height: 30))
//    let searchedUsers = UITableView(frame: CGRect(x: 0, y: 134, width: 0, height: 300))
    
    var allUsers = [[String: String]]()
    var users = [[String: String]]()
    var results = [[String: String]]()
    var hasFetched = false
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        setupHeader()
        setupLinesForTableView()
        startListeningForConversations()
        
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
//        searchedUsers.tableFooterView = UIView()
        
//        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        
//        searchedUsers.register(nib, forCellReuseIdentifier: "TableViewCell")
//        searchedUsers.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        
        
//        print("\(UserDefaults.standard.string(forKey: "name")) \(UserDefaults.standard.string(forKey: "lastname"))")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    private func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("\nstart conversation fetch")
        
        let safeEmail = ChatViewController.safeEmail(emailAddress: email)
        self.getAllConversation(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got convos models\n")
                guard !conversations.isEmpty else {
                    return
                }
                
                self?.conversations = conversations
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("failed to get convos: \(error)")
                print("У пользователя нет диалогов")
            }
        })
    }
    

    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {_ in
            let action = UIAction(title: "Подробнее") {_ in
                
                if let vc = self.storyboard?.instantiateViewController(identifier: "ContactInfo") as? ContactInfo{
//                    vc.img = self.imgs[indexPath.row]!
//                    vc.user_name = self.data[indexPath.row]
                    vc.bigPic = vc.BigPicture[indexPath.row]!
//                    vc.user_name = self.data[indexPath.row]
                    vc.roles = vc.role[indexPath.row]
                    vc.numberTelephone = vc.number[indexPath.row]
                    vc.attach = vc.numberOfAttachments[indexPath.row]
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
            }
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [action])
            return menu
        }
        return config
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if tableView == searchedUsers{
            return results.count
        } else {
            return conversations.count
        }
        */
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if tableView == searchedUsers{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.LabelName.text = results[indexPath.row]["name"]
//            cell.imageName.image = imgs[indexPath.row]
            return cell
        }else{*/
         let model = conversations[indexPath.row]
         
         let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
         cell.configure(with: model)
         
         return cell
        //}
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.LabelName.text = data[indexPath.row]
        cell.imageName.image = imgs[indexPath.row]
        return cell
        */
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        let vc = ChatViewController(with: "admin")
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)*/
        /*
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
        
        completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        */
        let model = conversations[indexPath.row]

        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    /*
    func searchUsers(query: String){
        
        if hasFetched{
            filterUsers(with: query)
        } else {
            self.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }
        
    }*/

    
    func setupHeader(){
        /*
        searchBar.placeholder = "Найти пользователя"
        searchBar.bounds.size.width = view.bounds.size.width
        searchBar.center.x = view.center.x
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        
        searchedUsers.bounds.size.width = view.bounds.width
        searchedUsers.center.x = view.center.x
        searchedUsers.isHidden = true
        searchedUsers.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchedUsers.delegate = self
        searchedUsers.dataSource = self
        view.addSubview(searchedUsers)
        */
        noResultLabel.center.x = view.center.x
        noResultLabel.text = "Нет результатов"
        noResultLabel.textAlignment = .center
        noResultLabel.textColor = .black
        noResultLabel.font = UIFont.systemFont(ofSize: 20)
        noResultLabel.isHidden = true
        view.addSubview(noResultLabel)
        
        let newGroup = UIButton(frame: CGRect(x: 12, y: 50, width: 80, height: 25))
        newGroup.setTitle("Новая группа", for: .normal)
        newGroup.setTitleColor(UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00), for: .normal)
        newGroup.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        newGroup.addTarget(self, action: #selector(tapTest), for: .touchUpInside)
        
        view.addSubview(newGroup)
        
        let searchButton = UIButton(frame: CGRect(x: view.bounds.width - 36, y: 50, width: 21, height: 19))
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(tapOnSearch), for: .touchUpInside)
        
        view.addSubview(searchButton)
        
    }
    @objc func tapOnSearch(){
        let vc = NewConversationVC()
        
        vc.completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    public func createNewConversation(result: SearchResult){
        let name = result.name
        let email = result.email
        
        let vc = ChatViewController(with: email, id: nil)
        vc.title = name
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupLinesForTableView(){
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width + 40, height: px)
        let line = UIView(frame: frame)
//        let frame2 = CGRect(x: 0, y: 0, width: self.searchedUsers.frame.size.width + 40, height: px)
//        let line2 = UIView(frame: frame2)
        self.tableView.tableHeaderView = line
//        self.searchedUsers.tableHeaderView = line2
        line.backgroundColor = self.tableView.separatorColor
//        line2.backgroundColor = self.searchedUsers.separatorColor
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
//        searchedUsers.layoutMargins = UIEdgeInsets.zero
//        searchedUsers.separatorInset = UIEdgeInsets.zero
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Чаты"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        view.addSubview(mainView)
        
    }
    
    //return all conversations for the user with passed in email
    public func getAllConversation(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void){
        
        
        database.child("\(email)/conversation").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(StorageManager.DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    return nil
                }
                
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                return Conversation(id: conversationId, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
            })
            
            completion(.success(conversations))
            
        })
    }
    
    //get all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void){
        
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(StorageManager.DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString) else {
                        return nil
                }
                
                var kind: MessageKind?
                if type == "photo"{
                    //photo
                    guard let imageUrl = URL(string: content),
                    let placeHolder = UIImage(systemName: "plus") else {
                        return nil
                    }
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                } else if type == "video"{
                    //photo
                    guard let videoUrl = URL(string: content),
                    let placeHolder = UIImage(systemName: "plus") else {
                        return nil
                    }
                    let media = Media(url: videoUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .video(media)
                } else {
                    kind = .text(content)
                }
                guard let finalKind = kind else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)
                
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: finalKind)
            })
            
            completion(.success(messages))
            
        })
        
    }
    
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageManager.StorageErrors.failedToGetDownloadURl))
                return
            }
            
            completion(.success(url))
            
            
        })
    }
    
    @objc func tapTest(){
        print("test")
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

