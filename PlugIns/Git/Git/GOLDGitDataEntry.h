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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *datestamp;
@property (nonatomic, strong) NSString *plugIn;
@property (nonatomic, strong) NSString *commit;

@end
