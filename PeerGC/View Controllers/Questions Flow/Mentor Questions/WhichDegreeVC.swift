//
//  WhichDegreeVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class WhichDegreeVC: GenericStructureViewController {
    override func viewDidLoad() {
        genericStructureViewControllerMetadataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension WhichDegreeVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What kind of degree are you currently pursuing?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return FirstLanguageVC()
    }
}

extension WhichDegreeVC: ButtonsDelegate {
    func databaseIdentifier() -> String {
        return "whichDegree"
    }
    
    func buttons() -> [String] {
        return ["AA", "AA for transfer", "Bachelor of Art or Science", "Trade school degree", "Other"]
    }
}