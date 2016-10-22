// © 2016 Robert Corrigan
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import <XCTest/XCTest.h>
#import "INI.h"

@interface INI_Entry_Tests : XCTestCase

@end

@implementation INI_Entry_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testINIEntry_EntryWithLine_KeyAndValue {
	NSString *line = @"  username  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"mirek");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);

	XCTAssertEqual(entry.info.value.location, 16);
	XCTAssertEqual(entry.info.value.length, 5);

	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_EntryWithLine_KeyWithSpacesAndValue {
	NSString *line = @"  user name  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"user name");
	XCTAssertEqualObjects(entry.value, @"mirek");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 9);
	
	XCTAssertEqual(entry.info.value.location, 17);
	XCTAssertEqual(entry.info.value.length, 5);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_EntryWithLine_KeyOnly {
	NSString *line = @"  username  \t=";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");

	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);
	
	XCTAssertEqual(entry.info.value.location, 14);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);

	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_EntryWithLine_KeyOnlyNoEqualSignTrailing {
	NSString *line = @"  username  \t";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeOther);
}

- (void)testINIEntry_EntryWithLine_KeyOnlyNoEqualSign {
	NSString *line = @"username";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeOther);
}

- (void)testINIEntry_EntryWithLine_Section {
	NSString *line = @" [section] ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"section");

	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 2);
	XCTAssertEqual(entry.info.section.length, 7);

	XCTAssertEqual(entry.type, INIEntryTypeSection);
}

- (void)testINIEntry_EntryWithLine_Comment {
	NSString *line = @"# [section] ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeComment);
}

- (void)testINIEntry_EntryWithLine_Blank {
	NSString *line = @"";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeOther);
}

- (void)testINIEntry_SetKey {
	NSString *line = @"  username  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];

	NSString *expectedLine = [line stringByReplacingOccurrencesOfString:@"username" withString:@"accountname"];

	entry.key = @"accountname";
	XCTAssertEqualObjects(entry.line, expectedLine);
	XCTAssertEqualObjects(entry.key, @"accountname");
	XCTAssertEqualObjects(entry.value, @"mirek");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 11);
	
	XCTAssertEqual(entry.info.value.location, 19);
	XCTAssertEqual(entry.info.value.length, 5);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_SetKeyBlank_ShouldIgnore {
	NSString *line = @"  username  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	entry.key = @"";
	XCTAssertEqualObjects(entry.line, line);
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"mirek");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);
	
	XCTAssertEqual(entry.info.value.location, 16);
	XCTAssertEqual(entry.info.value.length, 5);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_SetValue {
	NSString *line = @"  username  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	NSString *expectedLine = [line stringByReplacingOccurrencesOfString:@"mirek" withString:@"rjcorrig"];
	
	entry.value = @"rjcorrig";
	XCTAssertEqualObjects(entry.line, expectedLine);
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"rjcorrig");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);
	
	XCTAssertEqual(entry.info.value.location, 16);
	XCTAssertEqual(entry.info.value.length, 8);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_SetValueBlank {
	NSString *line = @"  username  \t=  mirek  ";
	INIEntry *entry = [INIEntry entryWithLine: line];
	
	NSString *expectedLine = [line stringByReplacingOccurrencesOfString:@"mirek" withString:@""];
	
	entry.value = @"";
	XCTAssertEqualObjects(entry.line, expectedLine);
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);
	
	XCTAssertEqual(entry.info.value.location, 18);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

@end
