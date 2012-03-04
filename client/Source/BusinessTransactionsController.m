/**
 * Copyright (c) 2012, Pecunia Project. All rights reserved.
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

#import "BusinessTransactionsController.h"
#import "LogController.h"

@implementation BusinessTransactionsController

- (id)initWithTransactions: (NSArray*)transactions;
{
	self = [super initWithWindowNibName: @"BusinessTransactionsWindow"];
    if (self != nil) {
        NSString* path = [[NSBundle mainBundle] resourcePath];
        path = [path stringByAppendingString: @"/HBCI business transactions.csv"];
	
        allTransactions = [[NSMutableDictionary dictionary] retain];
        NSError* error = nil;
        NSString* content = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error];
        if (error) {
            [[MessageLog log] addMessage: @"Error reading HBCI business transactions file" withLevel: LogLevel_Error];
        } else {
            NSArray* entries = [content componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
            for (content in entries) {
                NSArray* values = [content componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"\t"]];
                if ([values count] < 2) {
                    continue;
                }
                NSString* abbreviation = [[values objectAtIndex: 0] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"\"" ]];
                NSString* description = [[values objectAtIndex: 1] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"\"" ]];
                [allTransactions setObject: description forKey: abbreviation];
            }
        }
        
        NSArray* sortedTransactions = [transactions sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
        transactionList = [[NSMutableArray array] retain];
        for (size_t i = 0; i < [sortedTransactions count]; i++) {
            NSString* description = [allTransactions objectForKey: [sortedTransactions objectAtIndex: i]];
            if (description == nil) {
                description = NSLocalizedString(@"AP174", "no info");
            }
            [transactionList addObject: [NSArray arrayWithObjects: [sortedTransactions objectAtIndex: i], description, nil]];
        }
    }
	return self;
}

- (void)dealloc
{
    [allTransactions release];
    [transactionList release];
    [super dealloc];
}

- (IBAction)endSheet: (id)sender
{
	[[self window] orderOut: sender];
	[NSApp endSheet: [self window] returnCode: 0];
}

- (NSInteger)numberOfRowsInTableView: (NSTableView *)aTableView
{
    return [transactionList count];
}

- (id)tableView: (NSTableView *)aTableView objectValueForTableColumn: (NSTableColumn *)aTableColumn row: (NSInteger)rowIndex
{
    if ([aTableColumn.identifier isEqualTo: @"abbreviation"]) {
        return [[transactionList objectAtIndex: rowIndex] objectAtIndex: 0];
    } else {
        return [[transactionList objectAtIndex: rowIndex] objectAtIndex: 1];
    }
}

@end
