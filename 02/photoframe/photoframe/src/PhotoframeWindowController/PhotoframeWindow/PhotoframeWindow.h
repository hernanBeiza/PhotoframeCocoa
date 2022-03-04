//
//  PhotoframeWindow.h
//  Photoframe
//
//  Created by Hernán Beiza on 3/7/14.
//  Copyright (c) 2014 Hiperactivo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/CAAnimation.h>  // for kCATransition<xxx> string constants
#import <QuartzCore/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

#import "SlideshowView.h"

@interface PhotoframeWindow : NSWindow

@property (nonatomic) int tag;
@property (nonatomic,strong) NSString *miRutaCarpeta;

@property (nonatomic, retain) IBOutlet SlideshowView *slideshowView;

- (void)iniciarme;
@end