//
//  KSOFormRowValueDataSource.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/25/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFormRow;

/**
 Block that is invoked to allow/deny changes to the KSOFormRow objects value.
 
 @param row The row whose value is about to change
 @param value The new value
 @param error An error to display to the user if the change is not allowed
 @return YES if the change is allowed, otherwise NO
 */
typedef BOOL(^KSOFormRowValueDataSourceShouldChangeValueBlock)(KSOFormRow *row, id _Nullable value, NSError **error);

@protocol KSOFormRowValueDataSource <NSObject>
@optional
/**
 Return a block used to validate changes to the KSOFormRow value.
 */
@property (readonly,copy,nonatomic,nullable) KSOFormRowValueDataSourceShouldChangeValueBlock shouldChangeValueBlock;
@end

NS_ASSUME_NONNULL_END
