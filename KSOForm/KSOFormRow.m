//
//  KSOFormRow.m
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

#import "KSOFormRow.h"

#import <Stanley/Stanley.h>

@interface KSOFormRow ()
@property (readwrite,weak,nonatomic) KSOFormSection *section;
@property (readwrite,assign,nonatomic) KSOFormRowType type;
@end

@implementation KSOFormRow

+ (BOOL)automaticallyNotifiesObserversOfValue {
    return NO;
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary section:(KSOFormSection *)section {
    if (!(self = [super init]))
        return nil;
    
    _section = section;
    
    _type = [dictionary[KSOFormRowKeyType] integerValue];
    
    _value = dictionary[KSOFormRowKeyValue];
    _shouldChangeValueBlock = dictionary[KSOFormRowKeyShouldChangeBlock];
    _didChangeValueBlock = dictionary[KSOFormRowKeyDidChangeBlock];
    
    _image = dictionary[KSOFormRowKeyImage];
    _title = dictionary[KSOFormRowKeyTitle];
    _subtitle = dictionary[KSOFormRowKeySubtitle];
    _placeholder = dictionary[KSOFormRowKeyPlaceholder];
    _keyboardType = [dictionary[KSOFormRowKeyKeyboardType] integerValue];
    _returnKeyType = [dictionary[KSOFormRowKeyReturnKeyType] integerValue];
    
    return self;
}

- (void)setValue:(id)value {
    if (self.shouldChangeValueBlock != nil) {
        NSError *outError;
        if (!self.shouldChangeValueBlock(value,&outError)) {
            return;
        }
    }
    
    if ([_value isEqual:value]) {
        return;
    }
    
    [self willChangeValueForKey:@kstKeypath(self,value)];
    
    _value = value;
    
    [self didChangeValueForKey:@kstKeypath(self,value)];
    
    if (self.didChangeValueBlock != nil) {
        self.didChangeValueBlock(_value);
    }
}

@end
