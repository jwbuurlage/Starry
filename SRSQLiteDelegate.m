//
//  SRSQLiteDelegate.m
//  Sterren
//
//  Created by Thijs Scheepers on 10-01-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import "SRSQLiteDelegate.h"
#import "SRStar.h"
#import "OpenGLCommon.h"
#import "SRObjectManager.h"

@implementation SRSQLiteDelegate

-(void) checkAndCreateDatabase{
	NSString *databaseName = @"database.db";
	databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
}

-(void) readStarsFromDatabase {
	NSLog(@"Star star read");
	sqlite3 *database;
	SRObjectManager* objectManager = [[[UIApplication sharedApplication] delegate] objectManager];
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "select id,hip,gliese,bayerflamsteed,propername,ra,dec,mag,colorindex from hyg order by mag limit 5000";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				int ID = sqlite3_column_int(compiledStatement, 0);
				NSString *hip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *gliese = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *bayer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				float ra = sqlite3_column_double(compiledStatement, 5);
				float dec = sqlite3_column_double(compiledStatement, 6);
				float mag = sqlite3_column_double(compiledStatement, 7);
				float ci = sqlite3_column_double(compiledStatement, 8);
				
				ra = ra*(M_PI/12);
				dec = (90-dec)*(M_PI/180);
				
				float x = 20*sin(dec)*cos(ra);
				float y = 20*sin(dec)*sin(ra);
				float z = 20*cos(dec);
				
				SRStar *star = [[SRStar alloc] init];
				
				star.starID = ID;
				star.name = name;
				star.bayer = bayer;
				star.gliese = gliese;
				star.hip = hip;
				star.position = Vertex3DMake(x, y, z);
				star.mag = mag;
				star.ci = ci;
				
				// Add object to the Array
				[objectManager.stars addObject:star];
				
				[star release];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	NSLog(@"Star read completed");
	
}


@end
