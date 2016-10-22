// © 2016-2017 Robert Corrigan
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import <XCTest/XCTest.h>
#import "INI.h"

@interface INI_File_Tests : XCTestCase

@end

@implementation INI_File_Tests

- (void)setUp {
	[super setUp];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSURL *source = [bundle URLForResource:@"test_lf" withExtension:@"ini"];
	NSURL *dest = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] URLByAppendingPathComponent:@"test_write.ini"];
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	NSError *err;
	[fm copyItemAtURL:source toURL:dest error:&err];
	XCTAssertNil(err);
}

- (void)tearDown {
  NSURL *dest = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] URLByAppendingPathComponent:@"test_write.ini"];
  NSFileManager *fm = [[NSFileManager alloc] init];
  
  NSError *err;
  [fm removeItemAtURL:dest error:&err];
  XCTAssertNil(err);

	[super tearDown];
}

- (void)testINIFile_initWithUTF8ContentsOfFile_CRLF {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_crlf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 10);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.lineEnding, @"\r\n");
}

- (void)testINIFile_initWithUTF8ContentsOfFile_CR {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_cr" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 10);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.lineEnding, @"\r");
}

- (void)testINIFile_initWithUTF8ContentsOfFile_LF {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 11);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.lineEnding, @"\n");
}

- (void)testINIFile_sections {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config sections] count], 2);
}

- (void)testINIFile_valueForKey_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name"], @"Mirek Rusin");
}

- (void)testINIFile_valuesForKey_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name"];
	XCTAssertEqual([values count], 2);
	XCTAssertEqualObjects([values objectAtIndex:0], @"Mirek Rusin");
	XCTAssertEqualObjects([values objectAtIndex:1], @"MirekRusin");
}

- (void)testINIFile_valueForKey_InSection_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name" inSection:@"github"], @"MirekRusin");
}

- (void)testINIFile_valuesForKey_InSection_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name" inSection:@"github"];
	XCTAssertEqual([values count], 1);
	XCTAssertEqualObjects([values objectAtIndex:0], @"MirekRusin");
}

- (void)testINIFile_valueForKey_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertNil([config valueForKey:@"nam"]);
}

- (void)testINIFile_valuesForKey_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"nam"];
	XCTAssertEqual([values count], 0);
}

- (void)testINIFile_valueForKey_InSection_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertNil([config valueForKey:@"name" inSection:@"use"]);
}

- (void)testINIFile_valuesForKey_InSection_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name" inSection:@"use"];
	XCTAssertEqual([values count], 0);
}

- (void)testINIFile_setValue_forKey_inSection_NewSectionNewKey {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	[config setValue:@"newValue" forKey:@"newKey" inSection:@"newSection"];
	XCTAssertEqualObjects([config valueForKey:@"newKey" inSection:@"newSection"], @"newValue");
}

- (void)testINIFile_setValue_forKey_inSection_ExistingSectionNewKey {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	[config setValue:@"newValue" forKey:@"newKey" inSection:@"github"];
	XCTAssertEqualObjects([config valueForKey:@"newKey" inSection:@"github"], @"newValue");
}

- (void)testINIFile_setValue_forKey_inSection_ExistingSectionExistingKey {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	XCTAssertEqualObjects([config valueForKey:@"name" inSection:@"github"], @"MirekRusin");
	[config setValue:@"rjcorrig" forKey:@"name" inSection:@"github"];
	XCTAssertEqualObjects([config valueForKey:@"name" inSection:@"github"], @"rjcorrig");
}

- (void)testINIFile_writeFile {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_write.ini"];
	NSError *err;
	
	INIFile *srcConfig = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	XCTAssertNil(err);
	XCTAssertNil([srcConfig valueForKey:@"newKey" inSection:@"newSection"]);
	
	[srcConfig setValue:@"newValue" forKey:@"newKey" inSection:@"newSection"];
	XCTAssertEqualObjects([srcConfig valueForKey:@"newKey" inSection:@"newSection"], @"newValue");

	[srcConfig writeToUTF8File:path atomically:YES error:&err];
	
	XCTAssertNil(err);

	INIFile *destConfig = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	XCTAssertEqualObjects(destConfig.contents, srcConfig.contents);
}

- (void)testINIFile_writeFile_noPath {
	INIFile *srcConfig = [[INIFile alloc] init];
	XCTAssertNil([srcConfig valueForKey:@"newKey" inSection:@"newSection"]);
	
	[srcConfig setValue:@"newValue" forKey:@"newKey" inSection:@"newSection"];
	XCTAssertEqualObjects([srcConfig valueForKey:@"newKey" inSection:@"newSection"], @"newValue");
	
	NSError *err;
	[srcConfig writeToUTF8File:srcConfig.path atomically:YES error:&err];
	
	XCTAssertNotNil(err);
}

- (void)testINIFile_writeFile_autosave {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_write.ini"];
	NSError *err;
	
	INIFile *srcConfig = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	XCTAssertNil(err);
	XCTAssertNil([srcConfig valueForKey:@"newKey" inSection:@"newSection"]);
	
	srcConfig.autosave = YES;
	[srcConfig setValue:@"newValue" forKey:@"newKey" inSection:@"newSection"];
	XCTAssertEqualObjects([srcConfig valueForKey:@"newKey" inSection:@"newSection"], @"newValue");
	
	INIFile *destConfig = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	XCTAssertEqualObjects(destConfig.contents, srcConfig.contents);
}

@end
