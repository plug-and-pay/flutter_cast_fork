## [2.2.1]

* Connect to a device's IPv4 address when it has one. Bonsoir 7 lists addresses in arrival order, so an IPv6
  link-local address could come first and the connection would fail.

## [2.2.0]

* Upgrade dependency `bonsoir` to 7.x. Its iOS/macOS implementation builds under Swift Package Manager
  (6.x misses `import Foundation`), and it reports the IP address again next to the `.local` hostname.

## [2.1.0]

* Remove upper version limit for `bonsoir`

## [2.0.0]

* Upgrade dependency `bonsoir` to 3.0.0
* Upgrade to Dart 3

## [1.1.1]

* Upgrade dependency `bonsoir`

## [1.1.0]

* Replace dependency `multicast_dns` (not working on iOS) by `bonsoir`

## [1.0.0]

* Migrate to null safety
* Replace dependency `mdns_plugin` (doesn't support null safety) by `multicast_dns`

## [0.3.0]

* Add the possibility to use your own requestId

## [0.2.0]

* Improve service discovery #1

## [0.1.1]

* Add `kNamespaceMedia` to `CastSession`

## [0.1.0]

* First release
