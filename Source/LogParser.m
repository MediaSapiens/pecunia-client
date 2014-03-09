/**
 * Copyright (c) 2009, 2014, Pecunia Project. All rights reserved.
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

#import "LogParser.h"
#import "HBCIBridge.h"
#import "MessageLog.h"

@implementation LogParser

- (id)initWithParent: (id)par level: (NSString *)lev
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    parent = par;
    if (lev) {
        level = lev.intValue;
    } else {
        level = HBCILogDebug;
    }
    currentValue = [[NSMutableString alloc] init];
    return self;
}

- (void)parser: (NSXMLParser *)parser didStartElement: (NSString *)elementName namespaceURI: (NSString *)namespaceURI qualifiedName: (NSString *)qName attributes: (NSDictionary *)attributeDict
{
}

- (void)parser: (NSXMLParser *)parser foundCharacters: (NSString *)string
{
    [currentValue appendString: string];
}

- (void)parser: (NSXMLParser *)parser didEndElement: (NSString *)elementName namespaceURI: (NSString *)namespaceURI qualifiedName: (NSString *)qName
{
    if ([elementName isEqualToString: @"log"]) {
        [parser setDelegate: parent];
        LogComTrace(level, currentValue);
        return;
    }
}

@end
