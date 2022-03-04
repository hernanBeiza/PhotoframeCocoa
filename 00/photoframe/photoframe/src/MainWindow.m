//
//  MainWindow.m
//  Photoframe
//
//  Created by Hernán Beiza on 11/28/13.
//  Copyright (c) 2013 Hiperactivo. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

//Sin borde
/*
- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag {
    
    // Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
        // Start with no transparency for all drawing into the window
        [self setAlphaValue:1.0];
        [self setBackgroundColor:[NSColor clearColor]];
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
    }
    return self;
}
*/

- (void)awakeFromNib
{
    NSLog(@"MainWindow awakeFromNib");
    /*
    NSView *base = (NSView*)self.contentView;
    [base setWantsLayer:YES];
    base.layer.borderWidth = 1.0;
    base.layer.cornerRadius = 8.0;
    base.layer.masksToBounds = YES;
    [base.layer setBackgroundColor:[NSColor redColor].CGColor];
     */
    
    NSString *rutaCarpeta = [[NSUserDefaults standardUserDefaults] valueForKey:PhotoframeCarpeta];
    if (rutaCarpeta) {
        [self leerCarpeta:[NSURL URLWithString:rutaCarpeta]];
    }
    
    [self center];
    //[self setBackgroundColor:[NSColor clearColor]];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    // Get the mouse location in window coordinates.
    _initialLocation = [theEvent locationInWindow];
}

/*
 Once the user starts dragging the mouse, move the window with it. The window has no title bar for
 the user to drag (so we have to implement dragging ourselves)
 */
- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
    
    // Get the mouse location in window coordinates.
    NSPoint currentLocation = [theEvent locationInWindow];
    // Update the origin with the difference between the new mouse location and the old mouse location.
    newOrigin.x += (currentLocation.x - _initialLocation.x);
    newOrigin.y += (currentLocation.y - _initialLocation.y);
    
    // Don't let window get dragged up under the menu bar
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    // Move the window to the new location
    [self setFrameOrigin:newOrigin];
}

- (IBAction)abrir:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // Configure your panel the way you want it
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    __block NSURL *rutaCarpeta = nil;
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL *carpeta in [panel URLs]) {
                NSLog(@"rutaCarpeta %@",carpeta);
                rutaCarpeta = carpeta;
            }
            if (rutaCarpeta) {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[rutaCarpeta absoluteString] forKey:PhotoframeCarpeta];
                [userDefaults synchronize];
                
                [self leerCarpeta:rutaCarpeta];
            }
        }
        
    }];
}

- (void)leerCarpeta:(NSURL*)rutaCarpeta
{
    
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    /*
     NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:rutaCarpeta
     includingPropertiesForKeys:@[ NSURLNameKey, NSURLIsDirectoryKey ]
     options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants
     errorHandler:nil];
     NSMutableArray *fileList = [NSMutableArray array];
     _rutasFotos = [[NSMutableArray alloc] init];
     for (NSURL *theURL in dirEnumerator) {
     NSNumber *isDirectory;
     [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
     if (![isDirectory boolValue]) {
     [fileList addObject:theURL];
     [_rutasFotos addObject:theURL];
     }
     }
     NSLog(@"%@",fileList);
     [self dibujar];
     */
    NSArray *dirContents = [fm contentsOfDirectoryAtURL:rutaCarpeta includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&err];
    NSArray *extensions = [NSArray arrayWithObjects:@"png",@"jpg",@"jpeg", nil];
    NSArray *filtradas = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
    //NSLog(@"%@",[[filtradas lastObject] class]);
    _rutasFotos = [[NSMutableArray alloc] init];
    for (NSURL *rutaArchivo in filtradas) {
        NSLog(@"%@",rutaArchivo);
        [_rutasFotos addObject:rutaArchivo];
    }
    [self dibujar];
}

- (void)dibujar
{
    NSMutableArray *popupChoices = [NSMutableArray arrayWithObjects:
                                    // Core Animation's four built-in transition types
                                    kCATransitionFade,
                                    kCATransitionMoveIn,
                                    kCATransitionPush,
                                    kCATransitionReveal,
                                    nil];
    
    NSArray *transitions = [CIFilter filterNamesInCategories:[NSArray arrayWithObject:kCICategoryTransition]];
    if (transitions.count > 0)
    {
        NSString *transition;
        for (transition in transitions)
            [popupChoices addObject:transition];
    }
    
    
    // pick the default transition
    _transitionStyle = [popupChoices objectAtIndex:0];
    [_slideshowView updateSubviewsWithTransition:_transitionStyle];
    
    //_fotos = [[NSMutableArray alloc] init];
    for (NSURL *rutaArchivo in _rutasFotos) {
        //NSImage *fotoImage = [[NSImage alloc] initWithContentsOfURL:rutaArchivo];
        //[_fotos addObject:fotoImage];
    }
    
    //iniciar
    _indiceActual = 0;
    
    //NSImage *inicialImage = [_fotos objectAtIndex:0];
    NSImage *inicialImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    [_slideshowView transitionToImage:inicialImage];
    
    if (!_pausaTimer) {
        _pausaTimer = [NSTimer scheduledTimerWithTimeInterval:0.1*60 target:self selector:@selector(timerComplete) userInfo:Nil repeats:YES];
    }
}

#pragma mark - Timer Functions
- (void)timerComplete
{
    NSLog(@"timerComplete %lu",_indiceActual);
    _indiceActual++;
    NSLog(@"timerComplete %lu",_indiceActual);
    
    if(_indiceActual>_fotos.count-1){
        _indiceActual = 0;
    }
    
    //random
    NSUInteger fromNumber = 0;
    NSUInteger toNumber = _rutasFotos.count-1;
    _indiceActual = (int)(arc4random()%(toNumber-fromNumber))+fromNumber;
    NSLog(@"timerComplete %lu",_indiceActual);
    
    NSImage *actualImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    //NSImage *actualImage = [_fotos objectAtIndex:_indiceActual];
    [_slideshowView transitionToImage:actualImage];
}
@end