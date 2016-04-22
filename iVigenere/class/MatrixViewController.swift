//
//  MainViewController.swift
//  Vigenere
//
//  Created by Vincent PUGET on 05/08/2015.
//  Copyright (c) 2015 Vincent PUGET. All rights reserved.
//

import UIKit

protocol MatrixProtocol
{
    func matrixIsAvailable(isAvailable:Bool!) -> Void
}

class MatrixViewController: UIViewController {
  @IBOutlet weak var buttonValidate: UIButton!
  @IBOutlet weak var buttonCancel: UIButton!
  
  @IBOutlet weak var tfMatrixName: UITextField!
  @IBOutlet var tvMatrix: UITextView!
  
  
  var delegate:MatrixProtocol!
  
  var isNewMatrix:Bool! = true;
  var matrixObj:Matrix!;
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated);
//    self.view.wantsLayer = true
//    self.view.layer?.backgroundColor = NSColor(calibratedRed: 69/255, green: 69/255, blue: 69/255, alpha: 1).CGColor
//    
//    self.viewBackground.layer?.backgroundColor = NSColor(calibratedRed: 35/255, green: 35/255, blue: 35/255, alpha: 1).CGColor
//    
//    self.tvMatrix.textColor = NSColor.whiteColor()
//    self.tvMatrix.insertionPointColor = NSColor.whiteColor()
//    
//    let color = NSColor.grayColor()
//    let attrs = [NSForegroundColorAttributeName: color]
//    let placeHolderStr = NSAttributedString(string: NSLocalizedString("matrixName", tableName: "LocalizableStrings", comment: "Matrix name"), attributes: attrs)
//    self.tfMatrixName.placeholderAttributedString = placeHolderStr
//    self.tfMatrixName.focusRingType = NSFocusRingType.None
//    let fieldEditor: NSTextView! = self.tfMatrixName.window?.fieldEditor(true, forObject: self.tfMatrixName) as! NSTextView
//    fieldEditor.insertionPointColor = NSColor.whiteColor()
//    
//    let pstyle = NSMutableParagraphStyle()
//    pstyle.alignment = NSTextAlignment.Center
//    self.buttonValidate.attributedTitle = NSAttributedString(string: NSLocalizedString("save", tableName: "LocalizableStrings", comment: "Save"), attributes: [ NSForegroundColorAttributeName : NSColor.whiteColor(), NSParagraphStyleAttributeName : pstyle ])
//    self.buttonCancel.attributedTitle = NSAttributedString(string: NSLocalizedString("cancel", tableName: "LocalizableStrings", comment: "Cancel"), attributes: [ NSForegroundColorAttributeName : NSColor.whiteColor(), NSParagraphStyleAttributeName : pstyle ])
//    
//    let widthConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 460)
//    self.view.addConstraint(widthConstraint)
//    
//    let heightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 260)
//    self.view.addConstraint(heightConstraint)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tvMatrix.delegate = self
    self.tfMatrixName.delegate = self
    
    matrixObj = DataSingleton.instance.getMatrixObject();
    
    if(matrixObj != nil)
    {
      self.isNewMatrix = false;
      self.tfMatrixName.text = matrixObj.name
      self.tvMatrix.text = matrixObj.matrix
    }
    else
    {
      self.isNewMatrix = true;
      self.tfMatrixName.text = ""
      self.tvMatrix.text = ""
    }
  }
  
  
  @IBAction func IBA_buttonCancel(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: {})
  }
  @IBAction func IBA_buttonValidate(sender: AnyObject) {
    var saveIsOk = false;
    if(self.isNewMatrix == true)
    {
      saveIsOk = DataSingleton.instance.saveNewMatrix(self.tfMatrixName.text, matrix: self.tvMatrix.text)
    }
    else{
      saveIsOk = DataSingleton.instance.saveThisMatrix(self.matrixObj, name: self.tfMatrixName.text, matrix: self.tvMatrix.text)
    }
    
    self.delegate.matrixIsAvailable(saveIsOk)
    self.dismissViewControllerAnimated(true, completion: {})
  }
}

extension MatrixViewController: UITextFieldDelegate {
//  override func controlTextDidChange(obj: NSNotification) {
//    
//  }
  
//  override func controlTextDidEndEditing(obj: NSNotification) {
//    
//  }
}

extension MatrixViewController: UITextViewDelegate {
//  func textDidChange(obj: NSNotification)
//  {
//    
//  }
}