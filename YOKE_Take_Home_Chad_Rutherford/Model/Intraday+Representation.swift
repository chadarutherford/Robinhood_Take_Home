//
//  Intraday+Representation.swift
//  YOKE_Take_Home_Chad_Rutherford
//
//  Created by Chad Rutherford on 2/16/21.
//  Copyright © 2021 Chad A. Rutherford. All rights reserved.
//

import CoreData
import Foundation

extension Intraday {
    var intraOpen: Double {
        return open
    }

    var intraClose: Double {
        return close
    }

    @discardableResult convenience init(open: Double, close: Double, context: NSManagedObjectContext = DataController.shared.mainContext) {
        self.init(context: context)
        self.open = open
        self.close = close
    }
}

extension Daily {
    var intraOpen: Double {
        return open
    }

    var intraClose: Double {
        return close
    }

    @discardableResult convenience init(open: Double, close: Double, context: NSManagedObjectContext = DataController.shared.mainContext) {
        self.init(context: context)
        self.open = open
        self.close = close
    }
}

extension Weekly {
    var intraOpen: Double {
        return open
    }

    var intraClose: Double {
        return close
    }

    @discardableResult convenience init(open: Double, close: Double, context: NSManagedObjectContext = DataController.shared.mainContext) {
        self.init(context: context)
        self.open = open
        self.close = close
    }
}

extension Monthly {
    var intraOpen: Double {
        return open
    }

    var intraClose: Double {
        return close
    }

    @discardableResult convenience init(open: Double, close: Double, context: NSManagedObjectContext = DataController.shared.mainContext) {
        self.init(context: context)
        self.open = open
        self.close = close
    }
}
