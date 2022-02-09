//
//  ViewController.swift
//  Geocode
//
//  Created by Adrian Devezin on 6/6/21.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var locations: [[String:Any]] = []
    private let viewModel = ViewModel()
    private var bindings: [AnyCancellable] = []
    private var tableView: UITableView!
    private var addButton: UIButton!
    private var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        let viewStateCancellable = viewModel.$viewState.sink(receiveValue: { viewState in
            switch viewState {
            
            case .initial:
                break
            case let .geocodes(data):
                self.setData(data: data)
            }
        })
        bindings.append(viewStateCancellable)
        let eventCancellable = viewModel.$events.sink(receiveValue: { events in
            guard let events = events else { return }
            switch events {
            
            case .error(_):
                break
            }
        })
        bindings.append(eventCancellable)
    }
    
    private func setData(data: [[String:Any]]) {
        locations = data
        tableView.reloadData()
    }
    
    private func createView() {
        createInput()
        createAddButton()
        createTableView()
    }
    
    private func createTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationItem.self, forCellReuseIdentifier: LocationItem.Identifier)
        
        view.addSubview(tableView)
        let buttonGuide = UILayoutGuide()
        view.addLayoutGuide(buttonGuide)
        buttonGuide.bottomAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: buttonGuide.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func createInput() {
        input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.placeholder = "Enter City"
        input.textColor = UIColor.black
        input.layer.cornerRadius = 8
        input.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(input)
        
        input.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        input.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
    }
    
    private func createAddButton() {
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitleColor(UIColor.blue, for: .normal)
        addButton.setTitle("Add City", for: .normal)
        addButton.addTarget(self, action: #selector(onAddButtonClicked), for: .touchUpInside)
        
        view.addSubview(addButton)
        let inputGuide = UILayoutGuide()
        view.addLayoutGuide(inputGuide)
        
        inputGuide.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
        
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: inputGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc func onAddButtonClicked() {
        viewModel.onAddLocationClick(cityParam: input.text)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationItem.Identifier, for: indexPath) as? LocationItem else {
            fatalError()
        }
        let locationDict = locations[indexPath.row]
        guard let location = LocationPresentable.parse(dict: locationDict) else {
            fatalError()
        }
        cell.setPresentable(presentable: location)
        return cell
    }
    
}

