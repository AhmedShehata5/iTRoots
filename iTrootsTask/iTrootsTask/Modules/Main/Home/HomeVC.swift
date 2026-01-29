//
//  HomeVC.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import UIKit
import SideMenu

final class HomeVC: UIViewController {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    private var timer: Timer?
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTable()
        hideKeyboardWhenTappedAround()
        bindViewModel()
        viewModel.loadData()
        startAutoScroll()
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.sliderCollectionView.reloadData()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "alert_title".localized, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    private func setupCollection() {
            sliderCollectionView.register(
                UINib(nibName: "SliderCell", bundle: nil),
                forCellWithReuseIdentifier: "SliderCell"
            )
        sliderCollectionView.showsVerticalScrollIndicator = false
        sliderCollectionView.showsHorizontalScrollIndicator = false
            sliderCollectionView.dataSource = self
            sliderCollectionView.delegate = self
        }

    private func setupTable() {
        tableView.register(
            UINib(nibName: "HomeItemCell", bundle: nil),
            forCellReuseIdentifier: "HomeItemCell"
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 0
    }
    

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let numberOfItems = self.viewModel.sliderItems.count
            guard numberOfItems > 0 else { return }
            
            self.currentIndex += 1
            
            if self.currentIndex >= numberOfItems {
                self.currentIndex = 0
            }

            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.sliderCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
        }
    }

}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sliderItems.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SliderCell",
            for: indexPath
        ) as! SliderCell

        cell.configure(with: viewModel.sliderItems[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 20 , height: collectionView.frame.height - 20)
    }
}


extension HomeVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.homeItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "HomeItemCell",
            for: indexPath
        ) as! HomeItemCell

        cell.configure(with: viewModel.homeItems[indexPath.row])
        return cell
    }
}
