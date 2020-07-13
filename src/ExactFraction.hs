module ExactFraction (
    ExactFraction,
    ExactFraction.fromNumber,
    ExactFraction.simplify,
    ExactFraction.add,
    ExactFraction.subtract,
    ExactFraction.multiply,
    ExactFraction.divide,
    ExactFraction.absolute,
    ExactFraction.flipSign,
    ExactFraction.commonDenominators,
    ExactFraction.compare,
) where

import Data.Sort

type ExactFraction = (Integer, Integer)

simplify a = simplify' $ normalise a
add a b = simplify $ add' (normalise a) (normalise b)
subtract a b = simplify $ subtract' (normalise a) (normalise b)
multiply a b = simplify $ multiply' (normalise a) (normalise b)
divide a b = simplify $ divide' (normalise a) (normalise b)
absolute a = simplify $ absolute' (normalise a)
flipSign a = simplify $ flipSign' (normalise a)

fromNumber :: Integer -> ExactFraction
fromNumber a = (a, 1)

compare :: ExactFraction -> ExactFraction -> Ordering
compare a b
    | an == bn = EQ
    | an < bn = LT
    | an > bn = GT
    where
        ((an, ad), (bn, bd)) = commonDenominators (a, b)

commonDenominators :: (ExactFraction, ExactFraction) -> (ExactFraction, ExactFraction)
commonDenominators ((an, ad), (bn, bd)) = (a', b')
    where
        commonDen = lcm ad bd
        am = div commonDen ad
        bm = div commonDen bd
        a' = (an * am, ad * am)
        b' = (bn * bm, bd * bm)

normalise :: ExactFraction -> ExactFraction
normalise (0, _) = (0, 1)
normalise (n, d)
    | n == 0 = (0, 1)
    | d < 0 = (-n, -d)
    | otherwise = (n, d)

simplify' :: ExactFraction -> ExactFraction
simplify' (n, d) = (simpleN, simpleD)
    where
        commonDen = gcd n d
        simpleN = n `div` commonDen
        simpleD = d `div` commonDen

add' :: ExactFraction -> ExactFraction -> ExactFraction
add' a b = (an' + bn', ad')
    where
        ((an', ad'), (bn', _)) = commonDenominators (a, b)

subtract' :: ExactFraction -> ExactFraction -> ExactFraction
subtract' a (bn, bd) = add' a (-bn, bd)

multiply' :: ExactFraction -> ExactFraction -> ExactFraction
multiply' (an, ad) (bn, bd) = (an * bn, ad * bd)
        
divide' :: ExactFraction -> ExactFraction -> ExactFraction
divide' a (bn, bd) = multiply' a (bd, bn)
        
absolute' :: ExactFraction -> ExactFraction
absolute' (n, d) = (abs n, d)

flipSign' :: ExactFraction -> ExactFraction
flipSign' (n, d) = (-n, d)