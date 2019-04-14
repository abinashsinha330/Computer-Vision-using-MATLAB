%{
function to perform mini-batch gradient descent to train single layer
perceptron and get final values of weights and biases parameters using
Euclidean loss as the objective
%}
function [w, b] = TrainSLP_linear(mini_batch_x, mini_batch_y)
    num_batches = size(mini_batch_y, 1);
    learning_rate = 0.05; % learning rate
    decay_rate = 0.5; % decay rate for learning rate applied at every 1000th iteration
    nIters = 100000;
    decay_interval = 1000;
    w = normrnd(0,1,[10, 196]);
    b = zeros(10,1);
    k = 1;
    for iter = 1 : nIters
        if rem(iter, decay_interval) == 0
            learning_rate = learning_rate * decay_rate;
        end
        dLdw = 0;
        dLdb = 0;
        batch_size = size(mini_batch_y{k}, 2);
        for i = 1 : batch_size
            x = mini_batch_x{k}(:, i);
            y = FC(x, w, b);
            y_true = mini_batch_y{k}(:, i);
            l, dldy = Loss_euclidean(y, y_true);
            dldx, dldw, dldb = FC_backward(dldy, x, w, b, y);
            dLdw = dLdw + dldw;
            dLdb = dLdb + dldb;
        end
        k = k + 1;
        if k > num_batches
            k = 1;
        end
        w = w - (learning_rate*dLdw)/batch_size;
        b = b - (learning_rate*dLdb)/batch_size;
    end