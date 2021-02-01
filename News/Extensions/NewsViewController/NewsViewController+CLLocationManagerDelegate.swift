import Foundation
import CoreLocation

extension NewsViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.first {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placeMark, error in
                if let placeMark = placeMark {
                    var countryCode = placeMark.first?.isoCountryCode?.lowercased()
                    if countryCode == "by" {
                        countryCode = "ru"
                    }
                    NewsManager.shared.country = countryCode
                    NewsManager.shared.addParameters()
                    self.loadTopHeadlinesData()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
}
