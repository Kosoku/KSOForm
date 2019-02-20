//
//  MapViewController.m
//  Demo-iOS
//
//  Created by William Towe on 9/28/17.
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

#import "MapViewController.h"

#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (strong,nonatomic) MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMapView:[[MKMapView alloc] initWithFrame:CGRectZero]];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.mapView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.mapView}]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(39.952583, -75.165222), MKCoordinateSpanMake(1, 1)) animated:YES];
}

@end
