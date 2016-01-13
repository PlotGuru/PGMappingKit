//
//  PGNetworkHandler+PGData.h
//  PGMappingKit
//
//  Created by Justin Jia on 1/13/16.
//  Copyright © 2016 Plot Guru. All rights reserved.
//

#import "PGNetworkHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGNetworkHandler (PGData)

- (NSMutableDictionary *)dataFromObject:(nullable id)object mapping:(PGMappingDescription *)mapping;

@end

NS_ASSUME_NONNULL_END
