//
//  Untitled.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import UIKit
import Combine

class BugListTableView: UIView {
    
    weak var viewModel: BugItListViewModel!
    var tableView: UITableView
    let cellId = "Cell"
    var didTap: ((BugPresentedDataViewModel) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl() // Add refresh control
    
    init(
        frame: CGRect,
        viewModel: BugItListViewModel
    ) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        
        self.viewModel = viewModel
        setupTableView()
        bindViewModel()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BugCellViewItemView.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none // Optional: to remove cell separators

    }
    
    private func bindViewModel() {
        viewModel.$displayModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BugListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BugCellViewItemView else { return UITableViewCell() }
        cell.configure(with: viewModel.displayModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTap?(viewModel.displayModel[indexPath.row])
    }
}
