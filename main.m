// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import <Foundation/Foundation.h>
#import "INI.h"

int main(int argc, char** argv) {
  @autoreleasepool {
  
    INIEntry *entry;
    
    entry = [INIEntry entryWithLine: @"  username  \t=  mirek  "];
    for (int i = 0; i < entry.line.length; i++)
      printf("%i", i % 10);
    printf("\n%s\nsection: %i:%i\nkey: %i:%i\nvalue: %i:%i",
           [entry.line UTF8String],
           (int)entry.info.section.location, (int)entry.info.section.length,
           (int)entry.info.key.location, (int)entry.info.key.length,
           (int)entry.info.value.location, (int)entry.info.value.length);
    printf("\nkey '%s' is value '%s' section '%s'\n", [entry.key UTF8String], [entry.value UTF8String], [entry.section UTF8String]);

    printf("\n");
    entry.line = @" [section] ";
    
    for (int i = 0; i < entry.line.length; i++)
      printf("%i", i % 10);
    printf("\n%s\nsection: %i:%i\nkey: %i:%i\nvalue: %i:%i",
           [entry.line UTF8String],
           (int)entry.info.section.location, (int)entry.info.section.length,
           (int)entry.info.key.location, (int)entry.info.key.length,
           (int)entry.info.value.location, (int)entry.info.value.length);
    printf("\nkey '%s' is value '%s' section '%s'\n", [entry.key UTF8String], [entry.value UTF8String], [entry.section UTF8String]);
	
    NSError *err;
    NSString *path = [@"~/.gitconfig" stringByExpandingTildeInPath];
    INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile: path error: &err];
    NSString *token = [config valueForKey: @"name" inSection: @"user"];
    NSString *user = [config valueForKey: @"email" inSection: @"user"];
    NSLog(@"GitHub token %@ for user %@", token, user);
  
  }
  return 0;
}
