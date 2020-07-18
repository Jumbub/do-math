module SolveSpec (solveSpec) where

import Test.Hspec
import Control.Exception (evaluate)
import Control.Monad
import Data.Tuple
import Data.Either

import Solve
import Operand
import Operator
import Context

fracCtx = defaultContext { fractionResult = True }
decCtx = defaultContext { fractionResult = False, decimalPlaces = 5 }

same :: String -> [(String, Context, String, Context)]
same input = [("as fraction", fracCtx, input, fracCtx), ("as decimal", decCtx, input, decCtx)]

diff :: String -> String -> [(String, Context, String, Context)]
diff a b = [("as fraction", fracCtx, a, fracCtx), ("as decimal", decCtx, b, decCtx)]

ctxChange :: String -> (Context -> Context) -> [(String, Context, String, Context)]
ctxChange input change = [("as fraction", fracCtx, input, change fracCtx), ("as decimal", decCtx, input, change decCtx)]

setFractional :: Bool -> (Context -> Context)
setFractional val = setFractional'
    where
        setFractional' :: Context -> Context
        setFractional' context = context {fractionResult = val}

solveTests = [
        ("", same "Not enough operands!"),
        ("APPROXIMATE(1)", ctxChange "1" (setFractional False)),
        ("APPROXIMATE(0)", ctxChange "0" (setFractional True)),
        ("PI", diff "π" "3.14159 ± 1/100000"),
        ("5-5-5", diff "-5" "-5"),
        ("5/5/5", diff "1/5" "0.2"),
        ("PLUSORMINUS(1, 0.001) + PLUSORMINUS(1, 0.001)", same "2 ± 1/500"),
        ("0.000001", diff "1/1000000" "0.00000 ± 1/100000"),
        ("22/7", diff "22/7" "3.14285 ± 1/100000"),
        ("10/3", diff "10/3" "3.(3)"),
        ("1-(-1)", same "2"),
        ("0.125 + 0.125", diff "1/4" "0.25"),
        ("0.124", diff "31/250" "0.124"),
        ("2+((4+8)*16/(32-64))", same "-4"),
        ("8*(4+2)", same "48"),
        ("(2+4)*8", same "48"),
        ("1+2-3*4/5", diff "3/5" "0.6"),
        ("8*4+2", same "34"),
        ("2+4*8", same "34"),
        ("2/10", diff "1/5" "0.2"),
        ("10/2", same "5"),
        ("2*3", same "6"),
        ("1-1", same "0"),
        ("1+1", same "2"),
        ("1", same "1")
    ]

operandsToString :: Context -> [Operand] -> String
operandsToString context operands = show (map (operandToString context) operands)

solveSpec :: IO ()
solveSpec = hspec $ do
    describe "can solve expressions" $ do
        forM_ solveTests $ \(input, outputs) -> do
            forM_ outputs $ \(label, ctx, output, expectedCtx) -> do
                it (input ++ " => " ++ output ++ " (" ++ label ++ ")") $ do
                    let (ctx', actual) = solve ctx input
                    actual `shouldBe` output
                    ctx' `shouldBe` expectedCtx
