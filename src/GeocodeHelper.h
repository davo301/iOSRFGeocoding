//
//  GeocodeHelper.h
//
//  Created by Davit Siradeghyan on 9/21/15.
//  Copyright © 2015 DavitSiradeghyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLPlacemark;
@class CLLocation;

@protocol GeocodeHelperDelegate <NSObject>

- (void)DidUpdatePlacemark:(CLPlacemark*)placemark;
- (void)DidReceivedLocationCoordinates:(CLLocation*)location;

@optional
- (void)DidUpdateLocations:(NSArray *)locations;
- (void)DidFailWithError:(NSError *)error;
- (void)DidFailedReverseGeocoding:(NSError *)error;
- (void)DidFailedForwardGeocoding:(NSError *)error;

@end

@interface GeocodeHelper : NSObject

@property (nonatomic, assign) id <GeocodeHelperDelegate> geocoderHelperDelegate;

#pragma mark - Static methods
+ (id)SharedManager;

#pragma mark - Public methods
- (id)init;

// Reverse geocoding.
// Reverse geocoding method is provided via
// GeocodeHelperDelegate's DidUpdatePlacemark method.

// Forward geocoding.
// Call this method with location name and get update about
// failed forward geocoding or location info in case of success
// via GeocodeHelperDelegate's DidReceivedLocationCoordinates method.
- (void)GetLocationCoordinates:(NSString*)locationName;

@end
