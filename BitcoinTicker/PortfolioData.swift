//
//  PortfolioData.swift
//  BitcoinTicker
//
//  Created by Rupert Waldron on 04/11/2017.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation

class Porfolio {
    var amountInvested : Double = 100
    var currentValue : Double = 110
    var gain : Double = 0
    var totalBitcoins : Double = 0
    
    func calculateGain() -> Double {
        gain = ((currentValue * totalBitcoins) / amountInvested - 1) * 100
        return gain
    }
}
