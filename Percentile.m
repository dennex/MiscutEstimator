function n = Percentile(A, p)

sortedA = sort(A);
n = sortedA(p*length(A));