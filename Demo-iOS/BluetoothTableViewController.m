//
//  BluetoothTableViewController.m
//  Demo-iOS
//
//  Created by William Towe on 9/29/17.
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

#import "BluetoothTableViewController.h"
#import "HeaderViewWithProgress.h"

#import <KSOForm/KSOForm.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothTableViewController () <KSOFormRowValueDataSource,CBCentralManagerDelegate>
@property (strong,nonatomic) KSOFormRow *formRow;
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableSet *peripherals;
@property (assign,nonatomic) BOOL scanning;
@end

@implementation BluetoothTableViewController

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *value = nil;
    
    switch (central.state) {
        case CBManagerStateUnknown:
            value = @"Unknown";
            break;
        case CBManagerStatePoweredOn:
            value = @"On";
            [self.model.sections.firstObject setFooterTitle:[NSString stringWithFormat:@"Now discoverable as \"%@\".",UIDevice.currentDevice.name]];
            break;
        case CBManagerStateResetting:
            value = @"Resetting";
            break;
        case CBManagerStatePoweredOff:
            value = @"Off";
            break;
        case CBManagerStateUnsupported:
            value = @"Unsupported";
            [self.model.sections.firstObject.rows.firstObject setEnabled:NO];
            [self.model.sections.firstObject.rows.firstObject setValue:@NO];
            break;
        case CBManagerStateUnauthorized:
            value = @"Unauthorized";
            break;
        default:
            break;
    }
    
    [self.formRow setValue:value];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self.peripherals == nil) {
        [self setPeripherals:[[NSMutableSet alloc] init]];
    }
    
    if ([self.peripherals containsObject:peripheral]) {
        return;
    }
    
    [self.peripherals addObject:peripheral];
    
    dispatch_block_t block = ^{
        if (peripheral.name == nil) {
            [self.model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: peripheral.identifier.UUIDString} animation:UITableViewRowAnimationTop];
            return;
        }
        
        [self.model[1] addRowFromDictionary:@{KSOFormRowKeyTitle: peripheral.name,
                                              KSOFormRowKeyValue: @"Unknown",
                                              KSOFormRowKeyCellAccessoryType: @(UITableViewCellAccessoryDetailButton)
                                              } animation:UITableViewRowAnimationTop];
    };
    
    if (self.model.sections.count == 1) {
        [self.model performUpdates:^{
            [self.model addSectionsFromDictionaries:@[@{KSOFormSectionKeyHeaderTitle: @"My Devices"},@{KSOFormSectionKeyHeaderViewClass: HeaderViewWithProgress.class, KSOFormSectionKeyHeaderTitle: @"Other Devices"}] animation:UITableViewRowAnimationTop];
            block();
        }];
    }
    else {
        block();
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.centralManager stopScan];
}

- (instancetype)initWithFormRow:(KSOFormRow *)formRow; {
    if (!(self = [super initWithStyle:UITableViewStyleGrouped]))
        return nil;
    
    _formRow = formRow;
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    KSOFormSection *toggleSection = [[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyRows: @[@{KSOFormRowKeyType: @(KSOFormRowTypeSwitch), KSOFormRowKeyTitle: @"Bluetooth", KSOFormRowKeyValueKey: @"scanning", KSOFormRowKeyValueDataSource: self
                                                                                                            }],
                                                                                 KSOFormSectionKeyFooterTitle: @"Location accuracy and nearby services are improved when Bluetooth is turned on."
                                                                                 }];
    
    [self setModel:[[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Bluetooth", KSOFormModelKeySections: @[toggleSection]}]];
    
    return self;
}

- (void)setScanning:(BOOL)scanning {
    if (_scanning == scanning) {
        return;
    }
    
    _scanning = scanning;
    
    if (_scanning) {
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
    }
    else {
        [self.centralManager stopScan];
        [self.model removeSections:[self.model.sections subarrayWithRange:NSMakeRange(1, 2)] animation:UITableViewRowAnimationFade];
        [self.peripherals removeAllObjects];
    }
}

@end
