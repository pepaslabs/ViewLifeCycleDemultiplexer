# ViewLifeCycleDemultiplexer
Break up UIViewController's view lifecycle methods into more specific cases.

## Example usage

Here is a minimal `UIViewController` implementation which uses a `ViewLifeCycleDemultiplexer`:

```swift
import UIKit

class ViewController: UIViewController, ModalViewLifeCycleProtocol, NavigationViewLifeCycleProtocol
{
    let demux = ViewLifeCycleDemultiplexer()
    
    override func viewDidLoad()
    {
        demux.modalDelegate = self
        demux.navDelegate = self
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        demux.viewWillAppear(viewController: self, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        demux.viewDidAppear(viewController: self, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        demux.viewWillDisappear(viewController: self, animated: animated)
    }

    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        demux.viewDidDisappear(viewController: self, animated: animated)
    }
```

Now, you simply implement any of the desired protocol methods to have them called:

```swift
    func viewWillGetPresented(animated: Bool)
    {

    }
```

## License

This project is released under the terms of the [MIT License](https://opensource.org/licenses/MIT).
