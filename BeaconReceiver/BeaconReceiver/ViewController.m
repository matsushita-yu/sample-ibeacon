//
//  ViewController.m
//  BeaconReceiver
//
//  Created by Christopher Ching on 2013-11-28.
//  Copyright (c) 2013 AppCoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"com.appcoda.testregion"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// if enter the beacon area, it will be called.
- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    // We entered a region, now start looking for our target beacons!
    self.statusLabel.text = @"Finding beacons.";
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

// if exit the beacon area, it will be called.
-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
    self.statusLabel.text = @"None found.";
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}


// it will be called by didEnterRegion and didDetermineState
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    self.statusLabel.text = @"Beacon found!";
    
//    CLBeacon *foundBeacon = [beacons firstObject];
//    self.majorLabel.text = [NSString stringWithFormat:@"%@", foundBeacon.major];
//    self.minorLabel.text = [NSString stringWithFormat:@"%@", foundBeacon.minor];
    
    for (CLBeacon* clBeacon in beacons) {
    NSUUID* beaconUUID = clBeacon.proximityUUID;
    NSString *uuid= beaconUUID.UUIDString;
    NSString* proximityString = nil;
    switch (clBeacon.proximity)
    {
        case CLProximityUnknown:
            proximityString = @"Unknown";
            break;
        case CLProximityImmediate:
            proximityString = @"Immediate";
            break;
        case CLProximityNear:
            proximityString = @"Near";
            break;
        case CLProximityFar:
            proximityString = @"Far";
            break;
            
        default:
            break;
    }
    NSMutableString* messageString = [NSMutableString string];
    [messageString appendString:proximityString];
    
    NSString* workString = nil;
    [messageString appendString:@"\n"];
    [messageString appendString:@"uuid:"];
    [messageString appendString:uuid];
    [messageString appendString:@"\n"];
    [messageString appendString:@"major:"];
    [messageString appendString:[clBeacon.major stringValue]];
    [messageString appendString:@"\n"];
    [messageString appendString:@"minor:"];
    [messageString appendString:[clBeacon.minor stringValue]];
    [messageString appendString:@"\n"];
//    [messageString appendString:@"accuracy:"];
//    workString = [NSString stringWithFormat:@"%g", clBeacon.accuracy ];
//    [messageString appendString:workString];
//    [messageString appendString:@"\n"];
    [messageString appendString:@"rssi:"];
    workString = [NSString stringWithFormat:@"%ld", clBeacon.rssi ];
    [messageString appendString:workString];
    
//    NSLog(@"%@", messageString);
        self.majorLabel.text = messageString;
    }
}

// if already enter the beacon area, it will be called when starts up.
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    NSMutableString* messageString = [NSMutableString string];
    switch (state) {
        case CLRegionStateInside:
        {
            [messageString appendString:@"CLRegionStateInside"];
            CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
            break;
        case CLRegionStateOutside:
            [messageString appendString:@"CLRegionStateOutside"];
            break;
        case CLRegionStateUnknown:
            [messageString appendString:@"CLRegionStateUnknown"];
            break;
            
        default:
            break;
    }
    
    
    self.minorLabel.text = messageString;
}

@end
