//
//  AcmeButtons.swift
//  IncodeVerifyExample
//
//  Created by David Mendez on 12/11/24.
//

import UIKit

class AcmeButton: UIButton {

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    update()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    update()
  }

  override open func awakeFromNib() {
    super.awakeFromNib()
    update()
  }

  //MARK: - Listeners -
  override open var isHighlighted: Bool {
    didSet {
      update()
    }
  }

  override open var isSelected: Bool {
    didSet {
      update()
    }
  }

  override open var isEnabled: Bool {
    didSet {
      update()
    }
  }

  func textColor(forState state: State) -> UIColor {
    return UIColor.white
  }

  func backgroundColor(forState state: State) -> UIColor {
    return UIColor(red: 133.0/255.0, green: 49.0/255.0, blue: 239.0/255.0, alpha: 1.0)
  }

  func cornerRadius(forState state: UIControl.State) -> CGFloat {
    return 16.0
  }

  func shadow(forState state: UIControl.State) -> Bool {
    return true
  }

  func borderWidth(forState state: State) -> CGFloat {
    return 0.0
    // override
  }

  func borderColor(forState state: State) -> UIColor {
    return UIColor.clear
    // override
  }

  func update() {
    DispatchQueue.main.async {
      self.setTitleColor(self.textColor(forState: self.state), for: self.state)
      self.backgroundColor = self.backgroundColor(forState: self.state)
      self.layer.borderColor = self.borderColor(forState: self.state).cgColor
      self.layer.borderWidth = self.borderWidth(forState: self.state)
      self.layer.cornerRadius = self.cornerRadius(forState: self.state)
    }
  }
}

class AcmeSecondaryButton: AcmeButton {
  override func textColor(forState state: State) -> UIColor {
    return UIColor(red: 133.0/255.0, green: 49.0/255.0, blue: 239.0/255.0, alpha: 1.0)
  }

  override func backgroundColor(forState state: UIControl.State) -> UIColor {
    return  UIColor(red: 0.522, green: 0.192, blue: 0.937, alpha: 0.1)
  }
}
