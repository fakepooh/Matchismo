//
//  PlayingCard.m
//  Matchismo
//
//  Created by Aliaksandr Palei on 01.06.13.
//  Copyright (c) 2013 Aliaksandr Palei. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
	int score = 0;
	
	if (otherCards.count == 1) {
		PlayingCard *otherCard = [otherCards lastObject];
		if ([otherCard.suit isEqualToString:self.suit]) {
			score = 1; // probability = 12/51 = 0,23529412
		} else if (otherCard.rank == self.rank) {
			score = 4; // probability = 3/51 = 0,058823529
		}
	} else if (otherCards.count == 2)
	{
		PlayingCard *card2 = otherCards[0];
		PlayingCard *card3 = otherCards[1];
		if ([card2.suit isEqualToString:self.suit] && [card2.suit isEqualToString:card3.suit]) {
			score = 5; // probability = 12/51*11/50 = 0,051764706
		} else if ((self.rank == card2.rank) && (card2.rank == card3.rank)) {
			score = 100; // probability = 3/51*2/50 = 0,0023529412
		} else {
			score = [self match:@[card2]] + [self match:@[card3]] + [card2 match:@[card3]];
		}
	}
	return score;
}

- (NSString *)contents
{
	return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (NSString *)description
{
	return [self contents];
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
