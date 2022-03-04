//
//  MainWindow.h
//  Photoframe
//
//  Created by Hernán Beiza on 11/28/13.
//  Copyright (c) 2013 Hiperactivo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CAAnimation.h>  // for kCATransition<xxx> string constants
#import <QuartzCore/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

#import "SlideshowView.h"
//https://developer.apple.com/library/mac/samplecode/RoundTransparentWindow/Listings/Classes_CustomWindow_h.html#//apple_ref/doc/uid/DTS10000401-Classes_CustomWindow_h-DontLinkElementID_7
@interface MainWindow : NSWindow

@property (assign) NSPoint initialLocation;

@property (nonatomic, retain) IBOutlet SlideshowView *slideshowView;

@property (nonatomic,strong) NSMutableArray *rutasFotos;
@property (nonatomic,strong) NSMutableArray *fotos;

@property (nonatomic,strong) NSTimer *pausaTimer;
@property (nonatomic) NSUInteger indiceActual;

@property (nonatomic, copy) NSString *transitionStyle;

- (IBAction)abrir:(id)sender;

@end
