/**
 * Copyright (c) 2011, 2012, Pecunia Project. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; version 2 of the
 * License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301  USA
 */

#import "MainBackgroundView.h"
#import "GraphicsAdditions.h"

/**
 * Provides a custom background for the main view in the account page (and potentially other views).
 */
@implementation MainBackgroundView

- (void) dealloc
{
    [super dealloc];
}

static NSImage* background = nil;

- (void)drawRect: (NSRect)dirtyRect
{
    if (background == nil) {
        background = [NSImage imageNamed: @"background-pattern.png"];
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    NSRect bounds = [self bounds];
    bounds.size.height -= 61; // Upper border transfer list.
    NSColor* color;
    if (background != nil) {
        color = [NSColor colorWithPatternImage: background];
    } else {
        color = [NSColor colorWithDeviceWhite: 110.0 / 255.0 alpha: 1];
    }
    [color setFill];
	[NSBezierPath fillRect: [self bounds]];
    
    bounds.origin.x = 0;
    bounds.origin.y = bounds.size.height; // Area above the transfer list.
    bounds.size.height = 61;
    
    
    NSGradient* topGradient = [[[NSGradient alloc]
                                initWithColorsAndLocations:
                                [NSColor colorWithDeviceWhite: 60 / 255.0 alpha: 1], (CGFloat) 0,
                                [NSColor colorWithDeviceWhite: 100 / 255.0 alpha: 1], (CGFloat) 1,
                                nil
                                ]
                               autorelease];
    
	[topGradient drawInRect: bounds angle: 90.0];
    
    // Category sum area.
    int height = [self bounds].size.height;
    bounds.size.height--;
    int radius = 10;
    NSBezierPath* catSumAreaPath = [NSBezierPath bezierPath];
    [catSumAreaPath moveToPoint: NSMakePoint(bounds.size.width, height - bounds.size.height)];
    [catSumAreaPath lineToPoint: NSMakePoint(bounds.size.width - 240, height - bounds.size.height)];
    [catSumAreaPath appendBezierPathWithArcFromPoint: NSMakePoint(bounds.size.width - 240 + radius, height - bounds.size.height)
                                             toPoint: NSMakePoint(bounds.size.width - 240 + radius, height - bounds.size.height + radius) radius: radius];
    [catSumAreaPath appendBezierPathWithArcFromPoint: NSMakePoint(bounds.size.width - 220 + radius, height)
                                             toPoint: NSMakePoint(bounds.size.width - 220 + 2 * radius, height) radius: radius];
    [catSumAreaPath lineToPoint: NSMakePoint(bounds.size.width, height)];
    [catSumAreaPath lineToPoint: NSMakePoint(bounds.size.width, height - bounds.size.height)];
    
    // Draw the background.
    topGradient = [[[NSGradient alloc]
                    initWithColorsAndLocations:
                    [NSColor colorWithDeviceRed: 213 / 256.0 green: 208 / 255.0f blue: 187 / 255.0f alpha: 1], (CGFloat) 0,
                    [NSColor colorWithDeviceRed: 233 / 256.0 green: 228 / 255.0f blue: 204 / 255.0f alpha: 1], (CGFloat) 1,
                    nil
                    ]
                   autorelease];
    
    [topGradient drawInBezierPath: catSumAreaPath angle: 90];
    
    /*
     catSumAreaPath = [NSBezierPath bezierPath];
     [catSumAreaPath moveToPoint: NSMakePoint(47, bounds.size.height - 10)];
     [catSumAreaPath appendBezierPathWithArcFromPoint: NSMakePoint(47, bounds.size.height - 210)
     toPoint: NSMakePoint(39, bounds.size.height - 210) radius: 8];
     [catSumAreaPath lineToPoint: NSMakePoint(10, bounds.size.height - 210)];
     */
    
    NSShadow* innerShadow1 = [[[NSShadow alloc] initWithColor: [NSColor blackColor]
                                                       offset: NSMakeSize(2.0, 0)
                                                   blurRadius: 5.0] autorelease];
    NSShadow* innerShadow2 = [[[NSShadow alloc] initWithColor: [NSColor colorWithCalibratedWhite: 0.0 alpha: .52]
                                                       offset: NSMakeSize(2.0, -2.0) blurRadius: 12.0] autorelease];
    
    // Twofold inner shadow.
    [catSumAreaPath fillWithInnerShadow: innerShadow1 borderOnly: NO];
    [catSumAreaPath fillWithInnerShadow: innerShadow2 borderOnly: NO];
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
