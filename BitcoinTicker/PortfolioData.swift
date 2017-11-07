import Foundation

class Porfolio {
    var amountInvested : Double = 100
    var currentValue : Double = 110
    var gain : Double = 0
    var totalBitcoins : Double = 0
    var totalPortfolioValue : Double = 0
    
    func calculateGain() -> Double {
        gain = ((currentValue * totalBitcoins) / amountInvested - 1) * 100
        return gain
    }
    
    func calculateTotalPortfolioValue() -> Double {
        totalPortfolioValue = totalBitcoins * currentValue
        return totalPortfolioValue
    }
}
