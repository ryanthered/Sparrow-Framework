//
//  SPDisplayObjectTest.h
//  Sparrow
//
//  Created by Daniel Sperl on 13.04.09.
//  Copyright 2009 Incognitek. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "SPMatrix.h"
#import "SPMakros.h"
#import "SPPoint.h"
#import "SPSprite.h"
#import "SPQuad.h"


// -------------------------------------------------------------------------------------------------

@interface SPDisplayObjectTest : SenTestCase 
{
}

@end

// -------------------------------------------------------------------------------------------------

@implementation SPDisplayObjectTest

- (void) setUp
{
}

- (void) tearDown
{
}

#pragma mark -

- (void)testRoot
{
    SPSprite *root = [[SPSprite alloc] init];    
    SPSprite *child = [[SPSprite alloc] init];
    SPSprite *grandChild = [[SPSprite alloc] init];
    
    [root addChild:child];
    [child addChild:grandChild];
    
    STAssertEqualObjects(root, grandChild.root, @"wrong root");
    
    [grandChild release];
    [child release];
    [root release];    
}

- (void)testTransformationMatrixToSpace
{
    // is tested indirectly via 'testBoundsInSpace' in DisplayObjectContainerTest
}

- (void)testTransformationMatrix
{
    SPSprite *sprite = [[SPSprite alloc] init];
    sprite.x = 50;
    sprite.y = 100;
    sprite.rotationZ = PI / 4;
    sprite.scaleX = 0.5;
    sprite.scaleY = 1.5;
    
    SPMatrix *matrix = [[SPMatrix alloc] init];
    [matrix scaleXBy:sprite.scaleX yBy:sprite.scaleY];
    [matrix rotateBy:sprite.rotationZ];
    [matrix translateXBy:sprite.x yBy:sprite.y];
    
    STAssertEqualObjects(sprite.transformationMatrix, matrix, @"wrong matrix");
    
    [sprite release];
    [matrix release];
}

- (void)testBounds
{
    SPQuad *quad = [[SPQuad alloc] initWithWidth:10 height:20];
    quad.x = -10;
    quad.y = 10;
    quad.rotationZ = PI_HALF;
    SPRectangle *bounds = quad.bounds;
    
    STAssertTrue(SP_IS_FLOAT_EQUAL(-30, bounds.x), @"wrong bounds.x: %f", bounds.x);
    STAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.y), @"wrong bounds.y: %f", bounds.y);
    STAssertTrue(SP_IS_FLOAT_EQUAL(20, bounds.width), @"wrong bounds.width: %f", bounds.width);
    STAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.height), @"wrong bounds.height: %f", bounds.height);
    
    bounds = [quad boundsInSpace:quad];
    STAssertTrue(SP_IS_FLOAT_EQUAL(0, bounds.x), @"wrong inner bounds.x: %f", bounds.x);
    STAssertTrue(SP_IS_FLOAT_EQUAL(0, bounds.y), @"wrong inner bounds.y: %f", bounds.y);
    STAssertTrue(SP_IS_FLOAT_EQUAL(10, bounds.width), @"wrong inner bounds.width: %f", bounds.width);
    STAssertTrue(SP_IS_FLOAT_EQUAL(20, bounds.height), @"wrong innter bounds.height: %f", bounds.height);
    
    [quad release];
}

- (void)testLocalToGlobal
{
    SPSprite *sprite = [[SPSprite alloc] init];
    sprite.x = 10;
    sprite.y = 20;    
    SPSprite *sprite2 = [[SPSprite alloc] init];
    sprite2.x = 150;
    sprite2.y = 200;    
    [sprite addChild:sprite2];
    
    SPPoint *localPoint = [SPPoint pointWithX:0 y:0];
    SPPoint *globalPoint = [sprite2 localToGlobal:localPoint];
    SPPoint *expectedPoint = [SPPoint pointWithX:160 y:220];    
    STAssertEqualObjects(expectedPoint, globalPoint, @"wrong global point:");    
    
    [sprite release];
    [sprite2 release];
}

- (void)testGlobalToLocal
{
    SPSprite *sprite = [[SPSprite alloc] init];
    sprite.x = 10;
    sprite.y = 20;
    SPSprite *sprite2 = [[SPSprite alloc] init];
    sprite2.x = 150;
    sprite2.y = 200;    
    [sprite addChild:sprite2];
    
    SPPoint *globalPoint = [SPPoint pointWithX:160 y:220];
    SPPoint *localPoint = [sprite2 globalToLocal:globalPoint];
    SPPoint *expectedPoint = [SPPoint pointWithX:0 y:0];    
    STAssertEqualObjects(expectedPoint, localPoint, @"wrong local point");    
    
    [sprite release];
    [sprite2 release];
}

- (void)testHitTestPoint
{
    SPQuad *quad = [[SPQuad alloc] initWithWidth:25 height:10];
    
    STAssertNotNil([quad hitTestPoint:[SPPoint pointWithX:15 y:5]], @"point should be inside");
    STAssertNotNil([quad hitTestPoint:[SPPoint pointWithX:0 y:0]],  @"point should be inside");
    STAssertNotNil([quad hitTestPoint:[SPPoint pointWithX:25 y:0]], @"point should be inside");
    STAssertNotNil([quad hitTestPoint:[SPPoint pointWithX:25 y:10]], @"point should be inside");
    STAssertNotNil([quad hitTestPoint:[SPPoint pointWithX:0 y:10]], @"point should be inside");
    STAssertNil([quad hitTestPoint:[SPPoint pointWithX:-1 y:-1]], @"point should be outside");    
    STAssertNil([quad hitTestPoint:[SPPoint pointWithX:26 y:11]], @"point should be outside");
    
    quad.isVisible = NO;
    STAssertNil([quad hitTestPoint:[SPPoint pointWithX:15 y:5]], @"hitTest should fail, object invisible");
    
    [quad release];
}

@end