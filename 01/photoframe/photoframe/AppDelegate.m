//
//  AppDelegate.m
//  Photoframe
//
//  Created by Hernán Beiza on 12/12/13.
//  Copyright (c) 2013 Hiperactivo. All rights reserved.
//

#import "AppDelegate.h"

#import "PhotoframeWindowController.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSArray *rutasCarpeta = [[NSUserDefaults standardUserDefaults] arrayForKey:PhotoframeCarpeta];
    NSArray *posiciones = [[NSUserDefaults standardUserDefaults] arrayForKey:PhotoframePosicion];
    NSArray *data = [[NSUserDefaults standardUserDefaults] arrayForKey:PhotoframeData];
    
    NSLog(@"rutasCarpeta %s, %@",__PRETTY_FUNCTION__,rutasCarpeta);
    NSLog(@"posiciones %s, %@",__PRETTY_FUNCTION__,posiciones);
    NSLog(@"data %s, %@",__PRETTY_FUNCTION__,data);
    
    if(!_ventanas) {
        _ventanas = [[NSMutableArray alloc] init];
    }
    
    for (int i =0; i<data.count; i++) {
        NSString *rutaSTR = [[data objectAtIndex:i] valueForKey:@"carpeta"];
        NSLog(@"rutaSTR %@",rutaSTR);
        NSString *posSTR = [[data objectAtIndex:i] valueForKey:@"posicion"];
        NSLog(@"posSTR %@",posSTR);
        PhotoframeWindowController *photoframeWindowController = [[PhotoframeWindowController alloc] init];
        [photoframeWindowController setMiRutaCarpeta:rutaSTR];
        [photoframeWindowController setTag:i];
        [photoframeWindowController showWindow:self];
        [_ventanas addObject:photoframeWindowController];
    }
    
    //Debug
    BOOL borrar = YES;
    if (borrar) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:PhotoframeCarpeta];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:PhotoframePosicion];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:PhotoframeData];
    }
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "cl.hiperactivo.Photoframe" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"cl.hiperactivo.Photoframe"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Photoframe" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Photoframe.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}


- (IBAction)nuevoPhotoframe:(id)sender
{
    NSLog(@"nuevoPhotoframe");
    if(!_ventanas) {
        _ventanas = [[NSMutableArray alloc] init];
    }
    PhotoframeWindowController *photoframeWindowController = [[PhotoframeWindowController alloc] init];
    [photoframeWindowController setTag:(int)(_ventanas.count)];
    [_ventanas addObject:photoframeWindowController];
    [photoframeWindowController showWindow:self];
}

- (IBAction)openFolder:(id)sender
{
    NSLog(@"openFolder");
    if (_ventanas ==nil) {
        NSWindow *activa = [[NSApplication sharedApplication] keyWindow];
        PhotoframeWindowController *windowController = (PhotoframeWindowController*)activa.windowController;
        [windowController abrir:nil];
        //[self nuevoPhotoframe:nil];
    }else{
        NSWindow *activa = [[NSApplication sharedApplication] keyWindow];
        PhotoframeWindowController *photoframeWindowController = (PhotoframeWindowController*)activa.windowController;
        [photoframeWindowController abrir:nil];
    }
}

- (IBAction)closePhotoframe:(id)sender
{
    NSLog(@"closePhotoframe");
    NSWindow *activa = [[NSApplication sharedApplication] keyWindow];
    PhotoframeWindowController *windowController = (PhotoframeWindowController*)activa.windowController;
    NSLog(@"PhotoframeWindowController activa %@",activa);
    NSLog(@"_ventanas %@",_ventanas);
    //Sacar del array
    [_ventanas removeObjectAtIndex:windowController.tag];
    NSLog(@"_ventanas %@",_ventanas);
    //Actualizar Valores
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [[NSUserDefaults standardUserDefaults] arrayForKey:PhotoframeData];
    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:data];
    NSLog(@"datas %@",datas);
    [datas removeObjectAtIndex:windowController.tag];
    NSLog(@"removeObjectAtIndex %@",datas);
    [userDefaults setObject:datas forKey:PhotoframeData];
    [userDefaults synchronize];
    [activa close];
    [windowController close];
    
    //Actualizar tags o id para que cuadren con la info guardada
    if(_ventanas.count>0){
        for (int i = 0; i<=_ventanas.count-1; i++) {
            NSLog(@"%i",i);
            PhotoframeWindowController *windowController = (PhotoframeWindowController*)[_ventanas objectAtIndex:i];
            [windowController setTag:i];
        }
    }
}

@end