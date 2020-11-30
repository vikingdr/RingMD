//
//  RateChooserViewController.swift
//  Ring
//
//  Created by RingMD on 08/10/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import UIKit

@objc protocol PickerViewControllerDelegate {
  func pickerViewController(pickerViewController: PickerViewController, didSelectTitles: [String], withTags: [AnyObject])
}

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  @IBOutlet private var pickerView: UIPickerView!;
  
  private var titles: ([[String]])!
  private var tags: ([[AnyObject]])!
  
  weak var delegate: PickerViewControllerDelegate?
  
  override init() {
    super.init(nibName: "PickerViewController", bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func configure(#titles: [[String]], tags: [[AnyObject]]) {
    assert(titles.count > 0)
    assert(titles.count == tags.count)
    self.titles = titles
    self.tags = tags
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    assert(self.titles != nil, "Please call configure() before loading this view")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.notifyDelegate()
  }
  
  func notifyDelegate() {
    let titles = (0..<self.titles.count).map({x in self.titles[x][self.pickerView.selectedRowInComponent(x)]})
    let tags = (0..<self.titles.count).map({x in self.tags[x][self.pickerView.selectedRowInComponent(x)]})
    self.delegate?.pickerViewController(self, didSelectTitles: titles, withTags: tags)
  }
  
  // MARK: UIPickerViewDataSource
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return titles.count
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return titles[component].count
  }
  
  // MARK: UIPickerViewDelegate
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return titles[component][row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.notifyDelegate()
  }
}
