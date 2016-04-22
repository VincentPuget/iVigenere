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
  
  
  @IBOutlet weak var scCrypt: UISegmentedControl!
  
  @IBOutlet var tvInput: UITextView!
  @IBOutlet var tvOutput: UITextView!

  @IBOutlet weak var tfKey: UITextField!

  
  var engine:Engine!
  
  var textInput: String!
  var textKey: String!
  var isEncrypt: Bool! = true
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated);
    
    
    
    engine = Engine()
    engine.delegate = self;
    engine.startCreateMatrixProcess();
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tvInput.delegate = self
    self.tfKey.delegate = self
    
    self.tvInput.text = NSLocalizedString("textHere", tableName: "LocalizableStrings", comment: "textHere")
    self.tvOutput.text = ""
    
    self.tvInput.becomeFirstResponder()
    
    self.tfKey.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
  }
  
  override func prepareForSegue(segue:(UIStoryboardSegue!), sender: AnyObject!)
  {
    if (segue.identifier == "segue_MatrixViewController")
    {
      let matrixViewController:MatrixViewController! = segue.destinationViewController as! MatrixViewController;
      matrixViewController.delegate = self
    }//fin if
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
//    let alert: UIAlert = NSAlert()
//    alert.messageText = NSLocalizedString("alertMatrixIsEmpty", tableName: "LocalizableStrings", comment: "alertMatrixIsEmpty")
//    alert.informativeText = "Vigenere"
//    alert.alertStyle = UIAlertStyle.WarningAlertStyle
//    alert.addButtonWithTitle(NSLocalizedString("ok", tableName: "LocalizableStrings", comment: "ok"))
//    alert.addButtonWithTitle(NSLocalizedString("cancel", tableName: "LocalizableStrings", comment: "cancel"))
//    let response = alert.runModal()
//    
//    if(response == NSAlertFirstButtonReturn)
//    {
//      self.performSegueWithIdentifier("segue_MatrixViewController", sender: self)
//    }
//    else if(response == NSAlertSecondButtonReturn)
//    {
//      NSLog("Annuler")
//    }
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
    L.v(output);
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