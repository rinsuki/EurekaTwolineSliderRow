//  TwolineSliderRow.swift
//  Original by SliderRow.swift in Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//  (Modified by rinsuki, Copyright (c) 2020 rinsuki ( https://rinsuki.net ))
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Eureka

open class TwolineSliderCell: Cell<Float>, CellType {
    public let slider = UISlider()
    open var formatter: NumberFormatter?

    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self, selector: #selector(onContentSizeCategoryChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onContentSizeCategoryChanged() {
        if shouldShowTitle {
            setNeedsUpdateConstraints()
        }
    }

    open override func setup() {
        super.setup()
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)

        detailTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel?.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)
        detailTextLabel?.adjustsFontSizeToFitWidth = true
        detailTextLabel?.minimumScaleFactor = 0.5

        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)

        if shouldShowTitle {
            contentView.addSubview(textLabel!)
        }
        if !twolineSliderRow.shouldHideValue {
          contentView.addSubview(detailTextLabel!)
        }
        contentView.addSubview(slider)
        setNeedsUpdateConstraints()
        selectionStyle = .none
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    open override func update() {
        super.update()
        textLabel?.text = row.title
        textLabel?.isHidden = !shouldShowTitle
        detailTextLabel?.text = row.displayValueFor?(row.value)
        detailTextLabel?.isHidden = twolineSliderRow.shouldHideValue
        slider.value = row.value ?? slider.minimumValue
        slider.isEnabled = !row.isDisabled
        
    }

    @objc func valueChanged() {
        let roundedValue: Float
        let steps = Float(twolineSliderRow.steps)
        if steps > 0 {
            let stepValue = round((slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue) * steps)
            let stepAmount = (slider.maximumValue - slider.minimumValue) / steps
            roundedValue = stepValue * stepAmount + self.slider.minimumValue
        } else {
            roundedValue = slider.value
        }
        row.value = roundedValue
        row.updateCell()
    }

    var shouldShowTitle: Bool {
        return row?.title?.isEmpty == false
    }

    private var twolineSliderRow: TwolineSliderRow {
        return row as! TwolineSliderRow
    }
    
    open override func updateConstraints() {
        customConstraints()
        super.updateConstraints()
    }
    
    open var dynamicConstraints = [NSLayoutConstraint]()
    
    open func customConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints = []
        
        var views: [String : Any] = ["textLabel": textLabel!, "slider": slider, "detailTextLabel": detailTextLabel!]
        let metrics = ["spacing": 15.0]
        textLabel?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        detailTextLabel?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        let title = shouldShowTitle ? "[textLabel]-spacing" : ""
        let value = !twolineSliderRow.shouldHideValue ? "-[detailTextLabel]" : ""
        
        if let imageView = imageView, imageView.image != nil {
            views["imageView"] = imageView
            let hContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageView]-(15)-\(title)\(value)-|", options: .alignAllCenterY, metrics: metrics, views: views)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            dynamicConstraints.append(contentsOf: hContraints)
        } else {
            let hContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(title)\(value)-|", options: .alignAllCenterY, metrics: metrics, views: views)
            dynamicConstraints.append(contentsOf: hContraints)
        }
        dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[slider]-|", options: .alignAllCenterY, metrics: metrics, views: views))
        dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textLabel(==detailTextLabel)]-[slider]-|", options: [], metrics: metrics, views: views))
        contentView.addConstraints(dynamicConstraints)
    }

}

public final class TwolineSliderRow: Row<TwolineSliderCell>, RowType {

    public var steps: UInt = 20
    public var shouldHideValue = false

    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
