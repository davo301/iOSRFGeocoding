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

- (void)didUpdatePlacemark:(CLPlacemark*)placemark;
- (void)didReceivedLocationCoordinates:(CLLocation*)location;

@optional
- (void)didUpdateLocations:(NSArray *)locations;
- (void)didFailWithError:(NSError *)error;
- (void)didFailedReverseGeocoding:(NSError *)error;
- (void)didFailedForwardGeocoding:(NSError *)error;

@end

@interface GeocodeHelper : NSObject

@property (nonatomic, assign) id <GeocodeHelperDelegate> delegate;

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
- (void)getLocationCoordinates:(NSString*)locationName;

@end
