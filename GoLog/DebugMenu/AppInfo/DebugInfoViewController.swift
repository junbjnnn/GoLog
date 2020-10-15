//
//  DebugInfoViewController.swift
//  GoLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit
import SwiftLog

public final class DebugInfoViewController: UIViewController {
    
    private var infoTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        infoTextView.text = getAppInfo()
    }
    
    func setupViews() {
        navigationItem.title = "~ App Info ~"
        view.addSubview(infoTextView)
        NSLayoutConstraint.activate([
            infoTextView.topAnchor.constraint(equalTo: view.topAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getAppInfo() -> String {
        var info = ""
        info += "- Device Name : \(UIDevice.current.name)\n"
        info += "- MODEL : \(UIDevice.current.model)\n"
        info += "- Environment : \(GoLog.environment)\n"
        info += "- UUID : \(GoLog.uuidString)\n"
        if let dict = Bundle.main.infoDictionary {
            if let version = dict["CFBundleShortVersionString"] as? String,
                let bundleVersion = dict["CFBundleVersion"] as? String,
                let appName = dict["CFBundleName"] as? String {
                info += "- App Name : \(appName)\n"
                info += "- Version : \(version) (Build : \(bundleVersion))\n"
                info += "- Sub System : \(Bundle.main.bundleIdentifier ?? "?")\n"
            }
            
            if let commit = dict["BuildTime"] as? String {
                info += "- Build GIT INFO : \(commit)\n"
            }
        }
        info += "- Log path : \(Log.logger.currentPath)\n"
        info += XDebug.Configuration.debugAppInfoText
        
        return info
    }
    
}
