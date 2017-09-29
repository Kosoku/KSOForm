//
//  BluetoothTableViewController.m
//  Demo-iOS
//
//  Created by William Towe on 9/29/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BluetoothTableViewController.h"
#import "HeaderViewWithProgress.h"

#import <KSOForm/KSOForm.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothTableViewController () <CBCentralManagerDelegate>
@property (strong,nonatomic) KSOFormRow *formRow;
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableSet *peripherals;
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
            [self.model.sections.firstObject.rows.firstObject setValue:@YES];
            [self.model.sections.firstObject setFooterTitle:[NSString stringWithFormat:@"Now discoverable as \"%@\".",UIDevice.currentDevice.name]];
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
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
    
    if (peripheral.name == nil) {
        return;
    }
    
    [self.model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: peripheral.name,
                                                           KSOFormRowKeyValue: @"Unknown",
                                                           KSOFormRowKeyCellAccessoryType: @(UITableViewCellAccessoryDetailButton)
                                                           }];
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
    
    KSOFormSection *toggleSection = [[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyRows: @[@{KSOFormRowKeyType: @(KSOFormRowTypeSwitch), KSOFormRowKeyTitle: @"Bluetooth"
                                                                                                            }],
                                                                                 KSOFormSectionKeyFooterTitle: @"Location accuracy and nearby services are improved when Bluetooth is turned on."
                                                                                 }];
    KSOFormSection *myDevicesSection = [[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyHeaderTitle: @"My Devices"}];
    KSOFormSection *otherDevices = [[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyHeaderViewClass: HeaderViewWithProgress.class, KSOFormSectionKeyHeaderTitle: @"Other Devices"}];
    
    [self setModel:[[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Bluetooth", KSOFormModelKeySections: @[toggleSection,myDevicesSection,otherDevices]}]];
    
    return self;
}

@end
