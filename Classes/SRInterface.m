//
//  SRInterface.m
//
//  A part of Sterren.app, planetarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//


#import "SRInterface.h"
#import "SRRenderer.h"
#import "SRModule.h"

@implementation SRInterface

@synthesize timeModule,renderer;

-(id)initWithRenderer:(SRRenderer*)theRenderer {
	if(self = [super init]) {
		renderer = theRenderer;
		
		[self loadMenu];
		[self loadModules];
		[self loadNameplate];
		[self loadTexture:@"click.png" intoLocation:textures[[UIElements count]]];
		
		defaultTextureBool = TRUE;
		alphaDefault = 1.0f;
		defaultTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"defaultTexture.png"]];
		[self fadeDefaultTexture];
	}
	return self;
}

-(void)loadNameplate {
	theNameplate = [[SRNamePlate alloc] init];
}

- (void)loadTextureWithString:(NSString *)text intoLocation:(GLuint)location {
	//Text opzetten
	UIFont* font;	
	CGRect rect = {0,0,32,32};
		
	UIGraphicsBeginImageContext(rect.size);
	
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.6);
    CGContextFillEllipseInRect(ctx, rect);

	[[UIColor lightGrayColor] setFill];
	font = [UIFont boldSystemFontOfSize:20];
	CGPoint point = CGPointMake((rect.size.width / 2) - ([text sizeWithFont:font].width / 2), (rect.size.height / 2) - ([text sizeWithFont:font].height / 2));
	
	[text drawAtPoint:point withFont:font];	
	
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGImageRef textureImageTemp = outputImage.CGImage;
	
	CGImageRef textureImage = [self CGImageRotatedByAngle:textureImageTemp angle:90];
	
	NSInteger texWidth = CGImageGetWidth(textureImage);
    NSInteger texHeight = CGImageGetHeight(textureImage);
		
	GLubyte *textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
	
	CGContextRef textureContext = CGBitmapContextCreate(textureData,
														texWidth, texHeight,
														8, texWidth * 4,
														CGImageGetColorSpace(textureImage),
														kCGImageAlphaPremultipliedLast);	
	
	CGContextTranslateCTM(textureContext, 0, rect.size.height);
	CGContextScaleCTM(textureContext, 1.0, -1.0);
	CGContextSetBlendMode(textureContext, kCGBlendModeCopy);
	CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)texWidth, (float)texHeight), textureImage);
	CGContextRelease(textureContext);
	
	glBindTexture(GL_TEXTURE_2D, location);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	
	free(textureData);
	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
}

- (void)loadTexture:(NSString *)name intoLocation:(GLuint)location {
	CGImageRef textureImage = [UIImage imageNamed:name].CGImage;
    if (textureImage == nil) {
        NSLog(@"Failed to load texture image");
		return;
    }
	
    NSInteger texWidth = CGImageGetWidth(textureImage);
    NSInteger texHeight = CGImageGetHeight(textureImage);
	
	GLubyte *textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
	
    CGContextRef textureContext = CGBitmapContextCreate(textureData,
														texWidth, texHeight,
														8, texWidth * 4,
														CGImageGetColorSpace(textureImage),
														kCGImageAlphaPremultipliedLast);
	CGContextTranslateCTM (textureContext, 0, texHeight);
	CGContextScaleCTM (textureContext, 1.0, -1.0);
	CGContextSetBlendMode(textureContext, kCGBlendModeCopy);
	CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)texWidth, (float)texHeight), textureImage);
	CGContextRelease(textureContext);
	
	glBindTexture(GL_TEXTURE_2D, location);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	
	free(textureData);
	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND);	//werkt niet goed! 
}

-(void)loadMenu {
	//elementen inladen
	UIElements = [[NSMutableArray alloc] init];
	
	//main menu met knoppen
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(402, 130, 32, 64)  
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] 
														  identifier:@"arrow" 
														   clickable:YES]];
	
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(416, 34, 64, 256) 
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"menu.png"]] 
														  identifier:@"menu" 
														   clickable:NO]];
	 
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(442, 211, 32, 32)  
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"location.png"]] 
														  identifier:@"location" 
														   clickable:YES]];
	  
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(442, 171, 32, 32)  
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"search.png"]]
														  identifier:@"search" 
														   clickable:YES]];
	   
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(442, 131, 32, 32)  
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"time.png"]] 
														  identifier:@"time" 
														   clickable:YES]];
	 
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(442, 91, 32, 32)  
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"settings.png"]] 
														  identifier:@"settings" 
														   clickable:YES]];
	
	[UIElements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(59,-51,512,64) 
															 texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"module_bg.png"]]
														  identifier:@"modulebg" 
														   clickable:NO]];
	
	xTranslate = 48;
}

-(void)loadModules {
	modules = [[NSMutableArray alloc] init];
	
	//tijd	
	timeModule = [[SRTimeModule alloc] init];
	[modules addObject:timeModule];
	
	//locatie
	locationModule = [[SRLocationModule alloc] initWithSRLocation:[renderer location]];
	[modules addObject:locationModule];
	
	settingsModule = [[SRSettingsModule alloc] init];
	[modules addObject:settingsModule];
}

-(void)renderInterface {
	
	glMatrixMode(GL_PROJECTION); 
	glLoadIdentity();
	glRotatef(-90.0, 0.0, 0.0, 1.0); //x hor, y vert
	glOrthof(0.0, 480, 0.0, 320, -1.0, 1.0); //projectie opzetten
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glDisable(GL_DEPTH_TEST);
	//glDepthMask(GL_FALSE); 
	
	//glAlphaFunc( GL_EQUAL, 1.0f );
	//glEnable( GL_ALPHA_TEST );
	glEnable(GL_BLEND);

	glEnable(GL_TEXTURE_2D);
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
		
	glDisableClientState(GL_COLOR_ARRAY);
    glColor4f(1.0, 1.0, 1.0, 1.0);      
	
    glVertexPointer(3, GL_FLOAT, 0, textureCorners);
    glEnableClientState(GL_VERTEX_ARRAY);
	
	if(defaultTextureBool) {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

		glColor4f(1.0, 1.0, 1.0, alphaDefault);      
		[defaultTexture drawInRect:CGRectMake(0,-192,512,512)];
	}
	
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glColor4f(1.0, 1.0, 1.0, 1.0);      

	[theNameplate draw];
	
	glTranslatef(xTranslate, 0, 0);
	
	
	int i = 0;
	for (SRInterfaceElement* element in UIElements) {

		
		if([element identifier] == @"modulebg") {
		for (SRModule* module in modules) {
			if([module visible]) {
				glTranslatef(-xTranslate, [module yTranslate], 0);
				[[element texture] drawInRect:[element bounds]];
				
				[module draw];

				glTranslatef(xTranslate, -[module yTranslate], 0);
			}
		}
		}
		else {
			[[element texture] drawInRect:[element bounds]];
		}
		
		++i;
	}
	
	glTranslatef(-xTranslate, 0, 0);
	
	if(isClicking) {
		GLfloat touchCorners[] = {
			rectClicked.origin.x, rectClicked.origin.y + rectClicked.size.height, 0,
			rectClicked.origin.x + rectClicked.size.width, rectClicked.origin.y + rectClicked.size.height, 0,
			rectClicked.origin.x + rectClicked.size.width, rectClicked.origin.y, 0,
			rectClicked.origin.x, rectClicked.origin.y, 0
		};
		
		GLfloat touchCoords[] = {
			0, 1,
			1, 1,
			1, 0, 
			0, 0
		};
		
		glTexCoordPointer(2, GL_FLOAT, 0, touchCoords);
		glVertexPointer(3, GL_FLOAT, 0, touchCorners);
		
		glBindTexture(GL_TEXTURE_2D, textures[[UIElements count]]);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	}
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		
	glTranslatef(-xTranslate, 0, 0);

	[self drawModules];
	
	glEnable(GL_DEPTH_TEST);
	glDepthMask(GL_TRUE); 
	
	glDisable(GL_TEXTURE_2D);
}

-(void)drawModules {

}

-(BOOL)UIElementAtPoint:(CGPoint)point {
	BOOL flag = FALSE;

	//checken of het onder een UIElement valt
	for (SRInterfaceElement* element in UIElements) {
		if(CGRectContainsPoint([element bounds], CGPointMake(point.y - xTranslate, point.x)) && !flag && [element clickable])  {
			clicker = [element identifier];
			isClicking = TRUE;
			CGRect clicked = [element bounds];
			clicked.origin.x += xTranslate;
			rectClicked = CGRectInset(clicked, -16, -16);
			flag = TRUE;
		}
	}
	
	for (SRModule* module in modules) {
		if([module visible]) {
			for (SRInterfaceElement* element in [module elements]) {
				if(CGRectContainsPoint([element bounds], CGPointMake(point.y, point.x - [module yTranslate])) && !flag && [element clickable])  {
					clicker = [element identifier];
					isClicking = TRUE;
					CGRect clicked = [element bounds];
					clicked.origin.y += [module yTranslate];
					rectClicked = CGRectInset(clicked, -16, -16);
					flag = TRUE;
				}				
			}
		}
	}
	
	return flag;
}

-(void)touchEndedAndExecute:(BOOL)result {
	isClicking = FALSE;
	
	// Als er een keyboard omhoog staat mag er niet nog een keer een keyboard omhoog komen.
	// Als de click niet weggesleept is mag er door worden gegaan
	if(![fieldTmp isFirstResponder] && result) {
		
		BOOL flagToggle = FALSE;
	
		if(clicker == @"time") {
			//show tijd crap
			flagToggle = YES;
			if([timeModule visible]) {
				[timeModule hide];	
			}
			else {
				/* voordat je een nieuwe module laat zien moet je eerst een oude verbergen */
				[self hideAllModules];
				[timeModule show];
			}
		}
		else if(clicker == @"location") {
			//show tijd crap
			flagToggle = YES;
			if([locationModule visible]) {
				[locationModule hide];	
			}
			else {
				/* voordat je een nieuwe module laat zien moet je eerst een oude verbergen */
				[self hideAllModules];
				// Haal nog een keer de nieuwe locatieData op.
				[locationModule updateDisplayedLocationData];
				[locationModule show];
			}
		}
		else if(clicker == @"settings") {
			//show tijd crap
			flagToggle = YES;
			if([settingsModule visible]) {
				[settingsModule hide];	
			}
			else {
				/* voordat je een nieuwe module laat zien moet je eerst een oude verbergen */
				[self hideAllModules];
				// Haal nog een keer de nieuwe locatieData op.
				[settingsModule show];
			}
		}
		else if(clicker == @"search") {
			if([theNameplate visible]) {
				[theNameplate hide];
			}
			else {
				[theNameplate setName:@"Zon" inConstellation:@"Orion" showInfo:FALSE];
			}
		}
		else if(clicker == @"arrow") {
			flagToggle = YES;
		}
		// Knoppen voor de tijd module
		else if(clicker == @"play") {
			[[timeModule manager] reset];
		}
		else if(clicker == @"fwd") {
			[[timeModule manager] fwd];
		}
		else if(clicker == @"rew") {
			[[timeModule manager] rew];
		}
		// Knoppen voor de locatie module
		else if(clicker == @"lat-edit") {
			NSNumber* aNumber = [[NSNumber alloc] initWithFloat:[locationModule latitude]];
			currentlyEditingIdentifier = @"lat";
			[locationModule setLatVisible:NO];
			[self bringUpTheKeyboardWithText:[aNumber stringValue] onLocation:104 andSendResultsTo:self]; // 74 omdat dit ook de locatie is van de data
			//Waarom reset de interface zich naar alles ingeklapt?
			
			if([locationModule GPS]) {
				[locationModule toggleGPS];	
			}
			
			[aNumber release];
		}
		else if(clicker == @"long-edit") {
			NSNumber* aNumber = [[NSNumber alloc] initWithFloat:[locationModule longitude]];
			currentlyEditingIdentifier = @"long";
			[locationModule setLongVisible:NO];
			[self bringUpTheKeyboardWithText:[aNumber stringValue] onLocation:224 andSendResultsTo:self]; // 174 omdat dit ook de locatie is van de data
			//Waarom reset de interface zich naar alles ingeklapt?
			
			if([locationModule GPS]) {
				[locationModule toggleGPS];	
			}
			
			[aNumber release];
		}
		else if(clicker == @"gps-toggle") {
			[locationModule toggleGPS];
		}
	
		if(flagToggle) {
			if(![posiTimer isValid] && ![negiTimer isValid]) {
				if(xTranslate == 0) {
					[self hideInterface]; 
				}
				else {
					[self showInterface]; 
				}
			}
		}
		
	}
}

-(void)hideInterface {
	//FIXME IMPLEMENT MET TIMEELAPSED IN DE DRAW SEQUENCE
	posiTimer = [[NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(translate:) userInfo:nil repeats:YES] retain];
	[negiTimer invalidate];
}

-(void)showInterface {
	negiTimer = [[NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(translate:) userInfo:nil repeats:YES] retain];
	[posiTimer invalidate];
}

-(void) hideAllModules {
	if([timeModule visible]) {
		[timeModule hide];	
	}
	if([locationModule visible]) {
		[locationModule hide];
	}
	if([settingsModule visible]) {
		[settingsModule hide];
	}
}

-(void)translate:(NSTimer*)theTimer {
	if([theTimer isEqual:posiTimer]) {
		xTranslate += 6; }
	else {
		xTranslate -= 6;
	}
	
	if(xTranslate >= 48 || xTranslate == 0) {
		[theTimer invalidate];
	}
}

-(GLuint)textures {
	return textures[1];
}

- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
	// Uitleg: http://blog.coriolis.ch/2009/09/04/arbitrary-rotation-of-a-cgimage/
	
	CGFloat angleInRadians = angle * (M_PI / 180);
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGRect imgRect = CGRectMake(0, 0, width, height);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL,
												   rotatedRect.size.width,
												   rotatedRect.size.height,
												   8,
												   0,
												   colorSpace,
												   kCGImageAlphaPremultipliedFirst);
	CGContextSetAllowsAntialiasing(bmContext, FALSE);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
	CGColorSpaceRelease(colorSpace);
	CGContextTranslateCTM(bmContext,
						  +(rotatedRect.size.width/2),
						  +(rotatedRect.size.height/2));
	CGContextRotateCTM(bmContext, angleInRadians);
	CGContextTranslateCTM(bmContext,
						  -(rotatedRect.size.width/2),
						  -(rotatedRect.size.height/2));
	
	CGContextScaleCTM(bmContext, 1, -1);
	CGContextTranslateCTM(bmContext, 0, -height);
	
	CGContextDrawImage(bmContext, CGRectMake(0, 0,
											 rotatedRect.size.width,
											 rotatedRect.size.height),
					   imgRef);
	
	CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
	CFRelease(bmContext);
	[(id)rotatedImage autorelease];
	
	return rotatedImage;
}

-(void)bringUpTheKeyboardWithText:(NSString *)placeholder onLocation:(int)location andSendResultsTo:(id)delegate {
	//NSLog(@"Bring up the Keyboard");
	
	fieldTmp = [[UITextField alloc] initWithFrame:CGRectMake(-27, (location+25), 80, 32)];
	[fieldTmp setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
	[fieldTmp setTextColor:[UIColor whiteColor]];
	[fieldTmp setTextAlignment:UITextAlignmentLeft];
	[fieldTmp setDelegate:delegate];
	[fieldTmp setText:placeholder];
	[fieldTmp setAutocorrectionType:UITextAutocorrectionTypeNo];
	[fieldTmp setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[fieldTmp setReturnKeyType:UIReturnKeyDone];
	[fieldTmp setTransform:CGAffineTransformMakeRotation(M_PI / 2.0)];
	[fieldTmp setKeyboardType:UIKeyboardTypeNumbersAndPunctuation]; // UIKeyboardTypeNumberPad werkt niet omdat deze geen '.' en 'return' knop heeft
	
	[fieldTmp setClearsOnBeginEditing:NO];
	// Unhide de uiElementsView (Anders werkt de multitouch in glView niet)
	[[[[UIApplication sharedApplication] delegate] uiElementsView] setHidden:NO];
	// We moeten de view toevoegen aan de glView
 	[[[[UIApplication sharedApplication] delegate] uiElementsView] addSubview:fieldTmp];
	// Nu om focus te zetten op dit UI element
	[fieldTmp becomeFirstResponder];
	// Nu transleren we de hele glView naar boven om plaats te maken voor het keyboard, met animatie
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3]; // 0.3 lijkt even snel te zijn als het keyboard.
	[[[[UIApplication sharedApplication] delegate] glView] setTransform:CGAffineTransformMakeTranslation(160 , 0)];
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if(textField == fieldTmp) {
		// Hide de uiElementsView
		[[[[UIApplication sharedApplication] delegate] uiElementsView] setHidden:YES];
		// Nu transleren we de hele glView weer naar beneden omdat het keyboard weg gaat.
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3]; // 0.3 lijkt even snel te zijn als het keyboard.
		// van 160,0 terug naar 0,0
		[[[[UIApplication sharedApplication] delegate] glView] setTransform:CGAffineTransformMakeTranslation(0 , 0)];
		[UIView commitAnimations];
		
		NSString *aValue = [[NSString alloc] initWithString:[fieldTmp text]];
		
		if	(currentlyEditingIdentifier == @"lat") {
			[[locationModule locationManager] useStaticValues];
			[[locationModule locationManager] setLatitude:[aValue floatValue]];
			//[locationModule updateDisplayedLocationData]; // Wordt al gedaan in setLatitude
			[locationModule setLatVisible:YES];
		}
		else if (currentlyEditingIdentifier == @"long") {
			[[locationModule locationManager] useStaticValues];	
			[[locationModule locationManager] setLongitude:[aValue floatValue]];
			//[locationModule updateDisplayedLocationData]; // Wordt al gedaan in setLongitude
			[locationModule setLongVisible:YES];
		}
		
		//[fieldTmp setText:@""];
		[fieldTmp removeFromSuperview]; // Verwijder uit glView
		//[fieldTmp release]; /* FIXME Werkt niet als ik fieldTmp hier release maar anders hebben we een leak */
		[aValue release];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
						  
-(void)fadeDefaultTexture {
	fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fade:) userInfo:nil repeats:YES] retain];
}

-(void)fade:(NSTimer*)theTimer {
	alphaDefault -= 0.05;
	if (alphaDefault <= 0.0) {
		defaultTextureBool = FALSE;
		[fadeTimer invalidate];
		[defaultTexture release];
	}
}


@end
