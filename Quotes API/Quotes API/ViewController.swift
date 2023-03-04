//
//  ViewController.swift
//  Quotes API
//
//  Created by Kyra Hung on 3/4/23.
//

import UIKit

class ViewController: UITableViewController {

    private static let reuseIdentifier = "identifier"
    var searchResponse: SearchResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        makeAPIcall{ searchResponse in
            self.searchResponse = searchResponse
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  searchResponse?.results[indexPath.row].content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func makeAPIcall(completion: @escaping (SearchResponse?) -> Void) {
        print("Start API Call")
        guard let url = URL(string: "https://api.quotable.io/quotes") else {return}
        
        let task = URLSession.shared.dataTask(with:url) {data, response, error in
            var searchResponse: SearchResponse?
            defer { completion(searchResponse)}
            print("Done with call")
            if let error = error {
                print("Error with API call: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response (\(String(describing: response))")
                // response returned some non-successful status code
                return
            }
            //if let data = data,
               //let dataString = String(data: data, encoding: String.Encoding.utf8) {
                //print(dataString)
            //}
            if let data = data,
                let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
                    print("Success")
                    searchResponse = response
                } else {
                    print("Something is wrong with decoding, probably.")
            }
        }
        task.resume()
    }
}

struct SearchResponse:Codable {
    let count: Int
    let totalCount: Int
    let page: Int
    let totalPages: Int
    let lastItemIndex: Int
    let results: [Quote]
}

struct Quote:Codable {
    let _id: String
    let author: String
    let content: String
}

