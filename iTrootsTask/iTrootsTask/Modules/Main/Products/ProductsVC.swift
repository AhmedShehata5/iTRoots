//
//  ProductsVC.swift
//  iTrootsTask
//
//  Created by Ahmed on 29/01/2026.
//


import UIKit

class ProductsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = ProductsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }

    private func bindViewModel() {
            viewModel.onError = { [weak self] message in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "alert_title".localized, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductCell")
    }

    private func loadData() {
        viewModel.fetchProducts { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ProductsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}
