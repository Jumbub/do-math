module Context (
    Context(..),
    defaultContext,
) where

import ExactFraction

data Context = Context {
    internalDecimalPlaces :: Integer,
    decimalResult :: Bool,
    decimalPlaces :: Integer
} deriving (Eq, Show)

defaultContext :: Context
defaultContext = Context {decimalResult = True, decimalPlaces = 5, internalDecimalPlaces = 5}
