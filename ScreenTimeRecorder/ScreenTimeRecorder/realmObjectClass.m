//
//  realmObjectClass.m
//  TestRealm
//
//  Created by Prateek Kansara on 01/05/16.
//  Copyright © 2016 Prateek. All rights reserved.
//

#import "realmObjectClass.h"

@implementation tripClass

+ (NSString *)primaryKey{
    return @"driveID";
}

@end

@implementation coordinates

+(NSString *)primaryKey{
    return @"cordId";
}

@end