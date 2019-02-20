//
//  KSOFormRowTableViewCell.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
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

#import <UIKit/UIKit.h>
#import <KSOForm/KSOFormRowView.h>

/**
 This serves as the base class for all form table view cells displayed by a KSOFormTableViewController instance. Custom cells should subclass this class, but are not required to do so. By subclassing you gain automatic support for editing on cell selection and support for indicating that the cell is editing through the KSOFormThemeEditingIndicatorView protocol.
 
 This class implements the formRow and formTheme properties as well as returning NO for canEditFormRow.
 */
@interface KSOFormRowTableViewCell : UITableViewCell <KSOFormRowView>

@end
