//
//  ChannelVC.swift
//  smallCloud-iOS
//
//  Created by WS on 2023/06/10.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase
import CoreData

class ChannelVC: BaseViewController {

    var context: NSManagedObjectContext{
            
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return app.persistentContainer.viewContext
    }
    lazy var channelTableView: UITableView = {
        let view = UITableView()
        view.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.className)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    var channels = [Channel]()
    private var currentUser: UserInfo?
    private let channelStream = ChannelFirestoreStream()
    private var currentChannelAlertController: UIAlertController?

    
    deinit {
        channelStream.removeListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreData에서 사용자정보를 가져옴
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        do{
            let userInfo = try context.fetch(fetchRequest)
            //로그인 상태
            if userInfo.first != nil {
                self.currentUser = userInfo.first!
                configureViews()
                addToolBarItems()
                setupListener()
            }//비로그인 상태
            else {
                print("block")
                //로그인 아닐때 채팅 비활성화 시키기
                blockScreen()
            }
        }
        catch{
            print("Can't Find userInfo")
        }
        
//        configureViews()
//        addToolBarItems()
//        setupListener()
    }
    
    private func blockScreen(){
        let whiteView = UIView()
        let noteLbl = UILabel()
        whiteView.backgroundColor = .white
        noteLbl.text = "로그인이 필요합니다"
        
        view.addSubview(whiteView)
        view.addSubview(noteLbl)
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        noteLbl.translatesAutoresizingMaskIntoConstraints =  false
        NSLayoutConstraint.activate([
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: view.topAnchor),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noteLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noteLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureViews() {
        
        view.addSubview(channelTableView)
        channelTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addToolBarItems() {
        toolbarItems = [
          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
          UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem))
        ]
        navigationController?.isToolbarHidden = false
    }
    
    private func setupListener() {
        channelStream.subscribe { [weak self] result in
            switch result {
            case .success(let data):
                self?.updateCell(to: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapSignOutItem() {
        showAlert(message: "로그아웃 하시겠습니까?",
                  cancelButtonName: "취소",
                  confirmButtonName: "확인",
                  confirmButtonCompletion: {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        })
    }
    
    @objc private func didTapAddItem() {
        showAlert(title: "새로운 채널 생성",
                  cancelButtonName: "취소",
                  confirmButtonName: "확인",
                  isExistsTextField: true,
                  confirmButtonCompletion: { [weak self] in
            self?.channelStream.createChannel(with: self?.alertController?.textFields?.first?.text ?? "")
        })
    }
    
    // MARK: - Update Cell
    
    private func updateCell(to data: [(Channel, DocumentChangeType)]) {
        data.forEach { (channel, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard channels.contains(channel) == false else { return }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else { return }
        channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        channelTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        channelTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

extension ChannelVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.className, for: indexPath) as! ChannelTableViewCell
        cell.chatRoomLabel.text = channels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatVC(user: currentUser!, channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
