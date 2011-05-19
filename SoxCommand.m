//
//  SoxCommand.m
//  AudInt
//
//  Created by Justin Blinder on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoxCommand.h"


@implementation SoxCommand


- (id) init
{
    if ( self = [super init] )
    {
    }
    return self;
}

- (void)encodeAudio:(NSDictionary *)commands
{
	
}

- (void)decodeAudio:(NSDictionary *)commands
{

}

- (void)runProcesses:(NSArray *)command
{
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setStandardInput:[NSPipe pipe]]; 
//	[task setLaunchPath:path];
//	[task setArguments: arguments1];
	
	NSPipe *pipe;
	pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	
	NSFileHandle *file;
	file = [pipe fileHandleForReading];

	[task launch];
	[task waitUntilExit];
	[task release];
}


@end
