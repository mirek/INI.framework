// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import <Foundation/Foundation.h>

typedef enum {
  INIEntryTypeSection,
  INIEntryTypeKeyValue,
  INIEntryTypeOther
} INIEntryType;

@interface INIEntry : NSObject {
  INIEntry *aboveEntry;
  INIEntry *belowEntry;
  NSMutableString *line;
}

@property (nonatomic, retain) INIEntry *aboveEntry;
@property (nonatomic, retain) INIEntry *belowEntry;
@property (nonatomic, retain) NSMutableString *line;

- (id) init;
- (id) initWithLine: (NSString *) line aboveEntry: (INIEntry *) aboveEntry belowEntry: (INIEntry *) belowEntry;

- (INIEntryType) entryType;

- (NSString *) key;
- (void) setKey: (NSString *) key;

- (NSString *) value;
- (void) setValue: (NSString *) value;

- (NSString *) section;

@end
