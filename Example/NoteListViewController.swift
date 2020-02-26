//
//  NoteListViewController.swift
//  Example
//
//  Created by Sven Tiigi on 20.11.2019.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

// MARK: - NoteListViewController

/// The NoteListViewController
class NoteListViewController: UIViewController {

    // MARK: Properties
    
    @CodableStoredArray
    var notes: [Note] = .init() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CodableStoreKit"
        self.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.onAddNoteBarButtonTap)
        )
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.tableView
    }

}

// MARK: - Target Handler

extension NoteListViewController {
    
    @objc
    func onAddNoteBarButtonTap(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "Add a Note",
            message: "Enter the content of your note",
            preferredStyle: .alert
        )
        alertController.addAction(.init(
            title: "Confirm",
            style: .default,
            handler: { _ in
                guard let content = alertController.textFields?.first?.text else {
                    return
                }
                let note = Note(content: content)
                self.notes.append(note)
            }
        ))
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        alertController.addTextField()
        self.present(alertController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension NoteListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.notes[indexPath.section].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let note = self.notes[indexPath.section]
        self.notes.removeAll(where: { $0.id == note.id })
    }
    
}
