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
    var allQuotes = [SearchResponse]()
    
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
        if (allQuotes.count != 0)
        {
            cell.textLabel?.text = allQuotes[indexPath.row].sentence
        }
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
        return 10
    }
    
    func makeAPIcall(completion: @escaping (SearchResponse?) -> Void) {
        print("Start API Call")
        guard let url = URL(string: "https://api.gameofthronesquotes.xyz/v1/random/20") else {return}
        
        let task = URLSession.shared.dataTask(with:url) { [self]data, response, error in
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
                let response = try? JSONDecoder().decode([SearchResponse].self, from: data) {
                    print("Success")
                allQuotes += response
                } else {
                    print("Something is wrong with decoding, probably.")
            }
        }
        task.resume()
    }
}

struct SearchResponse: Codable {
    let sentence: String
    let character: Character
}

struct Character: Codable {
    let name: String
}
