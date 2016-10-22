// Original code © 2010 Mirek Rusin
// Modified code © 2016 Robert Corrigan
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIEntry.h"

@implementation INIEntry

@synthesize type;
@synthesize info;
@synthesize line;

- (id) init {
  if (self = [super init]) {
    info.section = NSMakeRange(0, 0);
    info.key = NSMakeRange(0, 0);
    info.value = NSMakeRange(0, 0);
    type = INIEntryTypeOther;
  }
  return self;
}

- (id) initWithLine: (NSString *) line_ {
  if (self = [self init]) {
    self.line = [line_ mutableCopy];
  }
  return self;
}

+ (INIEntry *) entryWithLine: (NSString *) line {
  return [[INIEntry alloc] initWithLine: line];
}

- (void) setLine: (NSString *) line_ {
  line = line_;
  [self parse];
}

- (void) parse {
  info.section = NSMakeRange(0, 0);
  info.key = NSMakeRange(0, 0);
  info.value = NSMakeRange(0, 0);
  type = INIEntryTypeOther;
	
	NSError *error;
	NSRegularExpression *regex;
	NSRange lineRange = NSMakeRange(0, [self.line length]);

	// Key-value pair
	regex = [NSRegularExpression
		 regularExpressionWithPattern:@"^\\s*([^=;#\\r\\n]+?)\\s*=\\s*([^;#\\r\\n]*)\\s*"
		 options:0
		 error:&error];
	
	if (regex) {
		NSTextCheckingResult *match = [regex firstMatchInString:self.line options:0 range:lineRange];
		if (match) {
			info.key = [match rangeAtIndex:1];
			info.value = [match rangeAtIndex:2];
			
			// Trim info.value.length to remove trailing spaces
			NSString *valueTrim = [self.line substringWithRange:info.value];
			valueTrim = [valueTrim stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			info.value.length = [valueTrim length];
			
			type = INIEntryTypeKeyValue;
			return;
		}
	}

	// Section
	regex = [NSRegularExpression
		 regularExpressionWithPattern:@"^\\s*\\[([^\\]\\r\\n]+)]\\s*"
		 options:0
		 error:&error];
	
	if (regex) {
		NSTextCheckingResult *match = [regex firstMatchInString:self.line options:0 range:lineRange];
		if (match) {
			info.section = [match rangeAtIndex:1];
			type = INIEntryTypeSection;
			return;
		}
	}
	
	// Comment
	regex = [NSRegularExpression
		 regularExpressionWithPattern:@"^\\s*[;#]+"
		 options:0
		 error:&error];
	
	if (regex) {
		NSTextCheckingResult *match = [regex firstMatchInString:self.line options:0 range:lineRange];
		if (match) {
			type = INIEntryTypeComment;
			return;
		}
	}
	
}

- (NSString *) key {
  return [line substringWithRange: info.key];
}

- (void) setKey: (NSString *) key_ {
	if ([[key_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
		line = [line stringByReplacingOccurrencesOfString:self.key withString:key_];
		[self parse];
	}
}

- (NSString *) value {
  return [line substringWithRange: info.value];
}

- (void) setValue: (NSString *) value_ {
	line = [line stringByReplacingOccurrencesOfString:self.value withString:value_];
	[self parse];
}

- (NSString *) section {
  return [line substringWithRange: info.section];
}

@end
