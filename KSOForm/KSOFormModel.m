//
//  KSOFormModel.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormModel.h"
#import "KSOFormSection.h"
#import "KSOFormRow.h"

#import <Quicksilver/Quicksilver.h>

@interface KSOFormModel ()
@property (readwrite,copy,nonatomic) NSArray<KSOFormSection *> *sections;
@end

@implementation KSOFormModel

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary {
    if (!(self = [super init]))
        return nil;
    
    if (dictionary[KSOFormModelKeySections] != nil) {
        _sections = [dictionary[KSOFormModelKeySections] KQS_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
            return [[KSOFormSection alloc] initWithDictionary:object model:self];
        }];
    }
    else if (dictionary[KSOFormModelKeyRows] != nil) {
        _sections = @[[[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyRows: dictionary[KSOFormModelKeyRows]} model:self]];
    }
    
    return self;
}

- (KSOFormRow *)formRowForIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section].rows[indexPath.row];
}
- (NSIndexPath *)indexPathForFormRow:(KSOFormRow *)formRow {
    NSIndexPath *retval = nil;
    
    for (NSUInteger i=0; i<self.sections.count; i++) {
        for (NSUInteger j=0; j<self.sections[i].rows.count; j++) {
            if ([formRow isEqual:self.sections[i].rows[j]]) {
                retval = [NSIndexPath indexPathForRow:j inSection:i];
                break;
            }
        }
        
        if (retval != nil) {
            break;
        }
    }
    
    return retval;
}

@end
