clear all
close all
clc

A = simple_track(30, 20);
temp = A;

row = 15;
col = 14;
temp(row,col) = 5;

[row_new, col_new, v_row_new, v_col_new, r]=car(A, row, col,1,1,0,0);
temp(row_new,col_new) = 6;
heatmap(temp)