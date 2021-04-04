close all;
clc;
clear all;

p_att = 0.9;
s_att = 50;

p_ripple = 

f_pass = 1000;
f_stop = 1500;
fs = 8000;

d1 = (1/2)*10^(p_att/20);
d2 = 10^(-s_att/20);

omega_s = 2*pi*f_stop/fs;
omega_p = 2*pi*f_pass/fs;

delta = (omega_s-omega_p)/(2*pi);
N = (-10*log(d1*d2)-15)/(14*delta) + 1
