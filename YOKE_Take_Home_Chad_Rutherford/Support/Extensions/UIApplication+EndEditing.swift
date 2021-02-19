//
//  UIApplication+EndEditing.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/11/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import UIKit

extension UIApplication {
    /// Func required to end editing for the Search Text View
    func endEditing(_ force: Bool) {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}
