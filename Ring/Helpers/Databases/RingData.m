//
//  RingData.m
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import "RingData.h"

#import "Ring-Essentials.h"

@implementation RingData

- (id)init
{
  self = [super init];
  if (self) {
    [self initManagedObjectModel];
    [self initPersistentStoreCoordinator];
    [self initManagedObjectContext];
  }
  return self;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (!_persistentStoreCoordinator) {
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  }
  return _persistentStoreCoordinator;
}

- (void)initManagedObjectModel
{
  NSURL *uModelURL = [[NSBundle mainBundle] URLForResource:@"RingUserData" withExtension:@"momd"];
  NSManagedObjectModel* uModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:uModelURL];
  
  NSURL *pdModelURL = [[NSBundle mainBundle] URLForResource:@"RingDatabase" withExtension:@"momd"];
  NSManagedObjectModel* pdModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:pdModelURL];
  
  _managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:uModel, pdModel, nil]];
}

- (void)initPersistentStoreCoordinator
{
  NSError *error = nil;
  [self addSeedDataToCoordinator:self.persistentStoreCoordinator];
  if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:@"MainConf" URL:nil options:nil error:&error]) {
    NSLog(@"Database error while initializing persistent core coordinator: %@", error);
  }
}

- (void) addSeedDataToCoordinator:(NSPersistentStoreCoordinator *)storeCoordinator
{
  NSError *error = nil;
  NSURL *storeURL = [[RingUtility applicationDocumentsDirectory] URLByAppendingPathComponent:@"authUser1.23.sqlite"];
  
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"AuthUserConf" URL:storeURL options:nil error:&error];
    if(error) {
      if([[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[storeURL path]
                                                   error:&error];
        NSLog(@"On-disk database is corrupt (deleting...)");
        if(error== nil) {
          NSLog(@"Something went wrong while attempting to delete the on-disk database: %@", error);
          exit(1);
        }
        NSLog(@"Retrying...");
        [self addSeedDataToCoordinator:storeCoordinator];
      } else {
        NSLog(@"Database error while mounting the (non-existing) login data: %@", error);
        exit(1);
      }
    } else {
      NSLog(@"On-disk database loaded");
    }
}

- (void)initManagedObjectContext
{
  self.managedObjectContext = [[NSManagedObjectContext alloc] init];
  [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      NSLog(@"Database error while saving the object context: %@", error);
    }
  }
}

+ (RingData *)sharedInstance
{
  // structure used to test whether the block has completed or not
  static dispatch_once_t p = 0;
  
  // initialize sharedObject as nil (first call only)
  __strong static id _sharedObject = nil;
  
  // executes a block object once and only once for the lifetime of an application
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });
  
  // returns the same object each time
  return _sharedObject;
}

+ (NSFetchRequest *)getFetchRequest:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKeys:(NSDictionary *)keys
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
  if (predicateString)
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString argumentArray:arguments]];
  if (keys){
    NSMutableArray *sortDescriptions = [[NSMutableArray alloc] initWithCapacity:keys.count];
    for (NSString *key in keys) {
      [sortDescriptions addObject:[[NSSortDescriptor alloc] initWithKey:key ascending:[(NSNumber *)([keys objectForKey:key]) boolValue]]];
    }
    [fetchRequest setSortDescriptors:sortDescriptions];
  }
  return fetchRequest;
}

- (NSArray *)findEntities:(NSString *)entityName
      withPredicateString:(NSString *)predicateString
             andArguments:(NSArray *)arguments
  withSortDescriptionKeys:(NSDictionary *)sortKeys {
  NSFetchRequest *fetchRequest = [RingData getFetchRequest:entityName withPredicateString:predicateString andArguments:arguments withSortDescriptionKeys:sortKeys];
  return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (NSManagedObject *)findSingleEntity:(NSString *)entityName
                  withPredicateString:(NSString *)predicateString
                         andArguments:(NSArray *)arguments
               withSortDescriptionKey:(NSDictionary *)sortKeys {
  NSArray *array = [self findEntities:entityName withPredicateString:predicateString andArguments:arguments withSortDescriptionKeys:sortKeys];
  if (array && array.count > 0)
    return [array lastObject];
  return nil;
}

- (NSArray *)findEntities:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKeys:(NSDictionary *)sortKeys andPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize
{
  NSFetchRequest *fetchRequest = [RingData getFetchRequest:entityName withPredicateString:predicateString andArguments:arguments withSortDescriptionKeys:sortKeys];
  fetchRequest.fetchOffset = 0;
  fetchRequest.fetchLimit = (pageIndex + 1) * pageSize;
  return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)removeEntity:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKey:(NSDictionary *)sortKeys {
  NSManagedObject *object = [self findSingleEntity:entityName withPredicateString:predicateString andArguments:arguments withSortDescriptionKey:sortKeys];
  [self.managedObjectContext deleteObject:object];
}

- (void)deleteObjects:(id)objects
{
  for (NSManagedObject *object in objects) {
    [self.managedObjectContext deleteObject:object];
  }
}

- (void)resetDatabase
{
  NSInteger count = [[self.persistentStoreCoordinator persistentStores] count];
  for (NSInteger i = 0; i < count; ++i) {
    NSPersistentStore *currentPersistenceStore = [[self.persistentStoreCoordinator persistentStores] lastObject];
    [self.managedObjectContext lock];
    [self.managedObjectContext reset];
    NSURL *storeURL = [self.persistentStoreCoordinator URLForPersistentStore: currentPersistenceStore];
    if ([self.persistentStoreCoordinator removePersistentStore:currentPersistenceStore error:nil]) {
      NSLog(@"Unmounted a database store");
      if ([currentPersistenceStore.type isEqualToString:NSSQLiteStoreType]) {
        NSLog(@"Removing on-disk database %@", storeURL.filePathURL.path);
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
      }
    }
    [self.managedObjectContext unlock];
  }
  [self initPersistentStoreCoordinator];
}

@end
