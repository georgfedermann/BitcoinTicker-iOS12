//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import Alamofire;
import SwiftyJSON;
import UIKit;

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC";
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"];
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"];
    var finalURL = "";
    var latestRate:Int = 0;
    var currentCurrency:String = "";
    var currentCurrencySymbol:String = "";
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self;
        currencyPicker.dataSource = self;
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    // we need one column in our PickerView
    func numberOfComponents(in pickerView: UIPickerView)->Int {
        return 1;
    }
    
    // we need as many rows as there are currencies available in the PickerView
    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return currencyArray.count;
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int)->String? {
        return currencyArray[row];
    }
    
    func pickerView(_ pickerView:UIPickerView, didSelectRow row:Int, inComponent component:Int) {
        print("\(row) -> \(currencyArray[row]).");
        currentCurrency = currencyArray[row];
        currentCurrencySymbol = currencySymbols[row];
        getBitcoinStats(targetCurrency:currentCurrency);
    }
    
    // MARK: - Networking
    /***************************************************************/
    func getBitcoinStats(targetCurrency:String){
        // this is asynchronous again. Thus, the view update has to be triggered
        // here, when it is known that the response has arrived.
        Alamofire.request("\(baseURL)\(targetCurrency)", method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got Bitcoin data.");
                self.updateBitcoinData(json:JSON(response.result.value!));
            } else {
                print("Error: \(response.result.error!)");
                self.bitcoinPriceLabel.text = "Connection Issues";
            }
        }
    }
    
    
    //    //MARK: - JSON Parsing
    //    /***************************************************************/
    func updateBitcoinData(json:JSON) {
        guard let rate = json["last"].double else {
            bitcoinPriceLabel.text = "Network Issues";
            return;
        }
        bitcoinPriceLabel.text = "\(currentCurrencySymbol) \(rate)";
    }

}

