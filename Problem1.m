
% ----------------------------------------------------------------------- %
clear variables;
close all;
clc;
% ----------------------------------------------------------------------- %

% import data
raw_prod = importdata('coffee_production.csv');
coffee_prod = raw_prod.data;

% import data
quality = table2array(readtable('quality.xlsx'));

% coffee_prod = raw_prod.data;
net = feedforwardnet(3,'trainlm');
net = train(net, coffee_prod', quality');

view(net);
qual_hat = net(coffee_prod');
pref = perform(net, qual_hat, quality');