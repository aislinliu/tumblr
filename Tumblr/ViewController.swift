//
//  ViewController.swift
//  Tumblr
//
//  Created by Aislin Liu on 6/29/20.
//  Copyright © 2020 Aislin Liu. All rights reserved.
//

import UIKit
    
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   let tableView = UITableView()

    var posts: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for constraint in self.view.constraints {
            constraint.isActive = false
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")

                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary

                        // This is where you will store the returned array of posts in your posts property
                         self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        task.resume()

    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        cell.textLabel?.text = "This is row (indexPath.row)"

        return cell
    }
    }

class PhotoCell : UITableViewCell {
    
    private let label : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 16)
    lbl.textAlignment = .left
    return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init")
    }
}


