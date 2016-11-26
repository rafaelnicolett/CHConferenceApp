//
//  EventMainView.swift
//  CocoaheadsConf
//
//  Created by Bruno Bilescky on 25/11/16.
//  Copyright © 2016 Cocoaheads. All rights reserved.
//

import UIKit
import Compose

class EventMainView: CollectionStackView {

    var state: EventMainState = EventMainState() {
        didSet {
            self.container.state = ComposeEventView(with: state, twitterCallback: self.didTapTwitterCallback)
        }
    }

    var didTapTwitterCallback: ((EventModel)-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        container.lineSpace = 1
        self.container.alwaysBounceVertical = true
        self.backgroundColor = UIColor(hexString: "004D40")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

func ComposeEventView(with state: EventMainState, twitterCallback: ((EventModel)-> Void)?)-> [ComposingUnit] {
    var units: [ComposingUnit] = []
    guard let event = state.event else {
        return units
    }
    units.add {
        let headline = LabelUnit(id: "headline", text: event.headline, font: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), color: .white, verticalSpace: 16)
        let subline = LabelUnit(id: "subline", text: event.subline, font: UIFont.systemFont(ofSize: 15), color: .white, verticalSpace: 8)
        let mapUnit = MapLocationUnit(location: event.location)
        let dateUnit = EventDateUnit(event: event)
        let spaceForTwitter = ViewUnit<UIView>(id:"twitter-separator", traits:[.height(8)])
        let twitterUnit = EventFollowOnTwitterUnit(color: UIColor(hexString: "1abc9c"), twitter: event.twitterHandle) {
            twitterCallback?(event)
        }
        return [headline, subline, mapUnit, dateUnit, spaceForTwitter, twitterUnit]
    }
    return units
}