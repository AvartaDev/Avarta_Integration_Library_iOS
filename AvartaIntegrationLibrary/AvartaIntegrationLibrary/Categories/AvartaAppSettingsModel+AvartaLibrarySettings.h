//
//  AvartaAppSettingsModel+AvartaLibrarySettings.h
//  Avarta
//
//  Created by Dmitrii Babii on 07.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaAppSettingsModel.h"
@class AvartaLibrarySettings;

@interface AvartaAppSettingsModel (AvartaLibrarySettings)

@property (nonatomic, nonnull, strong, readonly) AvartaLibrarySettings* librarySettings;

@end
