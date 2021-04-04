clear;
a=[0.35 0.34 0.18 0.06 0.04 0.02 0.01;];
sum=0;
for l = 1:length(a)
    sum = sum - a(l)*log2(a(l));
end