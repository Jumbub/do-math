module OperandSpec (operandSpec) where

import Test.Hspec
import Control.Exception (evaluate)
import Control.Monad
import Data.Tuple
import Data.Maybe
import Data.Either

import Operand

stringify = [
        (((2,2), ("x", "x")), "2x/2x"),
        (((2,1), ("x", "x")), "2x/x"),
        (((1,1), ("x", "x")), "x/x"),
        (((1,1), ("", "x")), "1/x"),
        (((1,256), ("x", "")), "0.00390625x"),
        (((2,1), ("x", "")), "2x"),
        (((1,1), ("x", "")), "x"),
        (((1,1), ("yaz", "")), "ayz"),
        (((10,3), ("", "")), "10/3"),
        (((1,256), ("", "")), "0.00390625"),
        (((1,2), ("", "")), "0.5"),
        (((2,1), ("", "")), "2"),
        (((1,1), ("", "")), "1")
    ]

operandSpec :: IO ()
operandSpec = hspec $ do
    describe "can parse and convert operand to string" $ do
        forM_ stringify $ \(input, output) -> do
            it (show input ++ " => " ++ output) $ do
                (operandToString input) `shouldBe` output