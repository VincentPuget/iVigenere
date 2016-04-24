//
//  MainViewController.swift
//  Vigenere
//
//  Created by Vincent PUGET on 05/08/2015.
//  Copyright (c) 2015 Vincent PUGET. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

  @IBOutlet weak var buttonMatrix: UIButton!
  @IBOutlet weak var buttonCopy: UIButton!
  
  
  @IBOutlet weak var scCrypt: UISegmentedControl!
  
  @IBOutlet var tvInput: UITextView!
  @IBOutlet var tvOutput: UITextView!

  @IBOutlet weak var tfKey: UITextField!

  
  var engine:Engine!
  
  var textInput: String!
  var textKey: String!
  var isEncrypt: Bool! = true
  
  var firstEditingTvInput: Bool! = true;
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated);
    
    self.view.backgroundColor = UIColor(colorLiteralRed: 69/255, green: 69/255, blue: 69/255, alpha: 1)
    self.tvInput.backgroundColor = UIColor(colorLiteralRed: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    self.tvOutput.backgroundColor = UIColor(colorLiteralRed: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    self.tfKey.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    
    self.tvInput.textColor = UIColor.whiteColor()
    self.tvOutput.textColor = UIColor.whiteColor()
    self.tfKey.textColor = UIColor.whiteColor()
    
    self.tfKey.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("key", tableName: "LocalizableStrings", comment: "key"), attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
    
    
    self.tvInput.text = NSLocalizedString("textHere", tableName: "LocalizableStrings", comment: "textHere")
    self.tvOutput.text = ""
    
    self.scCrypt.setTitle(NSLocalizedString("encrypt", tableName: "LocalizableStrings", comment: "encrypt"), forSegmentAtIndex: 0)
    self.scCrypt.setTitle(NSLocalizedString("decrypt", tableName: "LocalizableStrings", comment: "decrypt"), forSegmentAtIndex: 1)
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    
    engine = Engine()
    engine.delegate = self;
    engine.startCreateMatrixProcess();
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tvInput.delegate = self
    self.tfKey.delegate = self
    
    
    self.tfKey.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
  
  override func prepareForSegue(segue:(UIStoryboardSegue!), sender: AnyObject!)
  {
    if (segue.identifier == "segue_MatrixViewController")
    {
      let matrixViewController:MatrixViewController! = segue.destinationViewController as! MatrixViewController;
      matrixViewController.delegate = self
    }//fin if
  }
  
  @IBAction func IBA_buttonCopy(sender: AnyObject) {
    let pasteboard = UIPasteboard.generalPasteboard()
    pasteboard.string = self.tvOutput.text
  }
  
  @IBAction func IBA_scCrypt(sender: AnyObject) {
    let scTmp:UISegmentedControl! = sender as! UISegmentedControl
    switch scTmp.selectedSegmentIndex
    {
    case 0:
      self.isEncrypt = true
      break;
    case 1:
      self.isEncrypt = false
      break;
    default:
      break;
    }
    
    engine.encryptOrDecrypt(self.tvInput.text, key: self.tfKey.text, isEncrypt: self.isEncrypt)
  }
}

extension MainViewController {
  
  func alertMatrixEmpty()
  {
    let alertController:UIAlertController! = UIAlertController(title: "iVigenere", message: NSLocalizedString("alertMatrixIsEmpty", tableName: "LocalizableStrings", comment: "alertMatrixIsEmpty"), preferredStyle: .Alert)
    let okAction:UIAlertAction! = UIAlertAction(title: NSLocalizedString("ok", tableName: "LocalizableStrings", comment: "ok"), style: UIAlertActionStyle.Default)
    {
      UIAlertAction in
      NSLog("OK Pressed")
      self.performSegueWithIdentifier("segue_MatrixViewController", sender: self)
    }
    
    let cancelAction:UIAlertAction! = UIAlertAction(title: NSLocalizedString("cancel", tableName: "LocalizableStrings", comment: "cancel"), style: UIAlertActionStyle.Default)
    {
      UIAlertAction in
      NSLog("cancel Pressed")
    }
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
  }
  
  func tfHandler(textField: UITextField){
    engine.encryptOrDecrypt(self.tvInput.text, key: self.tfKey.text , isEncrypt: self.isEncrypt)
  }
  func tvHandler(textView: UITextView){
    engine.encryptOrDecrypt(textView.text, key: self.tfKey.text , isEncrypt: self.isEncrypt)
  }
  
}

extension MainViewController:UITextFieldDelegate {
  func textDidChange(textField: UITextField) {
    self.tfHandler(textField)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    self.tfHandler(textField)
  }
}

extension MainViewController: UITextViewDelegate {
  func textViewDidChange(textView: UITextView)
  {
    self.tvHandler(textView)
  }
  func textViewDidEndEditing(textView: UITextView) {
    if(textView == self.tvInput && self.tvInput.text == ""){
      firstEditingTvInput = true
      self.tvInput.text = NSLocalizedString("textHere", tableName: "LocalizableStrings", comment: "textHere")
    }
  }
  func textViewDidBeginEditing(textView: UITextView) {
    if(textView == self.tvInput && firstEditingTvInput){
      firstEditingTvInput = false
      self.tvInput.text = ""
    }
  }
}

extension MainViewController: EngineProtocol{
  func matrixNotExist()
  {
    L.v("matrixIsEmpty");
    self.alertMatrixEmpty()
  }
  
  func matrixIsCreated()
  {
    //animate view ??
    //activate field ??
    //en loading ??
    engine.encryptOrDecrypt(self.tvInput.text, key: self.tfKey.text , isEncrypt: self.isEncrypt)
  }
  
  func outputUpdated(output:String!)
  {
    self.tvOutput.text = output
  }
}

extension MainViewController: MatrixProtocol {
    
  func matrixIsAvailable(isAvailable:Bool!) -> Void
  {
    if(isAvailable == true)
    {
      engine.startCreateMatrixProcess()
    }
  }
}