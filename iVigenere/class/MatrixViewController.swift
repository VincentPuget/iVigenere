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
    func matrixIsAvailable(_ isAvailable:Bool!) -> Void
}

class MatrixViewController: UIViewController {
  @IBOutlet weak var buttonValidate: UIButton!
  @IBOutlet weak var buttonCancel: UIButton!
  
  @IBOutlet weak var tfMatrixName: UITextField!
  @IBOutlet var tvMatrix: UITextView!
  
  
  var delegate:MatrixProtocol!
  
  var isNewMatrix:Bool! = true;
  var matrixObj:Matrix!;
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    
    self.view.backgroundColor = UIColor(colorLiteralRed: 69/255, green: 69/255, blue: 69/255, alpha: 1)
    self.tvMatrix.backgroundColor = UIColor(colorLiteralRed: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    self.tfMatrixName.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    
    self.tfMatrixName.textColor = UIColor.white
    self.tvMatrix.textColor = UIColor.white
    
    self.tfMatrixName.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("matrixName", tableName: "LocalizableStrings", comment: "Matrix name"), attributes:[NSForegroundColorAttributeName: UIColor.gray])
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
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
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
  
  @IBAction func IBA_buttonCancel(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: {})
  }
  
  @IBAction func IBA_buttonValidate(_ sender: AnyObject) {
    var saveIsOk = false;
    if(self.isNewMatrix == true)
    {
      saveIsOk = DataSingleton.instance.saveNewMatrix(self.tfMatrixName.text, matrix: self.tvMatrix.text)
    }
    else{
      saveIsOk = DataSingleton.instance.saveThisMatrix(self.matrixObj, name: self.tfMatrixName.text, matrix: self.tvMatrix.text)
    }
    
    self.delegate.matrixIsAvailable(saveIsOk)
    self.dismiss(animated: true, completion: {})
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
