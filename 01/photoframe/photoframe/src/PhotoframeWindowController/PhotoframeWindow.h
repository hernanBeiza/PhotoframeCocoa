//
//  HBWindow.h
//  Photoframe
//
//  Created by Hernán Beiza on 3/3/14.
//  Copyright (c) 2014 Hiperactivo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SlideshowView.h"
#import <QuartzCore/CAAnimation.h>  // for kCATransition<xxx> string constants
#import <QuartzCore/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@interface PhotoframeWindow : NSWindow

@property (nonatomic) int tag;
@property (nonatomic,strong) NSString *miRutaCarpeta;
/*
@property (nonatomic, retain) IBOutlet SlideshowView *slideshowView;

@property (assign) NSPoint initialLocation;
@property (nonatomic, copy) NSString *transitionStyle;

@property (nonatomic,strong) NSMutableArray *rutasFotos;
@property (nonatomic,strong) NSMutableArray *fotos;

@property (nonatomic,strong) NSTimer *pausaTimer;
@property (nonatomic) NSUInteger indiceActual;
@property (nonatomic) NSInteger tiempo;

- (void)leerCarpeta:(NSURL*)rutaCarpeta;
 */
@end
