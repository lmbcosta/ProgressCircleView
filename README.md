# Progress Circle View

A Customizable progress circle bar with percentage label


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


## Requirements
* ARC
* iOS 9


### Installation

ProgressCircleView is available through [CocoaPods](https://cocoapods.org)
Simply add the follow line in your Podfile:
```ruby
pod 'ProgressCircleView', :git => 'https://github.com/lmbcosta/ProgressCircleView.git'
```


## Usage

Simply import and it+s ready to go!
 
 ```Swift
 import UIKit
 import ProgressCircleView

class ViewController: UIViewController {
    
    // UI
    @IBOutlet weak var myCircle: ProgressCircleView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup myCircle
        myCircle.strokeColor = .red
        myCircle.backgroundStrokeColor = .lightGray
        myCircle.labelSize = CGSize(width: 100, height: 80)
        myCircle.labelFont = UIFont.systemFont(ofSize: 40, weight: .medium)
        myCircle.startPercentage = 25
        myCircle.endPercentage = 87
        myCircle.lineWidthStroke = 14

        // Animating myCircle
        myCircle.animate(duration: 1.3, animated: true, animationType: .easeIn, counter: .int)
    }
}

 ```


## Authors

Luís Costa - lmbcosta@hotmail.com<br />
See also Brian Advent Youtube Channel (https://www.youtube.com/channel/UCysEngjfeIYapEER9K8aikw) where he shares how to create a counting label.

## License

This project is licensed under the MIT License - see the LICENSE file for details


