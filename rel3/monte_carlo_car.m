clear all
close all
clc

A = simple_track(30, 20);

x = 15;
y = 1;

[xp, yp, vxp, vyp, r]=car(A, x,y,1,1,0,0);

disp(xp)
disp(yp)