//
//  AppDelegate.h
//  Photoframe
//
//  Created by Hernán Beiza on 11/28/13.
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

- (IBAction)newPhotoframeAction:(id)sender;

- (IBAction)saveAction:(id)sender;

@end
