%dish(Name, Price, IngredientGrams).
dish(pizza,         2200, [cheese-300, tomato-350]).
dish(ratatouille,   2200, [tomato-70, eggplant-150, garlic-50]).
dish(garlic_bread,  1600, [cheese-50, garlic-200]).

:- dynamic ingredient/2.

%ingredient(Name, CostPerGram).
ingredient(cheese,   4).
ingredient(tomato,   2).
ingredient(eggplant, 7).
ingredient(garlic,   6).

%count_ingredients(?Dish, ?NumIngredients)
    count_ingredients(Dish, NumIngredients) :- dish(Dish, _, Ingredients), count_ingredients_aux(Ingredients, NumIngredients).

    count_ingredients_aux([], 0).
    count_ingredients_aux([_|Rest], N) :- count_ingredients_aux(Rest, N1), N is N1 + 1.

%ingredient_amount_cost(?Ingredient, +Grams, ?TotalCost)
    ingredient_amount_cost(Ingredient, Grams, TotalCost) :- ingredient(Ingredient, CostPerGram), TotalCost is CostPerGram * Grams.

%dish_profit(?Dish, ?Profit)
    dish_profit(Dish, Profit) :- dish(Dish, Price, IngredientGrams), dish_cost(IngredientGrams, Cost), Profit is Price - Cost.

    dish_cost([], 0).
    dish_cost([Ingredient-Grams|Rest], Cost) :- dish_cost(Rest, N), ingredient_amount_cost(Ingredient, Grams, IngredientCost), Cost is N + IngredientCost.

%update_unit_cost(+Ingredient, +NewUnitCost)
    update_unit_cost(Ingredient, NewUnitCost) :- ingredient(Ingredient, CostPerGram), retract(ingredient(Ingredient, CostPerGram)), assert(ingredient(Ingredient, NewUnitCost)), fail.
    update_unit_cost(Ingredient, NewUnitCost) :- assert(ingredient(Ingredient, NewUnitCost)), fail.
    update_unit_cost(_, _).

%most_expensive_dish(?Dish, ?Price)
    most_expensive_dish(Dish, Price) :- dish(Dish, Price, _), \+ (dish(_, OtherPrice, _), OtherPrice > Price).

%consume_ingredient(+IngredientStocks, +Ingredient, +Grams, ?NewIngredientStocks)
    consume_ingredient(IngredientStocks, Ingredient, Grams, NewIngredientStocks) :-
        append(L1, [Ingredient-Amount | L2], IngredientStocks),
        Amount >= Grams,
        NewAmount is Amount - Grams,
        append(L1, [Ingredient-NewAmount | L2], NewIngredientStocks).

%count_dishes_with_ingredient(+Ingredient, ?N)
    count_dishes_with_ingredient(Ingredient, N) :- count_dishes(Ingredient, 0, [],N).

    count_dishes(Ingredient, Acc, DishesList, N) :- dish(Dish, _Price, List), \+ member(Dish, DishesList), 
        append(DishesList, [Dish], NewDishesList),
        member(Ingredient-_, List), Acc1 is Acc + 1, 
        count_dishes(Ingredient, Acc1, NewDishesList, N), !.
    count_dishes(_, N, _, N).

:- use_module(library(lists)).

%list_dishes(?DishIngredients)
    list_dishes(DishIngredients) :-
        findall(Dish-Ingredients, (dish(Dish, _, Ingredients1), maplist(remove_grams, Ingredients1, Ingredients)), DishIngredients).
        
    remove_grams(Name-_, Name).

%most_lucrative_dishes(?Dishes)
    most_lucrative_dishes(Dishes):- setof(Profit-Dish, dish_profit(Dish, Profit), List), reverse(List, List1), findall(D, member(_-D, List1), Dishes).
