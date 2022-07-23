	//
	//  Extensions.swift
	//  gestureTrasher
	//
	//  Created by a-robot on 7/22/22.
	//


import Foundation
import UIKit


	// MARK: Convert Int to String- Date/Time format
extension Int {
	var formatIntToDateTime: String {
		let(h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
		
		let h_string = h < 10 ? "0\(h)" : "0\(h)"
		let m_string = m < 10 ? "0\(m)" : "0\(m)"
		let s_string = s < 10 ? "0\(s)" : "0\(s)"
		return "\(h_string):\(m_string):\(s_string)"
	}
}



	//MARK:  [UIColor ] Specificing Red / Green hexColors for
extension UIColor {
	static let losingRed = UIColor("fae2e1")
	static let winningGreen = UIColor("b0f1dd")
	
	convenience init(_ hex: String, alpha: CGFloat = 1.0) {
		var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if(cString.hasPrefix("#")) { cString.removeFirst() }
		
		if ((cString.count) != 6) {
			self.init("ff0000")
			return
		}
		
		var rgbValue: UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)
		
		self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
				green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
				blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
				alpha: alpha)
	}
}





	// MARK: To convert Double to String with two decimal places && Formats Double to Currency (String)
extension Double {
	var string2doublePlaceholder2: String  {
		return String(describing: self)
	}
	var twoDecimalPlaceholder : String {
		return String(format: "%.2f", self)
	}
	var formatDouble2Currency : String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		
		if let val = formatter.string(from: self as NSNumber) {
			return val
		}
		return twoDecimalPlaceholder
	}
	
		// MARK: Converts Double to A Percent (String) w/ Two decimal placeholders
	var convertDouble2StrPercent : String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 2
		return formatter.string(from: self as NSNumber) ?? self.convertDouble2StrPercent
	}
	
		// MARK: Function that checks for dollar symbol, and decimal placeholders; if true, then reset
	func removeSymbolandDecimal(hasSymbol: Bool = true, hasDecimalHolder: Bool = true) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		if hasSymbol == false {
			formatter.currencySymbol = ""
		}
		if hasDecimalHolder == false {
			formatter.maximumFractionDigits = 0
		}
		return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceholder
	}
	
}




	// MARK: To extend INT to Float [floatVal]
extension Int {
	var floatVal : Float {
		return Float(self)
	}
}


	// MARK: TO Convert Int to Double
extension Int {
	var convertInt2Double : Double {
		return Double(self)
	}
}

	// MARK: Convert Double to Percent (2 decimal placeholders)


	// MARK: Convert Double to String
extension Double {
	var convertDouble2String : String {
		return String(describing: self)
	}
}

	// MARK: Convert String to Double
extension String {
	var convertString2Double : Double {
		return Double(self) ?? 0
	}
}

	// MARK: Extension [date to string]
extension Date {
	var dateFormatter : String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		return dateFormatter.string(from: self)
	}
}

	// MARK: TO add Brackets to string
extension String {
	func addBrackets() -> String {
		return "(\(self))"
	}
}
	//MARK: Navcon extension : UIViewController



	// MARK: Extensions for random Int and Double
extension Int {
	var randomInt: Int {
		if self > 0 {
			return Int(arc4random_uniform(UInt32(self)))
		} else if self < 0 {
			return -Int(arc4random_uniform(UInt32(abs(self))))
		} else {
			return 0
		}
	}
}
extension Double {
	var randomDouble: Double {
		if self > 0 {
			return Double(arc4random_uniform(UInt32(self)))
		} else if self < 0 {
			return -Double(arc4random_uniform(UInt32(abs(self))))
		} else {
			return 0
		}
	}
}


	// MARK: Populates done button for user in text fields
extension UITextField {
	func addDoneBtn () {
		let screenWidth = UIScreen.main.bounds.width
		let doneToolBar = UIToolbar(frame: .init(x: 0, y:0, width: screenWidth, height: 50 ))
		doneToolBar.barStyle = .default
		let flexBarBtnItem = UIBarButtonItem(barButtonSystemItem : .flexibleSpace, target : nil, action : nil )
		let doneBarItem = UIBarButtonItem(title : "Done", style: .done, target: self, action: #selector(dismissKeyboard))
		
		let items = [flexBarBtnItem, doneBarItem]
		doneToolBar.items = items
		
		doneToolBar.sizeToFit()
		inputAccessoryView = doneToolBar
	}
	
	@objc private func dismissKeyboard() {
		resignFirstResponder()
		
	}
}


// MARK: Random Int / CGFloat / Double extensions
extension CGFloat {
	var arc4random: CGFloat {
		if self > 0 {
			return CGFloat(arc4random_uniform(UInt32(self)))
		} else if self < 0 {
			return -CGFloat(arc4random_uniform(UInt32(abs(self))))
		} else {
			return 0
		}
	}
	var CGPoint2CGFloat : CGFloat {
		return CGFloat(self)
	}
}

extension CGPoint {
	var CGFloat2CGPointX : CGFloat {
		var pointX = CGFloat(self.x)
		return pointX
	}
	var cgFloat2CGPointY : CGFloat {
			var pointY = CGFloat(self.y)
			return pointY
		}
//	var CGPoint2IntX : CGPoint {
//		var cgPointIntX = Int(self.x)
//		return cgPointIntX
//	}
//	
//	var CGPoInt2IntY : CGPoint {
//		var cgPointIntY = Int(self.y)
//		return cgPointIntY
//	}
}

