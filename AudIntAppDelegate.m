//
//  AudIntAppDelegate.m
//  AudInt
//
//  Created by Justin Blinder + Jon Cohrs on 5/3/11.
//  Copyright 2011 AUDiNT. All rights reserved.
//

#import "AudIntAppDelegate.h"

@implementation AudIntAppDelegate

@synthesize window;

- (void)awakeFromNib 
{
//	[window setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"newbg.png"]]];
	encodeImportTrackURL = [[NSString alloc] init];
	filePaths = [[NSMutableDictionary alloc] init];
	self.window.title = @"GhostCoder";
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	[NSApp activateIgnoringOtherApps:YES];	

}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	[NSApp activateIgnoringOtherApps:YES];	
}

-(IBAction)encodeAudioFile:(id)sender
{
	NSFileManager *manager = [[NSFileManager alloc] init];
	switch ([sender tag]) {
		case 1:
			if(![manager fileExistsAtPath:[filePaths objectForKey:@"encodeInTrack"]])
			{
				[self promptAlert:@"No Track Selected." altMessage:@"Select A Track."];
			}
			else if(![manager fileExistsAtPath:[filePaths objectForKey:@"encodeInHidden"]])
			{
				[self promptAlert:@"No Hidden Track Selected." altMessage:@"Select A Hidden Track."];
			}	
			else if([[encodeSaveToTitle stringValue] isEqualTo:nil] || [[encodeSaveToTitle stringValue] isEqualTo:@""] && [replaceEncodedSong state] == NSOffState)
			{
				[self promptAlert:@"No Filename Entered." altMessage:@"Enter a filename."];
			}
			else if ([replaceEncodedSong state] == NSOffState)
			{
				NSLog(@"%@",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]);
				NSString *tempFileA = [NSString stringWithFormat:@"%@/temp1.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
				NSString *tempFileB = [NSString stringWithFormat:@"%@/temp2.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
				NSArray *arguments1 = [NSArray arrayWithObjects: [filePaths objectForKey:@"encodeInTrack"], @"-f", @"-S", @"-G", @"-V", @"-b", @"16", @"-r", @"384k",tempFileA, nil];
				NSArray *arguments2 = [NSArray arrayWithObjects: [filePaths objectForKey:@"encodeInHidden"], @"-f", @"-S", @"-G", @"-V", @"-b", @"16", @"-r", @"384k", tempFileB,@"gain", @"-n", @"speed", @"70", @"highpass", @"90k", @"pad", @"2", @"0", nil];
//				NSArray *arguments3 = [NSArray arrayWithObjects: tempFileA, tempFileB, @"-f", @"-S", @"-G",[filePaths objectForKey:@"encodeOut"], nil];
                NSArray *arguments3 = [NSArray arrayWithObjects: @"-m", tempFileA, tempFileB, @"-f", @"-C", @"8", @"-S", @"-G",[filePaths objectForKey:@"encodeOut"],@"gain", @"+6", nil];

				NSArray *soxCommands = [NSArray arrayWithObjects:arguments1,arguments2,arguments3,nil];
				[self processAudio:soxCommands];
			}
			else 
			{
				NSLog(@"%@",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]);
				NSString *tempFileA = [NSString stringWithFormat:@"%@/temp1.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
				NSString *tempFileB = [NSString stringWithFormat:@"%@/temp2.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
				NSArray *arguments1 = [NSArray arrayWithObjects: [filePaths objectForKey:@"encodeInTrack"], @"-f", @"-S", @"-G", @"-V", @"-b", @"16", @"-r", @"44.1k",tempFileA, nil];
				NSArray *arguments2 = [NSArray arrayWithObjects: [filePaths objectForKey:@"encodeInHidden"], @"-f", @"-S", @"-G", @"-V", @"-b", @"16", @"-r", @"384k", tempFileB,@"gain", @"-n", @"speed", @"70", @"highpass", @"90k", @"pad", @"2", @"0", nil];
//				NSArray *arguments3 = [NSArray arrayWithObjects: tempFileA, tempFileB, @"-f", @"-S", @"-G",[filePaths objectForKey:@"encodeInTrack"], nil];
                NSArray *arguments3 = [NSArray arrayWithObjects: @"-m", tempFileA, tempFileB, @"-f", @"-C", @"8", @"-S", @"-G",[filePaths objectForKey:@"encodeInTrack"],@"gain", @"+6", nil];
        
				NSArray *soxCommands = [NSArray arrayWithObjects:arguments1,arguments2,arguments3,nil];
				[self processAudio:soxCommands];
			}

			break;
		case 2:
            if(![manager fileExistsAtPath:[filePaths objectForKey:@"decodeInTrack"]])
			{
				[self promptAlert:@"No Track Selected." altMessage:@"Select A Track."];
			}
			else if([[decodeSaveToTitle stringValue] isEqualTo:nil] || [[decodeSaveToTitle stringValue] isEqualTo:@""] &&  [replaceEncodedSong state] == NSOffState)
			{
				[self promptAlert:@"No Filename Entered." altMessage:@"Enter a filename."];
			}
			else if ([replaceDecodedSong state] == NSOffState)
			{
				NSLog(@"%@",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]);
				NSArray *arguments1 = [NSArray arrayWithObjects: [filePaths objectForKey:@"decodeInTrack"], @"-f", @"-S", @"-G", @"-b", @"16", @"-r", @"44.1k",[filePaths objectForKey:@"decodeOut"], @"gain", @"-n", @"trim", @"2", @"5", @"speed", @"0.014", @"highpass", @"200", nil];
				NSArray *soxCommands = [NSArray arrayWithObject:arguments1];
				[self processAudio:soxCommands];
			}
			else 
			{
                //./sox vvvvvv.flac justsegment.flac trim 0 5
                //./sox vvvvvv.flac justsegment.flac pitch .5
				NSLog(@"%@",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]);
//                NSArray *arguments1 = [NSArray arrayWithObjects: [filePaths objectForKey:@"decodeInTrack"], @"-f", @"-S", @"-G", @"-b", @"16", @"-r", @"44.1k",[filePaths objectForKey:@"decodeInTrack"],@"trim", @"0", @"5", @"speed", @"0.015", nil];

				NSArray *arguments1 = [NSArray arrayWithObjects:  [filePaths objectForKey:@"decodeInTrack"], @"-f", @"-S", @"-G", @"-b", @"16", @"-r", @"44.1k",[filePaths objectForKey:@"decodeInTrack"], @"gain", @"-n", @"trim", @"2", @"5", @"speed", @"0.014", @"highpass", @"200", nil];
				NSArray *soxCommands = [NSArray arrayWithObject:arguments1];
				[self processAudio:soxCommands];
			}
            
			break;
		default:
			break;
	}
		[manager release];
//	{
/*
	NSFileManager *manager = [[NSFileManager alloc] init];
		NSArray *arguments1;
		arguments1 = [NSArray arrayWithObjects: @"/Users/novatheory/Desktop/testing/Vampire Weekend - Giving Up The Gun_test.flac", @"-f", @"-S", @"-G", @"-V", @"-b", @"24", @"-r", @"384k", @"/Users/novatheory/Desktop/testing/temp.wav", nil];
		NSArray *arguments2;
		arguments2 = [NSArray arrayWithObjects: @"/Users/novatheory/Desktop/testing/Vampire Weekend - Giving Up The Gun-embeded-6x.flac", @"-f", @"-S", @"-G", @"-V", @"-b", @"24", @"-r", @"384k", @"/Users/novatheory/Desktop/testing/temp2.wav", @"speed", @"80", @"highpass", @"60k", nil];
		NSArray *arguments3;
		//sox -m $ouput.wav $encode_output.wav -f -S -G $embed_output.flac
		arguments3 = [NSArray arrayWithObjects: @"/Users/novatheory/Desktop/testing/temp.wav",@"/Users/novatheory/Desktop/testing/temp2.wav", @"-f", @"-S", @"-G",@"/Users/novatheory/Desktop/testing/final.flac", nil];
	//if([manager fileExistsAtPath:[encodeImportTrackURL path]] && [manager fileExistsAtPath:[encodeImportDiscreteURL path]])
//	{
		NSLog(@"sender: %@", [sender alternateTitle]);
		
		NSTask *task;
		task = [[NSTask alloc] init];
		[task setStandardInput:[NSPipe pipe]]; //allows for nslog when using bash
		[task setLaunchPath:path];
		[task setArguments: arguments1];
		
		NSPipe *pipe;
		pipe = [NSPipe pipe];
		[task setStandardOutput: pipe];
		
		NSFileHandle *file;
		file = [pipe fileHandleForReading];

		[task launch];

		//NSData *data;
//		data = [file readDataToEndOfFile];
//
//		NSString *string;
//		string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//		
//		NSLog (@"stuff  :\n%@", string);
//		
//		[string release];
		[task waitUntilExit];
		[task release];
		
		task = [[NSTask alloc] init];
		[task setStandardInput:[NSPipe pipe]]; //allows for nslog when using bash
		[task setLaunchPath:path];
		[task setArguments: arguments2];
		
		pipe = [NSPipe pipe];
		[task setStandardOutput: pipe];
		
		file = [pipe fileHandleForReading];

		[task launch];
		[task waitUntilExit];
		[task release];
		

		task = [[NSTask alloc] init];
		[task setStandardInput:[NSPipe pipe]]; //allows for nslog when using bash
		[task setLaunchPath:path];
		[task setArguments: arguments3];
		
		pipe = [NSPipe pipe];
		[task setStandardOutput: pipe];
		
		file = [pipe fileHandleForReading];

		[task launch];
		[task waitUntilExit];
		[task release];
		
		//data = [file readDataToEndOfFile];
//		string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];


	//}
	//else
//	{
		//error
//	}
	
	*/
}

-(void)processAudio:(NSArray *)commands
{
    [conversionProgress setHidden:NO];
    [conversionProgress startAnimation:self];
	NSString *path=[[NSBundle mainBundle] pathForResource:@"sox" ofType:nil];
	[self disableInterfaceElements];
	for(id obj in commands)
	{
		NSTask *task;
		task = [[NSTask alloc] init];
		[task setStandardInput:[NSPipe pipe]]; 
		[task setLaunchPath:path];
		[task setArguments: obj];
		
		NSPipe *pipe;
		pipe = [NSPipe pipe];
		[task setStandardOutput: pipe];
		
//		NSFileHandle *file;
//		file = [pipe fileHandleForReading];
////		NSData *data;
////		data = [file readDataToEndOfFile];
////
////		NSString *string;
////		string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
////		[rawOutput setStringValue:string];
//////		NSLog (@"stuff  :\n%@", string);
		[task launch];
		[task waitUntilExit];
		[task release];
	}
    if([commands count] == 3) [self cleanUp]; //delete temp files
    [conversionProgress stopAnimation:self];
    [conversionProgress setHidden:YES];
	[self enableInterfaceElements];  //enabel interface
}

-(IBAction)manageInterface:(id)sender
{

	switch ([sender tag]) {
		case 1:
			if([sender state] == NSOnState)
			{
				[encodeSaveTo setEnabled:NO];
				[encodeSaveToTitle setEnabled:NO];
			}
			else if([sender state] == NSOffState)
			{
				[encodeSaveTo setEnabled:YES];
				[encodeSaveToTitle setEnabled:YES];				
			}
			break;
		case 2:
			if([sender state] == NSOnState)
			{
				[decodeSaveTo setEnabled:NO];
				[decodeSaveToTitle setEnabled:NO];

			}
			else if([sender state] == NSOffState)
			{
				[decodeSaveTo setEnabled:YES];
				[decodeSaveToTitle setEnabled:YES];

			}
			break;
		default:
			break;
	}
	
}


-(IBAction)openFile:(id)sender
{
	
	NSOpenPanel *oPanel = [[NSOpenPanel openPanel] retain];
	[oPanel setCanChooseDirectories:NO];
	[oPanel setCanChooseFiles:YES];
	[oPanel	setCanCreateDirectories:NO];
    switch([oPanel runModal])
    {
        case NSFileHandlingPanelOKButton:
        {	
			switch([sender tag])
			{
				case 1:
					encodeImportTrackURL = [[NSString alloc] initWithString:[[oPanel URL] path]];
					[filePaths setObject:encodeImportTrackURL forKey:@"encodeInTrack"];
					[encodeImportTrack setStringValue:encodeImportTrackURL];
					NSLog(@"URL import: %@", encodeImportTrackURL );
					break;
				case 2:
					encodeImportDiscreteURL = [[NSString alloc] initWithString:[[oPanel URL] path]];
					[filePaths setObject:encodeImportDiscreteURL forKey:@"encodeInHidden"];
					[encodeImportDiscrete setStringValue:encodeImportDiscreteURL];

					NSLog(@"URL import: %@", encodeImportDiscreteURL );
					break;
				case 3:
					decodeImportTrackURL = [[NSString alloc] initWithString:[[oPanel URL] path]];
					[filePaths setObject:decodeImportTrackURL forKey:@"decodeInTrack"];
					[decodedImportTrack setStringValue:decodeImportTrackURL];
                    
					NSLog(@"URL import: %@", encodeImportDiscreteURL );
					break;                    
				default:
					break;
			}
        }
        case NSFileHandlingPanelCancelButton:
        {
            return;
        }
    }

    [oPanel release];
}

-(void)disableInterfaceElements
{
	[encodeButton setEnabled:NO];
	[importTrack setEnabled:NO];
	[encodeSaveTo setEnabled:NO];
	[replaceEncodedSong setEnabled:NO];  
	[encodeSaveToTitle setEnabled:NO];
	[encodeImportTrack setEnabled:NO];
	[encodeImportDiscrete setEnabled:NO];
	[decodeSaveTo setEnabled:NO];
	[replaceDecodedSong setEnabled:NO];
	[decodeSaveToTitle setEnabled:NO];
	[decodedImportTrack setEnabled:NO];
}

-(void)enableInterfaceElements
{
	[encodeButton setEnabled:YES];
	[importTrack setEnabled:YES];
	[encodeSaveTo setEnabled:YES];
	[replaceEncodedSong setEnabled:YES];  
	[encodeSaveToTitle setEnabled:YES];
	[encodeImportTrack setEnabled:YES];
	[encodeImportDiscrete setEnabled:YES];
	[decodeSaveTo setEnabled:YES];
	[replaceDecodedSong setEnabled:YES];
	[decodeSaveToTitle setEnabled:YES];
	[decodedImportTrack setEnabled:YES];
}

-(void)promptAlert:(NSString *)mainText altMessage:(NSString *)altText
{
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:mainText];
		[alert setInformativeText:altText];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}

-(IBAction)openDir:(id)sender
{

    NSSavePanel *savePanel	= [NSSavePanel savePanel];
//    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];

    int tvarInt	= [savePanel runModal];
    if(tvarInt == NSOKButton)
    {
        NSLog(@"do Save As we have an OK button");	
    } 
    else if(tvarInt == NSCancelButton) 
    {
        return;
    } 
    else 
    {
        return;
    }
    
    NSString * saveDir = [savePanel directory];
    NSString * saveFile = [savePanel filename];
    
    NSLog(@"%@",[filePaths objectForKey:@"encodeOut"]);
    
    switch([sender tag])
    {
        case 1:
            [filePaths setObject:[NSString stringWithFormat:@"%@.flac",saveFile] forKey:@"encodeOut"];
            [encodeSaveToTitle setStringValue: [filePaths objectForKey:@"encodeOut"]];
            break;
        case 2:
            [filePaths setObject:[NSString stringWithFormat:@"%@.wav",saveFile] forKey:@"decodeOut"];
            [decodeSaveToTitle setStringValue: [filePaths objectForKey:@"decodeOut"]];
            break;
        default:
            break;
						
    }
}

-(void)cleanUp
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    BOOL isDir;
    NSString *tempFileA = [NSString stringWithFormat:@"%@/temp1.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
    NSString *tempFileB = [NSString stringWithFormat:@"%@/temp2.wav",[[filePaths objectForKey:@"encodeInTrack"] stringByDeletingLastPathComponent]];
    if([manager fileExistsAtPath:tempFileA]) [manager removeItemAtPath:tempFileA error:nil];
    if([manager fileExistsAtPath:tempFileB]) [manager removeItemAtPath:tempFileB error:nil];
}
@end
