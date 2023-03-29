% Clear environment
clear variables;
close all;
clc;

% Read the data from the 'wastewater.xlsx' file
data = readtable('wastewater.xlsx');

% Split the data into training and testing sets
training_data = data(1:19, 2:8);
training_labels = data(1:19, 9);
testing_data = data(20:26, 2:8);
testing_labels = data(20:26, 9);

% Define the number of components for the PLS model
num_components = 3;

% Perform PLS using the NIPALS algorithm
[t, wstar, c, p, w, u,  R2_y, res_y] = nipalspls(table2array(training_data), table2array(training_labels), num_components);

wstar
p
c
R2_y

% Extract the loadings for the first two components
W_12 = wstar(:, 1:2);
C_12 = c(:, 1:2);

% Create a scatter plot for w* and c loadings between components 1 and 2
figure;
hold on;
scatter(W_12(:, 1), W_12(:, 2), 'b', 'filled');
scatter(C_12(:, 1), C_12(:, 2), 'r', 'filled');

% Add labels for w* and c points
text(W_12(:, 1), W_12(:, 2), ['A','B','C','D','E','F','G']', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'blue');
text(C_12(:, 1), C_12(:, 2),'SNR', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'red');

% Add legend
legend({'w* Loadings', 'c Loadings'}, 'Location', 'best');

% Label the axes
xlabel('Component 1');
ylabel('Component 2');

% Set the title
title('Loadings Scatter Plot for Components 1 and 2 (w* and c)');
grid on;
% Release the hold on the current figure
hold off;



% 2.4 

Xtrain = table2array(training_data);
Ytrain = table2array(training_labels);

Xtest = table2array(testing_data)
Xtestcs = (Xtest - mean(Xtrain))./std(Xtrain)
Yhat = Xtestcs * wstar * c'
Yhat_rescale = Yhat.*std(Ytrain) + mean(Ytrain)

Yo = table2array(testing_labels)
labels = ["WW-20",'WW-21','WW-22','WW-23','WW-24','WW-25','WW-26']';
figure;
hold on;
fplot(@(x) x);
scatter(Yhat_rescale, Yo, 'black', 'filled');
text(Yhat_rescale,Yo, ["WW-20",'WW-21','WW-22','WW-23','WW-24','WW-25','WW-26']', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'black');
title('Observed vs Predicted SNR');
xlabel('Predicted SNR');
ylabel('Observed SNR');

grid on;
hold off;

Q2 = 1 - var(abs(Yhat_rescale-Yo))/var(Yo)