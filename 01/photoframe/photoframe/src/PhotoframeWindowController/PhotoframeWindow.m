//
//  HBWindow.m
//  Photoframe
//
//  Created by Hernán Beiza on 3/3/14.
//  Copyright (c) 2014 Hiperactivo. All rights reserved.
//

#import "PhotoframeWindow.h"

@implementation PhotoframeWindow
@synthesize tag;
@synthesize miRutaCarpeta;

- (void)awakeFromNib
{
    //[self setTag:0];
    NSLog(@"%s %i", __PRETTY_FUNCTION__,tag);
    //[self leerCarpeta:[NSURL URLWithString:@"file:///Users/hernanbeiza/Dropbox/Photos/Anime/Mirai%20Nikki/Minene%20Uryu/"]];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}
/*
- (void)leerCarpeta:(NSURL*)rutaCarpeta
{
    NSLog(@"leerCarpeta %i %@",tag,rutaCarpeta);
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
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
    if (transitions.count > 0) {
        NSString *transition;
        for (transition in transitions)
            [popupChoices addObject:transition];
    }
    
    // pick the default transition
    _transitionStyle = [popupChoices objectAtIndex:0];
    [_slideshowView updateSubviewsWithTransition:_transitionStyle];
    
    //iniciar
    _indiceActual = 0;
    
    NSImage *inicialImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    [_slideshowView transitionToImage:inicialImage];
    
    _tiempo = 1;
    if (!_pausaTimer) {
        _pausaTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerComplete) userInfo:nil repeats:YES];
    }
    
    [self makeKeyWindow];
    
    //Posicionar
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:[userDefaults arrayForKey:PhotoframeData]];
    if(data.count< tag){
        NSDictionary *miData = [data objectAtIndex:tag];
        
        NSString *posicion = [miData valueForKey:@"posicion"];
        if (posicion) {
            NSArray *punto = [posicion componentsSeparatedByString:@","];
            NSPoint newOrigin = NSMakePoint([[punto objectAtIndex:0] floatValue], [[punto objectAtIndex:1] floatValue]);
            [self setFrameOrigin:newOrigin];
        }
    }
}

#pragma mark - Timer Functions
- (void)timerComplete
{
    //NSLog(@"timerComplete %lu",_indiceActual);
    _indiceActual++;
    //NSLog(@"timerComplete %lu",_indiceActual);
    
    if(_indiceActual>_rutasFotos.count-1){
        _indiceActual = 0;
    }
    
    //random
    NSUInteger fromNumber = 0;
    NSUInteger toNumber = _rutasFotos.count-1;
    _indiceActual = (int)(arc4random()%(toNumber-fromNumber))+fromNumber;
    
    NSImage *actualImage = [[NSImage alloc] initWithContentsOfURL:[_rutasFotos objectAtIndex:_indiceActual]];
    //NSImage *actualImage = [_fotos objectAtIndex:_indiceActual];
    [_slideshowView transitionToImage:actualImage];
}
 */
@end