//
//  ViewController.h
//  ScreenTimeRecorder
//
//  Created by Prajakta Kulkarni on 27/04/16.
//  Copyright © 2016 Sarang Kulkarni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSInteger onScreenTimeCounter;
    NSTimer *onScreenTimer;
}

-(void)StartSecondCounting;
-(void)endSecondCounting;
@end



