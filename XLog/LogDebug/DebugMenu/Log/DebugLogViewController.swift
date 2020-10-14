//
//  DebugLogViewController.swift
//  XLog
//
//  Created by NamDV on 8/25/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit
import SwiftLog

private enum Constants {
    enum Dimensions {
        static let searchViewWidth = 255
        static let searchViewHeight = 50
    }
}

final class DebugLogViewController: UIViewController {
    
    @IBOutlet private weak var logTextView: UITextView!
    @IBOutlet private weak var settingView: UIView!
    @IBOutlet private weak var showAllLogSwitch: UISwitch!
    @IBOutlet private weak var showTimeSwitch: UISwitch!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var runMilestonePicker: UIPickerView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchViewHeight: NSLayoutConstraint!
    
    private var searchTextFields = [UITextField]()
    private var logText = ""
    private var isShowAllLog = false
    private var isShowTime = true
    private var runMilestones = [String]()
    private var logMilestones = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        showAllLogSwitch.addTarget(self, action: #selector(onShowAllLog), for: UIControl.Event.valueChanged)
        showTimeSwitch.addTarget(self, action: #selector(onShowTime), for: UIControl.Event.valueChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        splitLogs()
        showLog()
    }
    
    func setupNavigation() {
        navigationItem.title = "~ Log Info ~"
        let settingButton = UIBarButtonItem(
            title: "⚙️",
            style: .plain,
            target: self,
            action: #selector(setting(_:)))
        let shareButton = UIBarButtonItem(
            title: "🚀",
            style: .plain,
            target: self,
            action: #selector(shareLog(_:)))
        let deleteButton = UIBarButtonItem(
            title: "🗑",
            style: .plain,
            target: self,
            action: #selector(deleteLog(_:)))
        navigationItem.rightBarButtonItems = [deleteButton, shareButton, settingButton]
    }
    
    func splitLogs() {
        do {
            logText = try String(contentsOfFile: Log.logger.currentPath,
                                 encoding: .utf8)
        } catch let error as NSError {
            XLog.log(category: .app, type: .error, "read LogSwift fail - \(error)")
        }
        
        let logs = logText.components(separatedBy: "\n")
        runMilestones = logs.filter { $0.contains("✳️ Time") }
        runMilestones = runMilestones.map { $0.match("\\[(.*?)\\]").first?.first ?? "~" }
        if runMilestones.count <= 1 {
            logMilestones.append(logs)
            return
        }
        
        var currentMilestoneIndex = 1
        var currentLogIndex = 0
        for (index, log) in logs.enumerated() {
            if log.contains(runMilestones[currentMilestoneIndex]) {
                logMilestones.append(Array(logs[currentLogIndex..<index]))
                currentMilestoneIndex += 1
                currentLogIndex = index
                if currentMilestoneIndex == runMilestones.count {
                    logMilestones.append(Array(logs[currentLogIndex..<logs.count]))
                    break
                }
            }
        }
        runMilestonePicker.selectRow(runMilestones.count - 1, inComponent: 0, animated: false)
        searchTextFields.append(searchTextField)
    }
    
    func showLog() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        logTextView.attributedText = NSAttributedString(string: filterLog(),
                                                        attributes: [NSAttributedString.Key.paragraphStyle: style])
    }
    
    @objc
    func deleteLog(_ sender: Any?) {
        let confirmAlert = UIAlertController(title: "Delete log",
                                             message: "Do you want to delete all log?",
                                             preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            let filePath = Log.logger.currentPath
            do {
                let fileManager = FileManager.default
                // Check if file exists
                if fileManager.fileExists(atPath: filePath) {
                    // Delete file
                    try fileManager.removeItem(atPath: filePath)
                } else {
                    XLog.log(category: .app, type: .error, "File log delete not exist")
                }
            } catch let error as NSError {
                XLog.log(category: .app, type: .error, "Delete log fail - \(error)")
            }
            self.logText = ""
            self.logMilestones = []
            self.runMilestones = []
            self.runMilestonePicker.reloadAllComponents()
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmAlert, animated: true, completion: nil)
    }
    
    @objc
    func shareLog(_ sender: Any?) {
        let activityViewController = UIActivityViewController(activityItems: [logTextView.text ?? "nil"],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc
    func setting(_ sender: Any?) {
        view.endEditing(true)
        settingView.isHidden = !settingView.isHidden
        
        if settingView.isHidden {
            logTextView.text = filterLog()
        }
    }
    
    @objc
    func onShowAllLog(swt: UISwitch) {
        isShowAllLog = swt.isOn
    }
    
    @objc
    func onShowTime(swt: UISwitch) {
        isShowTime = swt.isOn
    }
    
    @IBAction private func addSearchView(_ sender: Any) {
        let searchViewFrameX = Int(UIScreen.main.bounds.width) - Constants.Dimensions.searchViewWidth
        let searchViewFrameY = searchTextFields.count * Constants.Dimensions.searchViewHeight
        let searchViewAdd = DebugLogSearchView(frame: CGRect(x: searchViewFrameX,
                                                             y: searchViewFrameY,
                                                             width: Constants.Dimensions.searchViewWidth,
                                                             height: Constants.Dimensions.searchViewHeight))
        searchViewAdd.delegate = self
        searchViewAdd.tag = searchTextFields.count
        searchView.addSubview(searchViewAdd)
        (view.viewWithTag(searchTextFields.count - 1) as? DebugLogSearchView)?.isHiddenDeleteBtn = true
        searchTextFields.append(searchViewAdd.getTextField())
        searchViewHeight.constant = CGFloat(searchTextFields.count * Constants.Dimensions.searchViewHeight)
    }
    
    func filterLog() -> String {
        var logs = logText.components(separatedBy: "\n")
        
        if !isShowAllLog {
            logs = logMilestones[runMilestonePicker.selectedRow(inComponent: 0), default: []]
        }
        
        if !isShowTime {
            logs = logs.map { $0.match("(?<=]: ).*$").first?.first ?? "~" }
        }
        
        let searchKeys = searchTextFields.compactMap { $0.text }.filter { !$0.isEmpty }
        if !(searchKeys.isEmpty) {
            logs = logs.filter { log in searchKeys.map { log.contains($0) }.allSatisfy { $0 } }
        }
        
        return logs.joined(separator: "\n")
    }
    
}

extension DebugLogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return runMilestones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return runMilestones[row]
    }
}

extension DebugLogViewController: DebugLogSearchViewDelegate {
    func didDeleteTextField(_ deleteView: BaseView) {
        deleteView.removeFromSuperview()
        searchTextFields.remove(at: deleteView.tag)
        (view.viewWithTag(searchTextFields.count - 1) as? DebugLogSearchView)?.isHiddenDeleteBtn = false
        searchViewHeight.constant = CGFloat(searchTextFields.count * Constants.Dimensions.searchViewHeight)
    }
}
