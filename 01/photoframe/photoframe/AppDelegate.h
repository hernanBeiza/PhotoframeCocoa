//
//  AppDelegate.h
//  Photoframe
//
//  Created by Hernán Beiza on 12/12/13.
//  Copyright (c) 2013 Hiperactivo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/CAAnimation.h>  // for kCATransition<xxx> string constants
#import <QuartzCore/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *ventanas;

- (IBAction)saveAction:(id)sender;

- (IBAction)nuevoPhotoframe:(id)sender;
- (IBAction)closePhotoframe:(id)sender;

@end
