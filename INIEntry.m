// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIEntry.h"

@implementation INIEntry

@synthesize aboveEntry;
@synthesize belowEntry;
@synthesize line;

- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (id) initWithLine: (NSString *) line_ aboveEntry: (INIEntry *) aboveEntry_ belowEntry: (INIEntry *) belowEntry_ {
  if (self = [self init]) {
    self.line = [line_ mutableCopy];
    self.aboveEntry = aboveEntry_;
    self.belowEntry = belowEntry_;
  }
  return self;
}

- (INIEntryType) entryType {
  return INIEntryTypeKeyValue;
}

- (NSString *) key {
  return nil;
}

- (void) setKey: (NSString *) key {
  if (self.entryType == INIEntryTypeKeyValue) {
    
  } else {
    assert(NO);
  }
}

- (NSString *) value {
  return nil;
}

- (void) setValue: (NSString *) value {
  
}

- (NSString *) section {
  return nil;
}

@end
