//
//  PhotoframeWindow.m
//  Photoframe
//
//  Created by Hernán Beiza on 3/7/14.
//  Copyright (c) 2014 Hiperactivo. All rights reserved.
//

#import "PhotoframeWindow.h"

@interface PhotoframeWindow ()

@property (assign) NSPoint initialLocation;
@property (nonatomic, copy) NSString *transitionStyle;

@property (nonatomic,strong) NSMutableArray *rutasFotos;
@property (nonatomic,strong) NSMutableArray *fotos;
@property (nonatomic,strong) NSTimer *pausaTimer;
@property (nonatomic) NSUInteger indiceActual;
@property (nonatomic) NSInteger tiempo;

@end

@implementation PhotoframeWindow

@synthesize tag;
@synthesize miRutaCarpeta;

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (int)randomNumberFromNumber:(int)fromNumber toNumber:(int)toNumber
{
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    return randomNumber;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // Get the mouse location in window coordinates.
    _initialLocation = [theEvent locationInWindow];
}

/*
 Once the user starts dragging the mouse, move the window with it. The window has no title bar for
 the user to drag (so we have to implement dragging ourselves)
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
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

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"%s",__PRETTY_FUNCTION__);

    // Guardar Posiciones Ventanas
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:[userDefaults arrayForKey:PhotoframeData]];
    
    if(datas){
        if (tag < datas.count) {
            NSLog(@"existe");
            
            NSDictionary *infoOLD = [datas objectAtIndex:tag];
            NSLog(@"infoOLD %@",infoOLD);
            NSPoint newOrigin =self.frame.origin;
            NSString *posicion = [NSString stringWithFormat:@"%f,%f",newOrigin.x,newOrigin.y];
            NSDictionary *infoNEW = [NSDictionary dictionaryWithObjectsAndKeys:miRutaCarpeta,@"carpeta",posicion,@"posicion", nil];
            NSLog(@"infoNEW %@",infoNEW);
            if (datas.count!=0) {
                if([datas objectAtIndex:tag]) {
                    [datas replaceObjectAtIndex:tag withObject:infoNEW];
                }else{
                    [datas addObject:infoNEW];
                }
            }else{
                [datas addObject:infoNEW];
            }
            [userDefaults setObject:datas forKey:PhotoframeData];
            if([userDefaults synchronize]){
                NSLog(@"datas guardada");
            }
        }else{
            NSLog(@"no existe");
        }
    }
}
#pragma mark - iniciar
- (void)iniciarme
{
    NSLog(@"%s %i",__PRETTY_FUNCTION__,tag);
    NSLog(@"%s %@",__PRETTY_FUNCTION__,miRutaCarpeta);
    
    NSRect e = [[NSScreen mainScreen] frame];
    int ancho = (int)e.size.width;
    int alto = (int)e.size.height;
    
    int x = [self randomNumberFromNumber:0 toNumber:ancho-self.frame.size.width];
    int y = [self randomNumberFromNumber:0 toNumber:alto-self.frame.size.height];
    
    [self setFrame:NSRectFromCGRect(CGRectMake(x, y, self.frame.size.width, self.frame.size.height)) display:YES];
    
    if (miRutaCarpeta) {
        [self leerCarpeta:[NSURL URLWithString:miRutaCarpeta]];
    }else{
        [self abrir:nil];
    }
}

- (IBAction)abrir:(id)sender
{
    NSLog(@"abrir %i",tag);
    
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
                //NSLog(@"%s rutaCarpeta %@",__PRETTY_FUNCTION__,carpeta);
                rutaCarpeta = carpeta;
            }
            if (rutaCarpeta) {
                NSLog(@"rutaCarpeta %@",rutaCarpeta);
                miRutaCarpeta = [rutaCarpeta absoluteString];
                NSPoint newOrigin = self.frame.origin;
                NSString *posicion = [NSString stringWithFormat:@"%f,%f",newOrigin.x,newOrigin.y];
                NSDictionary *infoActual = [NSDictionary dictionaryWithObjectsAndKeys:[rutaCarpeta absoluteString],@"carpeta",posicion,@"posicion", nil];
                NSLog(@"infoActual %@",infoActual);
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:PhotoframeData]];
                NSLog(@"datas %@",datas);
                
                if (tag < datas.count) {
                    NSLog(@"existe");
                    if([datas objectAtIndex:tag]) {
                        [datas replaceObjectAtIndex:tag withObject:infoActual];
                    }else{
                        NSLog(@"no existe 1");
                        [datas addObject:infoActual];
                    }
                }else{
                    NSLog(@"no existe 2");
                    [datas addObject:infoActual];
                }
                
                NSLog(@"datas %@",datas);
                
                [userDefaults setObject:datas forKey:PhotoframeData];
                if([userDefaults synchronize]){
                    NSLog(@"datas guardada");
                };
                [self leerCarpeta:rutaCarpeta];
            }
        }
    }];
}

- (void)leerCarpeta:(NSURL*)rutaCarpeta
{
    NSLog(@"%s",__PRETTY_FUNCTION__);

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
        //NSLog(@"%@",rutaArchivo);
        [_rutasFotos addObject:rutaArchivo];
    }
    [self dibujar];
}

- (void)dibujar
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSMutableArray *popupChoices = [NSMutableArray arrayWithObjects:
                                    // Core Animation's four built-in transition types
                                    kCATransitionFade,
                                    kCATransitionMoveIn,
                                    kCATransitionPush,
                                    kCATransitionReveal,
                                    nil];
    
    NSArray *transitions = [CIFilter filterNamesInCategories:[NSArray arrayWithObject:kCICategoryTransition]];
    if (transitions.count > 0) {
        NSString *transition;
        for (transition in transitions)
            [popupChoices addObject:transition];
    }
    
    
    // pick the default transition
    _transitionStyle = [popupChoices objectAtIndex:0];
    [_slideshowView updateSubviewsWithTransition:_transitionStyle];
    
    //curSlide1 = YES;
    
    
    /*
     _fotos = [[NSMutableArray alloc] init];
     for (NSURL *rutaArchivo in _rutasFotos) {
     NSImage *fotoImage = [[NSImage alloc] initWithContentsOfURL:rutaArchivo];
     [_fotos addObject:fotoImage];
     }
     */
    //iniciar
    _indiceActual = 0;
    
    
    NSImage *inicialImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    [_slideshowView transitionToImage:inicialImage];
    
    _tiempo = 1;
    if (!_pausaTimer) {
        _pausaTimer = [NSTimer scheduledTimerWithTimeInterval:_tiempo*60 target:self selector:@selector(timerComplete) userInfo:Nil repeats:YES];
    }
    
    [self makeKeyWindow];
    
    //Posicionar
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:[userDefaults arrayForKey:PhotoframeData]];
    NSDictionary *miData = [data objectAtIndex:tag];
    
    NSString *posicion = [miData valueForKey:@"posicion"];
    if (posicion) {
        NSArray *punto = [posicion componentsSeparatedByString:@","];
        NSPoint newOrigin = NSMakePoint([[punto objectAtIndex:0] floatValue], [[punto objectAtIndex:1] floatValue]);
        [self setFrameOrigin:newOrigin];
    }
}

#pragma mark - Timer Functions
- (void)timerComplete
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //NSLog(@"timerComplete %lu",_indiceActual);
    _indiceActual++;
    //NSLog(@"timerComplete %lu",_indiceActual);
    
    if(_indiceActual>_rutasFotos.count-1){
        _indiceActual = 0;
    }
    
    //random
    NSUInteger fromNumber = 0;
    NSUInteger toNumber = _rutasFotos.count-1;
    _indiceActual = (arc4random()%(toNumber-fromNumber))+fromNumber;
    
    NSImage *actualImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    //NSImage *actualImage = [_fotos objectAtIndex:_indiceActual];
    [_slideshowView transitionToImage:actualImage];
}

@end
