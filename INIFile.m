// Original code © 2010 Mirek Rusin
// Modified code © 2016 Robert Corrigan
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIFile.h"

@implementation INIFile {
	NSArrayController *entryController;
}

@synthesize entries;
@synthesize lineEnding = _lineEnding;
@synthesize path;
@synthesize encoding;
@synthesize autosave;

- (id) init {
  if (self = [super init]) {
		entryController = [[NSArrayController alloc] init];
		self.entries = [NSMutableArray array];
		[entryController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
		[entryController addObserver:self forKeyPath:@"arrangedObjects.line" options:0 context:nil];
		
		self.encoding = NSUTF8StringEncoding;
		self.autosave = NO;
  }
  return self;
}

- (void) dealloc {
	[entryController removeObserver:self forKeyPath:@"arrangedObjects.line"];
	[entryController removeObserver:self forKeyPath:@"arrangedObjects"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if (autosave) {
		NSError *err;
		if ([self writeToFile:self.path atomically:YES encoding:self.encoding error:&err]) {
			NSLog(@"Autosave succeeded");
		} else {
			NSLog(@"Autosave failed");
		}
	}
}

- (id) initWithUTF8ContentsOfFile: (NSString *) path_ error: (NSError **) error {
  self = [self initWithContentsOfFile:path_ encoding:NSUTF8StringEncoding error:error];
  return self;
}

- (id) initWithContentsOfFile: (NSString *) path_ encoding: (NSStringEncoding) encoding_ error: (NSError **) error {
  if (self = [self init]) {
    self.contents = [NSString stringWithContentsOfFile: path_ encoding: encoding_ error: error];
    self.encoding = encoding_;
    self.path = path_;
  }
  return self;
}

- (BOOL) writeToFile: (NSString *) path_ atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error {
	
	return [self.contents writeToFile:path_ atomically:useAuxiliaryFile encoding:enc error:error];
}

- (BOOL) writeToUTF8File: (NSString *) path_ atomically:(BOOL)useAuxiliaryFile error:(NSError **)error {

	return [self writeToFile:path_ atomically:useAuxiliaryFile encoding:NSUTF8StringEncoding error:error];
}

- (void) setEntries:(NSMutableArray *)entries_ {
	entries = entries_;
	[entryController setContent:entries];
}

- (NSString*) contents {
  NSMutableString *contents_ = [[NSMutableString alloc] init];

  for (int i = 0; i < [entryController.arrangedObjects count]; i++) {
    INIEntry *entry = [entryController.arrangedObjects objectAtIndex:i];
    [contents_ appendFormat:@"%@%@", entry.line, (i < [entryController.arrangedObjects count] -1) ? _lineEnding : @""];
  }

  return contents_;
}

- (void) setContents: (NSString *) contents_ {
	self.entries = [NSMutableArray array];

  // Determine newline: LF, CR, or CRLF
  NSRange firstLineEnd = [contents_ rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
  if ([[contents_ substringWithRange:firstLineEnd] isEqualToString:@"\n"]) {
    _lineEnding = @"\n";
  } else {
    NSRange lineEndTest = NSMakeRange(firstLineEnd.location, 2);
    NSString *newLinee = [contents_ substringWithRange:lineEndTest];
    if ([newLinee isEqualToString:@"\r\n"]) {
      _lineEnding = @"\r\n";
    } else {
      _lineEnding = @"\r";
    }
  }
	
  for (NSString *line in [contents_ componentsSeparatedByString:_lineEnding]) {
    [entryController addObject: [[INIEntry alloc] initWithLine: line]];
  }
}

- (NSString *) valueForKey: (NSString *) key {
  NSArray *values = [self valuesForKey: key];
    if ([values count] > 0) {
      return [values objectAtIndex:0];
    } else {
      return nil;
    }
}

- (NSMutableArray *) valuesForKey: (NSString *) key {
  NSMutableArray *values = [NSMutableArray array];
  for (INIEntry *entry in entryController.arrangedObjects) {
    if ([entry.key isEqualToString:key]) {
      [values addObject:entry.value];
    }
  }
  return values;
}

- (NSString *) valueForKey: (NSString *) key inSection: (NSString *) section {
  NSArray *values = [self valuesForKey: key inSection: section];
  if ([values count] > 0) {
    return [values objectAtIndex:0];
  } else {
    return nil;
  }
}

- (NSMutableArray *) valuesForKey: (NSString *) key inSection: (NSString *) section {
  NSMutableArray *values = [NSMutableArray array];
  NSString *currentSection = nil;

  for (INIEntry *entry in entryController.arrangedObjects) {
    if ([entry.section isEqualToString:section]) {
      currentSection = entry.section;
    }
    if ([entry.key isEqualToString:key] && [currentSection isEqualToString:section]) {
      [values addObject:entry.value];
    }
  }
  return values;
}

- (void) setValue: (NSString *) value forKey: (NSString *) key inSection: (NSString *) section {
	INIEntry *updatingEntry = nil;
	NSString *currentSection = nil;
	NSInteger sectionIndex = -1;
	
	// Find the section and entry to modify
	for (INIEntry *entry in entryController.arrangedObjects) {
		if ([entry.section isEqualToString:section]) {
			currentSection = entry.section;
			sectionIndex = [entryController.arrangedObjects indexOfObject:entry];
		}
		if ([entry.key isEqualToString:key] && [currentSection isEqualToString:section]) {
			updatingEntry = entry;
			break;
		}
	}

	if (updatingEntry) {
		updatingEntry.value = value;
		return;
	}

	if (sectionIndex < 0) {
		INIEntry *newSection = [INIEntry entryWithLine:[NSString stringWithFormat:@"[%@]", section]];
		[entryController addObject:newSection];
		sectionIndex = [entryController.arrangedObjects count] - 1;
	}
	
	updatingEntry = [INIEntry entryWithLine:[NSString stringWithFormat:@"%@ = %@", key, value]];
	[entryController insertObject:updatingEntry atArrangedObjectIndex:sectionIndex+1];
}

- (NSIndexSet *) sectionIndexes {
  return [entryController.arrangedObjects indexesOfObjectsPassingTest: ^(id entry, NSUInteger index, BOOL *stop) {
    return (BOOL)([(INIEntry *)entry type] == INIEntryTypeSection);
  }];
}

- (NSArray *) sections {
  return [entryController.arrangedObjects objectsAtIndexes: [self sectionIndexes]];
}

@end
