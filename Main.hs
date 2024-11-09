module Main where
import Data.Char

main :: IO ()
main = putStrLn "Hello, world!"

-- Exercícios 2
-- 2.4 a
insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
insert x (y : ys)
  | x <= y = x : y : ys
  | otherwise = y : insert x ys

-- 2.4 b
isort :: (Ord a) => [a] -> [a]
isort xs = foldr insert [] xs

-- 2.6
sumOfSquares :: Int
sumOfSquares = sum [x * x | x <- [1 .. 100]]

-- 2.7 a
aprox :: Int -> Double
aprox n = 4 * sum [(-1) ** k / (2 * k + 1) | k <- [0 .. n']] where n' = fromIntegral n

-- 2.9
divprop :: Int -> [Int]
divprop n = [x | x <- [1 .. n - 1], n `mod` x == 0]

-- 2.12
primo :: Int -> Bool
primo n = divprop n == [1]

-- 2.15
cifrar :: Int -> String -> String
cifrar n txt = [if x == ' ' then ' ' else chr (ord x + n) | x <- txt]

-- 2.16
concat2 :: [[a]] -> [a]
concat2 xss = [x | xs <- xss, x <- xs]

replicate2 :: Int -> a -> [a]
replicate2 n x = [x | _ <- [1 .. n]]

and2 :: [Bool] -> Bool
and2 [] = True
and2 (x : xs) = x && and2 xs

-- 2.20
transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([] : _) = []
transpose ((x : xs) : ys) = (x : map head ys) : transpose (xs : map tail ys)

-- 2.21
algarismosRev :: Int -> [Int]
algarismosRev n
  | n < 10 = [n]
  | otherwise = (n `mod` 10) : algarismosRev (n `div` 10)

algarismos :: Int -> [Int]
algarismos n = reverse (algarismosRev n)

-- Exercício 3
-- 3.6
mdc :: Int -> Int -> Int
mdc a b = fst (until (\(a, b) -> b == 0) (\(a, b) -> (b, a `mod` b)) (a, b))

-- 3.7
-- a
-- (++) :: [a] -> [a] -> [a]
-- (++) xs ys = foldr (:) ys xs

-- b
concat :: [[a]] -> [a]
concat xss = foldr (++) [] xss

-- c
reverseR :: [a] -> [a]
reverseR xs = foldr (\x y -> y ++ [x]) [] xs

-- d
reverseL :: [a] -> [a]
reverseL xs = foldl (\y x -> x : y) [] xs

-- e
elemR :: (Eq a) => a -> [a] -> Bool
elemR x xs = any (x ==) xs

-- 3.8
-- a
palavras :: String -> [String]
palavras [] = []
palavras (' ' : xs) = palavras xs
palavras xs = takeWhile (/= ' ') xs : palavras (dropWhile (/= ' ') xs)

-- b
despalavras :: [String] -> String
despalavras [] = []
despalavras [x] = x
despalavras (x : xs) = x ++ ' ' : despalavras xs

-- Exercício 4
data Arv a = Vazia | No a (Arv a) (Arv a)

-- 4.1
sumArv :: Num a => Arv a -> a
sumArv Vazia = 0
sumArv (No x esq dir) = x + sumArv esq + sumArv dir

-- 4.2
listar :: Arv a -> [a]
listar Vazia = []
listar (No x esq dir) = listar dir ++ [x] ++ listar esq

-- 4.3
nivel :: Int -> Arv a -> [a]
nivel 0 (No x _ _) = [x]
nivel n (No _ esq dir) = nivel (n - 1) esq ++ nivel (n - 1) dir

-- 4.4
-- a
inserir :: Ord a => a -> Arv a -> Arv a
inserir x Vazia = No x Vazia Vazia
inserir x (No y esq dir)  | x == y = No y esq dir             -- já ocorre; não insere
                          | x < y = No y (inserir x esq) dir  -- insere à esquerda
                          | x > y = No y esq (inserir x dir)  -- insere à direita

--construir :: [a] -> Arv a
--construir [] = Vazia
--construir xs = No x (construir xsa) (construir xsb) 
--  where n = length (xs ´div´ 2)
--        xsa = take n xs 
--        x:xsb = drop n xs

-- 4.5
mapArv :: (a -> b) -> Arv a -> Arv b
mapArv f Vazia = Vazia
mapArv f (No x esq dir) = No (f x) (mapArv f esq) (mapArv f dir)

-- 4.6
-- a


-- b


-- 4.7 and 4.8
data Expr = Lit Integer | Op Ops Expr Expr | If BExp Expr Expr

data Ops = Add | Sub | Mul | Div | Mod

data BExp = BoolLit Bool | And BExp BExp | Not BExp | Equal BExp BExp | Greater Expr Expr

eval :: Expr -> Integer
eval (Lit n) = n
eval (Op op e1 e2) = opEval op (eval e1) (eval e2)
eval (If b e1 e2) = if beval b then eval e1 else eval e2

beval :: BExp -> Bool
beval (BoolLit b) = b
beval (And e1 e2) = beval e1 && beval e2
beval (Not e) = not (beval e)
beval (Equal e1 e2) = beval e1 == beval e2
beval (Greater e1 e2) = eval e1 > eval e2

opEval :: Ops -> Integer -> Integer -> Integer
opEval Add = (+)
opEval Sub = (-)
opEval Mul = (*)
opEval Div = div
opEval Mod = mod

showExpr :: Expr -> String
showExpr (Lit n) = show n
showExpr (Op op e1 e2) = "(" ++ showExpr e1 ++ " " ++ showOps op ++ " " ++ showExpr e2 ++ ")"
showExpr (If b e1 e2) = "if " ++ showBExp b ++ " then " ++ showExpr e1 ++ " else " ++ showExpr e2

showBExp :: BExp -> String
showBExp (BoolLit b) = show b
showBExp (And e1 e2) = "(" ++ showBExp e1 ++ " && " ++ showBExp e2 ++ ")"
showBExp (Not e) = "not " ++ showBExp e
showBExp (Equal e1 e2) = "(" ++ showBExp e1 ++ " == " ++ showBExp e2 ++ ")"
showBExp (Greater e1 e2) = "(" ++ showExpr e1 ++ " > " ++ showExpr e2 ++ ")"

showOps :: Ops -> String
showOps Add = "+"
showOps Sub = "-"
showOps Mul = "*"
showOps Div = "/"
showOps Mod = "%"

sizeExpr :: Expr -> Integer
sizeExpr (Lit _) = 1
sizeExpr (Op _ e1 e2) = sizeExpr e1 + sizeExpr e2 + 1
sizeExpr (If _ e1 e2) = sizeExpr e1 + sizeExpr e2 + 1
