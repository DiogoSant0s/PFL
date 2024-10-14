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
palavras xs = (takeWhile (/= ' ') xs) : palavras (dropWhile (/= ' ') xs)

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

-- 4.5
mapArv :: (a -> b) -> Arv a -> Arv b
mapArv f Vazia = Vazia
mapArv f (No x esq dir) = No (f x) (mapArv f esq) (mapArv f dir)
