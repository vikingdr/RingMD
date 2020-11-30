//
//  RingData.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

@interface RingData : NSObject
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;
+ (RingData *)sharedInstance;
- (NSArray *)findEntities:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKeys:(NSDictionary *)sortKeys;
- (NSManagedObject *)findSingleEntity:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKey:(NSDictionary *)sortKeys;
- (NSArray *)findEntities:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKeys:(NSDictionary *)sortKeys andPageIndex:(NSInteger)pageIndex andPageSize:(NSInteger)pageSize;
- (void)removeEntity:(NSString *)entityName withPredicateString:(NSString *)predicateString andArguments:(NSArray *)arguments withSortDescriptionKey:(NSDictionary *)sortKeys;
- (void)deleteObjects:(id)objects;
- (void)resetDatabase;
@end
