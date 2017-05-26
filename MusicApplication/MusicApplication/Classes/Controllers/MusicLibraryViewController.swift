//
//  MusicLibraryViewController.swift
//  MusicApplication
//
//  Created by Sidramappa Halake on 24/05/17.
//  Copyright © 2017 Sidramappa Halake. All rights reserved.
//

import UIKit

class MusicLibraryViewController: UIViewController {
    
    //MARK:- @IBOutlet
    @IBOutlet weak fileprivate var musicLibraryTableView: UITableView!
    
    //MARK:- Stored Properties
    fileprivate let defaultSearchKey = "bruno"
    fileprivate var musicArray: [Music]?
    fileprivate var searchBar: UISearchBar?
    
    //MARK:- View Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewDidLoad()
    }
    
    //MARK:- @IBAction methods

    @IBAction func didTapSearchBarButton(_ sender: UIBarButtonItem) {
        
        if self.searchBar?.isHidden == true {
            //Present Search Bar with animation
            UIView.animate(withDuration: 1, animations: {
                self.searchBar?.isHidden = false
            }) { _ in
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                    self.searchBar!.frame = CGRect(x: self.searchBar!.frame.size.width, y: 0, width: self.searchBar!.frame.size.width, height: 44)
                    self.navigationItem.titleView = self.searchBar
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(self.didTapSearchBarButton(_:)))
                })
            }
        }
        else {
            //Remove Search Bar with animation
            UIView.animate(withDuration: 1, animations: {
            }) { _ in
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                    self.searchBar!.frame = CGRect(x: -self.searchBar!.frame.size.width, y: 0, width: self.searchBar!.frame.size.width, height: 44)
                })
                self.searchBar?.isHidden = true
                self.confugureNavigationBar()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(self.didTapSearchBarButton(_:)))

            }
            
        }
    }
}


//MARK:- UITableViewDataSource methods
extension MusicLibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicLibraryCell", for: indexPath) as! MusicLibraryCell
        if let music =  musicArray?[indexPath.row] {
            cell.configureCell(for: music)
        }
        cell.layer.zPosition = -(CGFloat(indexPath.row))
        return cell
    }
}

//MARK:- UITableViewDelegate methods
extension MusicLibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let musicArray = musicArray {
            let controller = PlayerViewController.controller(for: musicArray, selectedIndex: indexPath.row)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
//MARK:- private methods
private extension MusicLibraryViewController {
    
    ///Configure the initial viewdidload setup
    func configureViewDidLoad() {
        
        musicLibraryTableView.estimatedRowHeight = 100
        musicLibraryTableView.rowHeight = UITableViewAutomaticDimension
        configureSearchBar()
        confugureNavigationBar()
        musicLibraryTableView.isHidden = true
        addActivateIndicator()
        MusicDownloadManager.sharedInstance.downloadData(form: MusicAPI.getMusicAPI(for: defaultSearchKey)) { (response, error) in
            if let response = response {
                self.musicArray = Music.getMusicArray(from: response)
                self.musicLibraryTableView.reloadData()
            }
            self.musicLibraryTableView.isHidden = false
            self.stopActivityIndicator()
        }
    }
    
    ///Configure the navigation bar
    func confugureNavigationBar() {
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 44))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.text = "Music Library"
        navigationItem.titleView = titleLabel
    }
    
    ///Does the initial setup for searchBar
    func configureSearchBar() {
        
        searchBar = UISearchBar.init(frame: CGRect.init(x: -view.frame.size.width, y: 0, width: view.frame.size.width, height: 44))
        searchBar?.isHidden = true
        searchBar?.placeholder = "Search music"
        searchBar?.delegate = self
    }
}

//MARK:- UISearchBarDelegate methods
extension MusicLibraryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        if let searchText = searchBar.text, !searchText.isEmpty {
            let encoding = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            addActivateIndicator()
            MusicDownloadManager.sharedInstance.downloadData(form: MusicAPI.getMusicAPI(for: encoding)) { (response, error) in
                self.stopActivityIndicator()
                if let response = response, !response.isEmpty{
                    self.musicArray = Music.getMusicArray(from: response)
                    self.musicLibraryTableView.reloadData()
                    self.musicLibraryTableView.scrollsToTop=true
                } else {
                    self.showAlert(for: "Alert!", message: "No result found for \(searchText).")
                }
            }
        }
        searchBar.text = ""
        didTapSearchBarButton(UIBarButtonItem())
    }
}
