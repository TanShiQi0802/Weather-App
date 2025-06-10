
//  ViewController.swift
//  Weather App
//
//  Created by ptsq2579 on 3/6/25.


import UIKit
import SwiftUI

class HomeView: UIViewController {

    private var viewModel : HomeViewModel
    private let search : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        return table
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor") ?? .systemBlue
        label.font = UIFont.systemFont(ofSize: 37)
        label.textAlignment = .center
        label.text = "SkyCast"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let img : UIImageView = {
        let image = UIImageView(image: UIImage(named: "weather") ?? UIImage())
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(viewModel: HomeViewModel = HomeViewModel(repository: CityRepository())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(viewModel:) instead.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(img)
        view.addSubview(search)
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            img.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            img.widthAnchor.constraint(equalToConstant: 200),
            img.heightAnchor.constraint(equalToConstant: 200),
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            search.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 50),
            search.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            search.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            search.heightAnchor.constraint(equalToConstant: 44),
          
            tableView.topAnchor.constraint(equalTo: search.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDelegates(){
        search.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
      
    }
}

extension HomeView : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCities(query: searchText)
        tableView.reloadData()
    }
}

extension HomeView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredcities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.filteredcities[indexPath.row]
        return cell
    }
}

extension HomeView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let city = viewModel.filteredcities[indexPath.row]
        guard !city.isEmpty else { return }
        let weatherCityView = CityView(query: city)
        let hostingController = UIHostingController(rootView: weatherCityView)
        search.text = ""
        viewModel.addRecentCity(city: city)
        tableView.reloadData()
        present(hostingController, animated: true)
    }
}




    
    



