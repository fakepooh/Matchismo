//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Aliaksandr Palei on 01.06.13.
//  Copyright (c) 2013 Aliaksandr Palei. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) int mode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
	if (!_cards) {
		_cards = [[NSMutableArray alloc] init];
	}
	return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck usingMode:(NSString *)mode
{
	self = [super init];
	
	if (self) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				self.cards[i] = card;
			} else {
				self = nil;
				break;
			}
		}
	}
	
	if ([mode isEqualToString:@"3-cards"]) {
		self.mode = 3;
	} else {
		self.mode = 2;
	}
	
	return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (NSString *)flipCardAtIndex:(NSUInteger)index
{
	Card *card = self.cards[index];
	NSString *result;
	NSMutableArray *otherCards = [[NSMutableArray alloc] initWithCapacity:2];
	
	if (!card.isUnplayable) {
		result = [NSString stringWithFormat:@"Flipped down %@", card.contents];
		if (!card.isFaceUp) {
			result = [NSString stringWithFormat:@"Flipped up %@", card.contents];
			for (Card *otherCard in self.cards) { // creating an array with already flipped up cards
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					[otherCards addObject:otherCard];
				}
			}
			if ([otherCards count] == self.mode - 1) {				
				int matchScore = [card match:otherCards];
				[otherCards addObject:card]; // adding card to array to simplify message creation and group processing
				if (matchScore) {
					for (Card *otherCard in otherCards) {
						otherCard.unplayable = YES;
					}
					self.score += matchScore * MATCH_BONUS;
					result = [NSString stringWithFormat:@"Matched %@ for %d points!", [otherCards componentsJoinedByString:@" & "], matchScore * MATCH_BONUS];
				} else {
					if ([otherCards count] >= self.mode) {
						for (Card *otherCard in otherCards) {
							otherCard.faceUp = NO;
						}
						self.score -= MISMATCH_PENALTY;
						result = [NSString stringWithFormat:@"%@ don't match! %d points penalty!", [otherCards componentsJoinedByString:@" & "], MISMATCH_PENALTY];
					}
				}
			}
			self.score -= FLIP_COST;
		}
		card.faceUp = !card.isFaceUp;
	}
	
	return result;
}

@end
