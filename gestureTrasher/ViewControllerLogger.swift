
	import UIKit


	class ViewControllerLogger: UIViewController
	{
	    private struct LogGlobals {
		   var prefix = ""
		   var instanceCounts = [String:Int]()
		   var lastLogTime = Date()
		   var indentationInterval : TimeInterval = 1
		   var indentaitonString = "__"
	    }

	    private static var logGlobals = LogGlobals()
	    private var instanceCount : Int! // PLaceholder for LogVC()

	    static func logPrefix(for loggingName : String ) -> String {
		   if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
			  logGlobals.prefix += logGlobals.indentaitonString
			  print("")
		   }
		   logGlobals.lastLogTime = Date()
		   return logGlobals.prefix + loggingName
	    }

		static func bumpInstanceCount(for loggingName : String ) -> Int {
		   logGlobals.instanceCounts[loggingName] = (logGlobals.instanceCounts[loggingName] ?? 0) + 1
		   return logGlobals.instanceCounts[loggingName]!
	    }


	    public var loggingNames : String {
		   return String(describing: type(of: self))
	    }

	    private func logVC(_ msg: String) -> String {
		   if instanceCount == nil {
			  instanceCount = ViewControllerLogger.bumpInstanceCount(for: loggingNames)
		   }
		   print(" \(ViewControllerLogger.logPrefix(for: loggingNames)) \(instanceCount!) \(msg)" )

		   return msg
	    }



	    // View Loggers
	    override func viewWillAppear(_ animated : Bool) {
		   super.viewWillAppear(animated)
		   let str = "[View WILL Appear] \(animated))"
		   let res = logVC(str)
		   print(res)
	    }
	    override func viewDidAppear(_ animated : Bool ) {
		   let str = "[View DID Appear] \(animated)"
		   let res = logVC(str)
		   print(res)

	    }
	    override func viewWillDisappear(_ animated: Bool) {
		   let str = ("[View WILL Dissapear] \(animated)")
		   let res = logVC(str)
		   print(res)

	    }
	    override func didReceiveMemoryWarning() {
		   super.didReceiveMemoryWarning()
		   let str = "[did ReceiveMemory Warning]"
		   let res = logVC(str)
		   print(res)

	    }

	    override func viewWillLayoutSubviews() {
		   super.viewWillLayoutSubviews()
		   let str = "[View WILL Layout Subviews]"
		   let res =  logVC(str)
		   print(res)

	    }

	    override func viewDidLayoutSubviews() {
		   super.viewWillLayoutSubviews()
		   let str = "[View DID Layout Subviews]"
		   let res = logVC(str)
		   print(res)
	    }

	    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		   super.viewWillTransition(to: size, with: coordinator)
		   let str = "[View Will Transition To : [\(size)] with :  [\(coordinator)] "
		   let res = logVC(str)
		   print(res)
		   coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
			  let str = "begin animate [alongside transition] completion handler "
			  let res = self.logVC(str)
			  print(res)

		   }, completion: ({ context -> Void in
			  let res = self.logVC("end of animation completion handler")
			  print(res)
		   })

		   )}
	}


	// MARK: Debugger #2 -> (NSLog("print error logging"))
	extension UIViewController {
	    func createLogFile() {
		   if let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
			  let fileName = "\(Date()).log"
			  let logFilePath = (documentsDirectory as NSString).appendingPathComponent(fileName)

			  freopen(logFilePath.cString(using: String.Encoding.ascii)!, "a+", stderr)
		   }
	    }
	}


