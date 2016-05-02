//
//  ViewController.m
//  ScreenTimeRecorder
//
//  Created by Prajakta Kulkarni on 27/04/16.
//  Copyright © 2016 Sarang Kulkarni. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "realmObjectClass.h"
#import <Realm/Realm.h>
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate >{
    
    BOOL isStartedAutomotive;
    NSInteger* tripID;
    NSInteger* tripIDCounter;
}

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) CMMotionActivityManager* motionActivityManager;
@property (strong, nonatomic) CMMotionActivity* motionActivity;
@property (weak, nonatomic) IBOutlet UILabel *onScreenTime;
@property (weak, nonatomic) IBOutlet UITextView *cordinates;

//@property (strong, nonatomic) CMMotionActivityHandler* activityHandler;

@end

@implementation ViewController

#pragma mark ViewController Delegates -
- (void)viewDidLoad {
    [super viewDidLoad];
    onScreenTimeCounter = 0;
    tripIDCounter = 1;
    // Do any additional setup after loading the view, typically from a nib.
    

    if ([CLLocationManager locationServicesEnabled]) {
    
    self.locationManager = [CLLocationManager new];
//    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
        
    }
    if ([CMMotionActivityManager isActivityAvailable]) {
        NSLog(@"YES");
    }
    else
    {
        NSLog(@"NO");
    }
    
    self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    
    [self.motionActivityManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMMotionActivity *activity){
        
        NSLog(@"Activity : %@", activity);
        isStartedAutomotive = activity.automotive;
        if (isStartedAutomotive) {
            tripID =  tripIDCounter;
            NSDictionary *tripDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Trip%zd",tripIDCounter],@"name",tripIDCounter,@"tripID", nil];
            [self storeTrip:tripDictionary];
        }
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endSecondCounting) name:UIApplicationWillResignActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartSecondCounting) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (onScreenTimer == nil) {
        onScreenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(StartSecondCounting) userInfo:nil repeats:YES];
    }
    
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self endSecondCounting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark On Screen Time Calculation -

-(void)StartSecondCounting
{
    if (onScreenTimer == nil) {
        onScreenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(StartSecondCounting) userInfo:nil repeats:YES];
    }
    onScreenTimeCounter++;
    self.onScreenTime.text = [NSString stringWithFormat:@"%ld seconds",(long)onScreenTimeCounter];
}
-(void)endSecondCounting
{
    if (onScreenTimer) {
        [onScreenTimer invalidate];
        onScreenTimer = nil;
    }

}

#pragma mark - location delegates

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D location;
    location.latitude = 1;
    location.longitude = 1;
    if (isStartedAutomotive) {
        //Storing coordinates.
        for (int i=0; i<locations.count; i++) {
            [self storeData:[locations objectAtIndex:i].coordinate.latitude :[locations objectAtIndex:i].coordinate.longitude];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"error : %@", error);
}

#pragma mark - Database functions

- (void) storeTrip:(NSDictionary *)tripDescription{
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    
    [realm transactionWithBlock:^{
        
        tripClass* tripObj =[[tripClass alloc] init];
        tripObj.tripName = [tripDescription valueForKey:@"name"];
        tripObj.tripID = (NSInteger*)[[tripDescription valueForKey:@"tripID"] integerValue];
        
        [tripClass createOrUpdateInDefaultRealmWithValue:tripObj];
    }error:nil];
    
}

- (void) storeData:(double)lattitude :(double)longitude{
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    
    [realm transactionWithBlock:^{
        
        coordinates* cordObj =[[coordinates alloc] init];
        cordObj.latValue = lattitude;
        cordObj.longValue = longitude;
        cordObj.tripID = tripID;
        cordObj.cordId = [NSString stringWithFormat:@"%f",cordObj.latValue+cordObj.longValue];
        
        [coordinates createOrUpdateInDefaultRealmWithValue:cordObj];
        
    }error:nil];
    
    
}

- (void)getData:(NSInteger *)tripID
{
    RLMResults* driveArray = [tripClass allObjects];
    
    RLMResults* coordinatesForTrip = [coordinates objectsWhere:@"tripID=%@", @"123173812"];
    
    NSLog(@"Drive : %@", driveArray);
    NSLog(@"cordinates : %@",coordinatesForTrip);
    
}

@end
