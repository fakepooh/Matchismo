//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Aliaksandr Palei on 01.06.13.
//  Copyright (c) 2013 Aliaksandr Palei. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
//	NSLog(@"Flips updated to %d...", self.flipCount);
}

- (CardMatchingGame *)game
{
	if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
														  usingDeck:[[PlayingCardDeck alloc] init]
														  usingMode:[self.gameMode titleForSegmentAtIndex:self.gameMode.selectedSegmentIndex]];
	self.gameMode.enabled = NO;
	return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
	_cardButtons = cardButtons;
	[self updateUI];
}

- (void)updateUI
{
	UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
	for (UIButton *cardButton in self.cardButtons) {
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
		[cardButton setTitle:card.contents forState:UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
		cardButton.selected = card.isFaceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
		[cardButton setImage:(cardButton.isSelected ? nil : cardBackImage) forState:UIControlStateNormal];
		cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (IBAction)flipCard:(UIButton *)sender {
	self.flipResult.text = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	[self updateUI];
}

- (IBAction)dealGame {
	self.game = nil;
	[self updateUI];
	self.flipResult.text = @"Tap a card to start";
	self.flipCount = 0;
	self.gameMode.enabled = YES;
}


@end
