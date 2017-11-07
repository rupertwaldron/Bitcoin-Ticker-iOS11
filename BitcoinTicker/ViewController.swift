import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var selectedCurrency : Int = 0
    let bitcoinPortfolio = Porfolio()
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var costOfBitcoins: UITextField!
    @IBOutlet weak var numberOfBitcoins: UITextField!
    @IBOutlet weak var totalPortfolioValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        // Removes keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //MARK: - Networking
    /***************************************************************/
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! Got price data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(json: bitcoinJSON)
                }
                else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateBitcoinData(json : JSON) {
        if let bitcoinPrice = json["last"].double {
            bitcoinPriceLabel.text = "\(currencySymbols[selectedCurrency])\(bitcoinPrice)"
            bitcoinPortfolio.currentValue = bitcoinPrice
            if let tempCostOfBitcoins = Double(costOfBitcoins.text!) {
                if tempCostOfBitcoins > 0 {
                    bitcoinPortfolio.amountInvested = tempCostOfBitcoins
                    if let tempNoOfBitcoins = Double(numberOfBitcoins.text!) {
                        if tempNoOfBitcoins > 0 {
                            bitcoinPortfolio.totalBitcoins = tempNoOfBitcoins
                            let gainString = String(format: "%.2f", bitcoinPortfolio.calculateGain())
                            gainLabel.text = gainString + "%"
                            let totalValueString = String(format: "%.2f", bitcoinPortfolio.calculateTotalPortfolioValue())
                            totalPortfolioValue.text = "\(currencySymbols[selectedCurrency])" + totalValueString
                        }
                        else {
                            gainLabel.text = "Gain"
                        }
                    }
                }
                else {
                    gainLabel.text = "Gain"
                }
            }
            
        }
        else {
            print("Problem with the price")
        }
    }
    //MARK: - Set up Picker View
    //    /***************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        selectedCurrency = row
        getBitcoinData(url: finalURL)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currencyArray[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.yellow])
        return attributedString
    }
    
    // used for removing keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

