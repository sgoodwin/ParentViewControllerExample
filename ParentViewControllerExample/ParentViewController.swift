//
//  ViewController.swift
//  ParentViewControllerExample
//
//  Created by Samuel Goodwin on 2/26/15.
//  Copyright (c) 2015 Roundwall Software. All rights reserved.
//

import UIKit

@objc protocol ParentsWhoDoStuff {
    func weDidStuff()
}

@objc protocol ChildrenWhoTakeData {
    func setData(data: Data)
}

@objc class Data {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}

class ParentViewController: UIViewController, ParentsWhoDoStuff {
    // This controller's job is to make children, arrange them on the screen, and tell them to do things.
    let data = Data(text: "Some text that's very important")
    let graphs = [ChildViewController(), ChildViewController(), ChildViewController()]
    var currentGraph: ChildViewController?
    @IBOutlet var container: UIView!
    
    override func viewDidLoad() {
        self.storyboard?.instantiateViewControllerWithIdentifier("graph") as ChildViewController
        
        self.addGraph(graphs[0])
    }
    
    func addGraph(graphToReplace: ChildViewController){
        graphToReplace.willMoveToParentViewController(self)
        
        self.container.addSubview(graphToReplace.view)
        
        graphToReplace.view.frame = self.container.bounds
        
        self.addChildViewController(graphToReplace)
    }
    
    func weDidStuff() {
        let graphToReplace = graphs[1]
        
        currentGraph?.willMoveToParentViewController(nil)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.currentGraph?.view.removeFromSuperview()
            self.currentGraph?.removeFromParentViewController()
        
            self.addGraph(graphToReplace)
        })
    }
}

class ChildViewController :UIViewController, ChildrenWhoTakeData {
    // This controller's job is to get created, get arranged, and present it's information.
    // It expects it's parents to adhere to a protocol so that it can communicate back to parents.
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func doSomething(sender: UIButton?) {
        let parent = self.parentViewController as ParentsWhoDoStuff
        parent.weDidStuff()
    }
    
    func setData(data: Data) {
        textView.text = data.text
    }
}