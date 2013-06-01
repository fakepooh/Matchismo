//
//  PlayingCard.m
//  Matchismo
//
//  Created by Aliaksandr Palei on 01.06.13.
//  Copyright (c) 2013 Aliaksandr Palei. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
	return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit
{
	return _suit ? _suit : @"?";
}

+ (NSArray *)validSuits
{
	static NSArray *validSuits;
	if (!validSuits) {
		validSuits = @[@"♥", @"♦", @"♠", @"♣"];
	}
	return validSuits;
}

+ (NSUInteger)maxRank
{
	return 13;
}

+ (NSArray *)rankStrings
{
	static NSArray *rankStrings;
	
	if (!rankStrings) {
		rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
	}
	
	return rankStrings;
}

@end
