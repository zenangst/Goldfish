//
//  GOLDGitDataEntry.h
//  Git
//
//  Created by Christoffer Winterkvist on 27/04/14.
//
//

#import <Foundation/Foundation.h>
#import "GOLDProtocols.h"

@interface GOLDGitDataEntry : NSObject <GOLDDataEntry>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSString *plugInName;
@property (nonatomic, strong) NSString *commit;

@end
