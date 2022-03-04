//
//  PhotoframeWindowController.m
//  Photoframe
//
//  Created by Hernán Beiza on 3/7/14.
//  Copyright (c) 2014 Hiperactivo. All rights reserved.
//

#import "PhotoframeWindowController.h"

#import "PhotoframeWindow.h"

@interface PhotoframeWindowController ()
@property (nonatomic,strong) NSMutableArray *rutasFotos;
@property (nonatomic,strong) NSMutableArray *fotos;
@property (nonatomic,strong) NSTimer *pausaTimer;
@property (nonatomic) NSUInteger indiceActual;
@property (nonatomic) NSInteger tiempo;
@end

@implementation PhotoframeWindowController

@synthesize tag;
@synthesize miRutaCarpeta;

- (id)init
{
    return [super initWithWindowNibName: @"PhotoframeWindowController"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"%s %i",__PRETTY_FUNCTION__,tag);
    PhotoframeWindow *photoframeWindow = (PhotoframeWindow*)self.window;
    [photoframeWindow setTag:tag];
    
    NSRect e = [[NSScreen mainScreen] frame];
    int ancho = (int)e.size.width;
    int alto = (int)e.size.height;
    
    int x = [self randomNumberFromNumber:0 toNumber:ancho-self.window.frame.size.width];
    int y = [self randomNumberFromNumber:0 toNumber:alto-self.window.frame.size.height];
    
    [self.window setFrame:NSRectFromCGRect(CGRectMake(x, y, self.window.frame.size.width, self.window.frame.size.height)) display:YES];
    [self iniciarme];
}

- (int)randomNumberFromNumber:(int)fromNumber toNumber:(int)toNumber
{
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    return randomNumber;
}

#pragma mark - Métodos WindowController
- (void)iniciarme
{
    NSLog(@"%s %i",__PRETTY_FUNCTION__,tag);

    PhotoframeWindow *photoframeWindow = (PhotoframeWindow*)self.window;
    [photoframeWindow iniciarme];
    /*
    if (miRutaCarpeta) {
        [self leerCarpeta:[NSURL URLWithString:miRutaCarpeta]];
    }else{
        [self abrir:nil];
    }
     */
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
                NSPoint newOrigin = self.window.frame.origin;
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
}


@end
