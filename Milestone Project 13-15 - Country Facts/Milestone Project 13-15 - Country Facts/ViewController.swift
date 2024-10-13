//
//  ViewController.swift
//  Milestone Project 13-15 - Country Facts
//
//  Created by Stefan Storm on 2024/09/29.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var countries = [Country]()
    var filteredCountries = [Country]()
    var cellID = "cellID"
    
    
    lazy var countryTableview: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .plain)
        tv.register(CountryCell.self, forCellReuseIdentifier: cellID)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.layer.cornerRadius = 20
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        title = "Country Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        
        navigationItem.rightBarButtonItems = [search, refresh]
        
        setupViewController()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.retrieveData()
        }

    }
    

    @objc func refreshTapped(){
        self.filteredCountries.removeAll()
        filteredCountries = countries
        countryTableview.reloadData()
    }
    
    
    @objc func searchTapped(){
        let ac = UIAlertController(title: "Search Country:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else {return}
            guard !item.isEmpty else { self?.showError(message: "Textfield empty.");return}
            guard let countries = self?.filteredCountries else {return}
            self?.filteredCountries.removeAll()
            
            DispatchQueue.global().async { [weak self] in
          
                for country in countries {
                    if country.commonName.contains(item){
                        self?.filteredCountries.append(country)
                    }
                }
                DispatchQueue.main.async {
                    self?.countryTableview.reloadData()
                }
            }
        }
        ac.addAction(addAction)
        present(ac, animated: true)
    }
    
    
    @objc func showError(message: String?){
        let ac = UIAlertController(title: "Error", message: message == nil ? "Error downloading information. Please check network connection." : message, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "Okay", style: .default))
         present(ac, animated: true)
     }

    
    func retrieveData(){
        let urlString = "https://restcountries.com/v3.1/all"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Check for errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check for valid response and data
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                   let data = data {
                    do {
                        // Parse the JSON response
                        if let countriesLocal = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            for country in countriesLocal {
                                
                                // Get the country name
                                if let name = country["name"] as? [String: Any],
                                   //Second branch JSON
                                   let commonName = name["common"] as? String {
                                    
                                    // First branch JSON
                                    let area = country["area"] as? Int ?? 0
                                    let population = country["population"] as? Int ?? 0
                                    let region = country["region"] as? String ?? "N/A"
                                    let capital = (country["capital"] as? [String])?.first ?? "N/A"
                                    
                                    // First branch JSON
                                    if let flags = country["flags"] as? [String: Any],
                                       //Second branch JSON
                                       let flagURL = flags["png"] as? String {
    
                                        DispatchQueue.main.async {[weak self] in
                                            self?.filteredCountries.append(Country(commonName: commonName, capital: capital, population: population, area: area, flag: flagURL, region: region))
                                            self?.filteredCountries.sort { $0.commonName < $1.commonName }
                                            
                                            if let filteredCountries = self?.filteredCountries{
                                                self?.countries = filteredCountries
                                            }
                                           
                                            self?.countryTableview.reloadData()
                                        }
                                        
                                        
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Invalid response or data.")
                }
            }
            
            task.resume() // Start the network task
        }
       
    }
    
    
    
    
    func setupViewController(){
        view.addSubview(countryTableview)

        
        NSLayoutConstraint.activate([
            countryTableview.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10) ,
            countryTableview.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            countryTableview.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            countryTableview.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
           
            
            ])
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CountryCell else {fatalError("Error")}
        let country = filteredCountries[indexPath.row]
        cell.nameLabel.text = country.commonName
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.detailedCountry = filteredCountries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

