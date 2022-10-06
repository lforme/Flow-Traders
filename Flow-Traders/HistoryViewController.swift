//
//  HistoryViewController.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 1.10.22.
//

import UIKit
import Hero
import SavannaKit
import Hue
import RxSwift
import NSObject_Rx
import RxCocoa
import SnapKit
import SwiftDate
import MJRefresh


class HistoryViewController: UIViewController {

    var db: MetaDb?
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(UINib(nibName: "HisotryCell", bundle: nil), forCellReuseIdentifier: "HisotryCell")
        tv.rowHeight = 60
        return tv
    }()
    
    lazy var emptyView: EmptyView = {
        let v: EmptyView = ViewLoader.Xib.view()
        v.bounds.size = UIScreen.main.bounds.size
        return v
    }()
    
    var dataSource: [HistoryModel] = [] {
        didSet {
            if dataSource.count != 0 {
                tableView.backgroundView = nil
            } else {
                tableView.backgroundView = emptyView
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "History Task"
        
        setupUI()
        setupTableViewRefresh()
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.pixelFont(with: 14)], for: UIControl.State())
    }
    
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private extension HistoryViewController {
    
    func setupUI() {
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundView = emptyView
    }
    
    func setupTableViewRefresh() {
        
        defer {
            tableView.mj_header?.beginRefreshing()
        }
        
        tableView.mj_header = NormalRefreshHeader(refreshingBlock: {[weak self] in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self?.fetchData(isNew: true)
        })
        
        
        tableView.mj_footer = NormalFooter(refreshingBlock: {[weak self] in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self?.fetchData(isNew: false)
            
        })
    }
    
    
    func fetchData(isNew: Bool = true) {
        
        defer {
            tableView.reloadData()
        }
        
        if isNew {
            guard let list = db?.fetch(isNew: isNew).map({ row -> HistoryModel in
                
                let task = row[MetaDb.taskName]
                let time = row[MetaDb.endTime]
                let model = HistoryModel(name: task, time: time)
                
                return model
                
            }) else {
                tableView.mj_header?.endRefreshing()
                return
            }
            dataSource = list
            tableView.mj_header?.endRefreshing()
        } else {
            guard let list = db?.fetch(isNew: isNew).map({ row -> HistoryModel in
                
                let task = row[MetaDb.taskName]
                let time = row[MetaDb.endTime]
                let model = HistoryModel(name: task, time: time)
                
                return model
                
            }) else {
                tableView.mj_footer?.endRefreshing()
                return
            }
            
            if list.count > 0 {
                dataSource += list
                tableView.mj_footer?.endRefreshing()
            } else {
                tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        
        }
    }
}


extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HisotryCell", for: indexPath) as? HisotryCell
    
        let item = dataSource[indexPath.row]
        cell?.bindModel(item: item)
        
        return cell ?? UITableViewCell()
    }
}
