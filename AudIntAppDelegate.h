//
//  AudIntAppDelegate.h
//  AudInt
//
//  Created by Justin Blinder on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AudIntAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
	
	//encode interface eleemnts
	IBOutlet NSButton *encodeButton;
	IBOutlet NSButton *importTrack;
	IBOutlet NSButton *encodeSaveTo;
	IBOutlet NSButton *replaceEncodedSong;  
 	IBOutlet NSTextField *encodeSaveToTitle;
	IBOutlet NSTextField *encodeImportTrack;
	IBOutlet NSTextField *encodeImportDiscrete;
	
	IBOutlet NSButton *decodeSaveTo;
	IBOutlet NSButton *replaceDecodedSong;
	IBOutlet NSTextField *decodeSaveToTitle;
	IBOutlet NSTextField *decodedImportTrack;
	IBOutlet NSTextField *rawOutput;
    IBOutlet NSProgressIndicator *conversionProgress;

	//decode interface elements
	
	NSMutableDictionary *filePaths;
	NSString *encodeImportTrackURL;
	NSString *encodeImportDiscreteURL;
	NSString *decodeImportTrackURL;	
}


@property (assign) IBOutlet NSWindow *window;

-(void)disableInterfaceElements;
-(void)enableInterfaceElements;
-(void)cleanUp;
-(void)promptAlert:(NSString *)mainText altMessage:(NSString *)altText;
-(IBAction)encodeAudioFile:(id)sender;
-(IBAction)openFile:(id)sender;
-(IBAction)openDir:(id)sender;
-(IBAction)manageInterface:(id)sender;

@end
