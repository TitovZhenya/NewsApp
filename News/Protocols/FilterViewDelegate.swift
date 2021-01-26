import UIKit

protocol FilterViewDelegate: class {
    func filterViewShouldDisplay(_ view: FilterViewController, name: String, id: String?, filterTitle: String)
}
