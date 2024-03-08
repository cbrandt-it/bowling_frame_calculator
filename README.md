# FrameCalculator

The `FrameCalculator` is a Ruby utility designed to calculate the total score of a bowling game based on the individual rolls throughout the frames. It takes into account the complexities of scoring in bowling, including strikes, spares, and the special rules for the 10th frame.

## Features

- Handles an array of rolls as input, representing the knocked-down pins for each roll.
- Accurately calculates scores with consideration for strikes, spares, and the 10th frame bonuses.
- Provides score calculation as an array, with each element representing the score of a complete frame or `nil` for incomplete frames.

## Tests

Run tests with `rake` or `rake test`