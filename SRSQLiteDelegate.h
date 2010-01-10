//
//  SRSQLiteDelegate.h
//  Sterren
//
//  Created by Thijs Scheepers on 10-01-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <sqlite3.h>


@interface SRSQLiteDelegate : NSObject {
	NSString *databasePath;
}
-(void) readStarsFromDatabase;
-(void) checkAndCreateDatabase;
@end
