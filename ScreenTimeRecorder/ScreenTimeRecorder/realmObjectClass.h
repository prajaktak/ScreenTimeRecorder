//
//  realmObjectClass.h
//  TestRealm
//
//  Created by Prateek Kansara on 01/05/16.
//  Copyright © 2016 Prateek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <CoreLocation/CoreLocation.h>

@interface tripClass : RLMObject

@property NSInteger* tripID;
@property NSString* tripName;

@end

@interface coordinates : RLMObject

@property NSString* cordId;
@property NSInteger* tripID;
@property double latValue;
@property double longValue;

@end

