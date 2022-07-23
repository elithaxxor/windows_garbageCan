	//
	//  ViewController.swift
	//  gestureTrasher
	//
	//  Created by a-robot on 7/22/22.
	//

import UIKit

@IBDesignable
class ViewController: ViewControllerLogger {
	
	@IBOutlet weak var trashCan : UIImageView!
	@IBOutlet weak var object2move : UIImageView!
	@IBOutlet weak var panImg : UIImageView!
	
	
//	@IBAction func animateBtn(_ sender: UIButton!) {
//		print("animate btn pressed")
//	}
	
	@IBAction func handlePanImg(recognizer: UIPanGestureRecognizer) {
		guard let recognizerView = recognizer.view else { return }
		let translation = recognizer.translation(in: view)
		recognizerView.center.x += translation.x
		recognizerView.center.y += translation.y
		recognizer.setTranslation(.zero, in: view)
		
		// guard recognizer.state == .end else { return }
		let velocity = recognizer.velocity(in: view)
		let bounds = UIEdgeInsets()
		
		// NOTE: May Have to change from recognizerView to recognizer
		
		var finalPoint = recognizerView.center
		var vectorToFinalPoint = CGPoint(x: velocity.x / 15, y: velocity.y / 15)
		var vectorToFinalPointX = vectorToFinalPoint.x * vectorToFinalPoint.x
		var vectorToFinalPointY = vectorToFinalPoint.y * vectorToFinalPoint.y

		finalPoint.x += vectorToFinalPointX
		finalPoint.y += vectorToFinalPointY
		finalPoint.x = min(max(finalPoint.x, bounds.left), bounds.top)
		finalPoint.y = min(max(finalPoint.y, bounds.left), bounds.top)
		
		UIView.animate(withDuration: TimeInterval(vectorToFinalPoint.x / 1800 ),
					delay: 0,
					options: .curveEaseOut, animations:{ recognizerView.center = finalPoint}
		)
		
		DispatchQueue.main.asyncAfter(deadline: .now()+3) {
			let animation = CABasicAnimation(keyPath: "position")
			animation.fromValue = CGPoint(x: self.panImg.center.x, y: self.panImg.center.y)
			animation.toValue = CGPoint(x: 300, y: 200)
			animation.duration = 2
			animation.fillMode = .forwards
			animation.beginTime = CACurrentMediaTime()
			//frame.add(animation, forKey: nil)
				//	animation.fromValue = CGPoint((x: self.panImg.center.x + self.panImg.center.y / 2 ), (y: self.panImg.center.y + self.panImg.center.x ))
		}
		
	}
	
	var objectOriginPoint: CGPoint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let timer = AppTimer()
		timer.setupTimer()
		NSLog("[LOGGING--> <START> [HOME VC]")
		setupView()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
	}
	
	private func setupView() {
		print("[!] Setting up homeVC! ")
		
		addPanGesture(view: object2move)
		addPanGesture(view: trashCan)
		addPinchGesture(view: object2move)
		addPinchGesture(view: trashCan)
		
		panImg.startAnimating()
		objectOriginPoint = object2move.frame.origin // set the origin point for frame
		view.bringSubviewToFront(object2move)
		view.bringSubviewToFront(trashCan)
		view.bringSubviewToFront(panImg)
		
		// MARK: Start of center btn animation 
		
		let centerX = view.center.x
		let centerY = view.center.y
		let centerBtn = UIButton(frame: CGRect(x: centerX, y: centerY, width: 200, height: 200 ))
		centerBtn.backgroundColor = .black
		centerBtn.setTitleColor(.white, for: .normal)
		centerBtn.setTitle("animate", for: .normal)
		
		centerBtn.addTarget(self, action: #selector(handleAnimation), for: .touchUpInside)
		view.bringSubviewToFront(centerBtn)
		
		
	}
	private func addPanGesture(view: UIView) {
		print("[!] Adding Pan Gesture! ")
		let pan = UIPanGestureRecognizer(target: self, action: #selector
								   (ViewController.handlePan(sender: )))
		
		view.addGestureRecognizer(pan)
		print("[+] Gesture Pan Added! ")
		handlePan(sender: pan)
		
	}
	
	private func addPinchGesture(view: UIView) {
		let pinchGesture = UIPanGestureRecognizer(target: self,
										  action: #selector(ViewController.handlePinch(_: )))
		
		let frame = view.frame
		view.addGestureRecognizer(pinchGesture)
		print("[!] Gesture Recognizer Added! \(pinchGesture)")
	}
	
	
	@objc private func handleAnimation() {
		UIView.animate(withDuration: 0.1, animations: {
			self.panImg.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
			self.panImg.center = self.view.center // sets animation pan at the center view.
		}, completion: { done in
			if done {
				print("[+] animation completion done, starting shrink")
				self.shrink()
			}
		})
	}
	
	private func shrink() {
		print("[!} Starting shrink function! ")
		UIView.animate(withDuration: 0.3, animations:  {
			self.panImg.frame = CGRect(x: 0, y:0, width: 200, height: 200)
			self.panImg.center = self.view.center
		}, completion: { done in
			self.handleAnimation()
		})
	}
	
	@objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
		print("[!] Handling pinch Gesture! ")
		if gesture.state == .changed {
			print("[!] Pinch Initiated! ")
			let scale = gesture.scale
			let frame = view.frame
			print(scale)
			
			view.frame = CGRect(x: 0,
							y: 0,
							width: frame.width * scale,
							height: frame.height * scale)
		}
		view.center = view.self.center
		
	}
	
	@objc private func handlePan(sender: UIPanGestureRecognizer) {
		print("[!] Handling Pan Gesture! ")
		let objView = sender.view!
		
		switch sender.state {
			case .possible, .began, .changed:
				print("[!] UIGesture began / changed ! ")
				moveWithPan(view: objView, sender: sender)
				
			case .ended: // For Collision
				print("[!] UIGesture is Ended.. ")
				if objView.frame.intersects(trashCan.frame) {
					print("[!] Object Collissin Detected! ")
					deleteView(view: objView)
				}
				else {
					returnView2Origin(view: objView)
				}
				
			case .cancelled:
				print("[-] UIGesture Cancelled. ")
			case .failed:
				print("[-] UIGesture is Failed. ")
				
			default:
				print("[-] Unknown default")
				break
		}
	}
	
	
	private func returnView2Origin(view: UIView) {
		print("[!] Return to origiginal view initiated")
		
		UIView.animate(withDuration: 0.3, animations: {
			view.frame.origin = self.objectOriginPoint
		})
		// TODO: Add Async and reload VC
		DispatchQueue.main.async {
			self.reloadInputViews()
		}
		NSLog("[LOGGING--> <END> [HOME VC]")
	}
	
	private func moveWithPan(view: UIView, sender: UIPanGestureRecognizer) {
		let velocity = sender.velocity(in: view)
		let translation = sender.translation(in: view)
		let bounds = UIEdgeInsets()
		let vectorToFinalPoint = CGPoint(x: velocity.x / 15, y: velocity.y / 15)
		
		
		let finalPoint = trashCan.center
		print("[!] Move With Pan Function Started!! 1.translation point, 2. bounds, 3. velocity 4. final point")
		print(translation)
		print(bounds)
		print(velocity)
		print(finalPoint)
		print(vectorToFinalPoint)
		view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
		sender.setTranslation(CGPoint.zero, in: view)
		print("[!] New Position.. ")
		print(sender.location(in: view))
		
	}
	private func deleteView(view: UIView) {
		print("[!] Delete View Initiated  ")
		UIView.animate(withDuration: 0.3, animations: {
			view.alpha = 0.0 // resets object to move
		})
	}
}





