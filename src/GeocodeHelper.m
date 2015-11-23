//
//  GeocodeHelper.m
//
//  Created by Davit Siradeghyan on 9/21/15.
//  Copyright © 2015 DavitSiradeghyan. All rights reserved.
//

#import "GeocodeHelper.h"

@import CoreLocation;

@interface GeocodeHelper() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *m_locationManager;
@property (strong, nonatomic) CLLocation *m_location;

@end

@implementation GeocodeHelper

#pragma mark - Static methods
+ (id)SharedManager
{
    static GeocodeHelper *sharedGeocoderHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedGeocoderHelper = [[self alloc] init];
    });
    
    return sharedGeocoderHelper;
}

#pragma mark - GeocodeHelper methods implementation
- (id)init
{
    if ( self = [super init] ) {
        self.m_locationManager = [[CLLocationManager alloc] init];
        self.m_locationManager.delegate = self;
        self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Do this check as requestAlwaysAuthorization introduced in iOS8.
        if ([self.m_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.m_locationManager requestAlwaysAuthorization];
        }
        
        [self.m_locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)GetLocationCoordinates:(NSString*)locationName
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:locationName completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            [self.geocoderHelperDelegate DidFailedForwardGeocoding:error];
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            [self.geocoderHelperDelegate DidReceivedLocationCoordinates:placemark.location];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.m_location = [locations lastObject];
    
    [self.geocoderHelperDelegate DidUpdateLocations:locations];
    [self reverseGeocode:self.m_location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.geocoderHelperDelegate DidFailWithError:error];
}

#pragma mark - CLGeocoder method
- (void)reverseGeocode:(CLLocation *)location
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             [self.geocoderHelperDelegate DidFailedReverseGeocoding:error];
         } else {
             CLPlacemark *placemark = [placemarks lastObject];
             [self.geocoderHelperDelegate DidUpdatePlacemark:placemark];
         }
     }];
}

@end
