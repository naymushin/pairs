domains

tdata = data(string, string)
tdatalist = tdata*
  
predicates

nondeterm woman(string, real) 
nondeterm man(string, real)    

nondeterm getdata(tdata)
getdatalist(tdatalist)
nondeterm printlist(tdatalist)
nondeterm printlist1(tdatalist)  
  
find_maxelem(tdatalist, tdata) 
  
find_maxelem_re(tdatalist, tdata, tdata) 
  
append(tdatalist, tdatalist, tdatalist)
  
cut_elem(tdatalist, tdata, tdatalist)   
  
cut_elem_re(tdatalist, tdatalist, tdata, tdatalist) 
  
sort_list_desc(tdatalist, tdatalist) 
  
clauses

woman("Ada", 24).
man("Paul", 23).
man("Dan", 25).
man("Bon", 21).
  
getdata(data(Man, Woman)) :- man(Man, _), woman(Woman, _).
getdatalist(OrderList) :- findall(Order, getdata(Order), OrderList).
  
find_maxelem([data(Man, Woman)| Tail], Max) :-
    find_maxelem_re(Tail, data(Man, Woman), Max).
find_maxelem_re([], Max, Max).
find_maxelem_re([data(Man, Woman) | Tail], data(Man1, Woman1), Max) :-
    Man < Man1, find_maxelem_re(Tail, data(Man, Woman), Max), !.
find_maxelem_re([data(Man, Woman) | Tail], data(Man1, Woman1), Max) :-
    Man = Man1, Woman < Woman1, find_maxelem_re(Tail, data(Man, Woman), Max), !.
find_maxelem_re([_ | Tail], CurMax, Max) :- find_maxelem_re(Tail, CurMax, Max).
  
append([], List2, List2).
append([data(Man, Woman) | Tail1], List2, [data(Man, Woman) | Tail3]) :-
    append(Tail1, List2, Tail3).
  
cut_elem(List, X, NewList) :- cut_elem_re([], List, X, NewList).
cut_elem_re(Head, [], _, Head). 
cut_elem_re(Head, [M | Tail], X, NewList) :- M = X, append(Head, Tail, NewList), !.
cut_elem_re(Head, [M | Tail], X, NewList) :- append(Head, [M], NewHead),
    cut_elem_re(NewHead, Tail, X, NewList).
  
sort_list_desc([], []).
sort_list_desc(List, Result) :- 
    find_maxelem(List, Max),      
    cut_elem(List, Max, Rest),      
    sort_list_desc(Rest, Result0),  
    Result = [Max | Result0].
  
printlist([]).
printlist([data(Man,Woman)|Tail]) :- write(Man,"\t",Woman), nl, printlist(Tail).
  
printlist1([]).
printlist1([data(Man,Woman)|Tail]) :- man(Man, Age1), woman(Woman, Age2),
    Age2 > Age1, write(Man,"\t",Woman), nl, printlist1(Tail),!.
printlist1([data(Man,Woman)|Tail]) :- printlist1(Tail).
  
goal

getdatalist(List),  
sort_list_desc(List, Result),
printlist(Result), 
write("*******************"), nl, 
printlist1(Result),
fail.