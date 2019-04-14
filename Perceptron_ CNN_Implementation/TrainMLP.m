%{
function to perform mini-batch gradient descent to train single layer
perceptron and get final values of weights and biases parameters using
softmax cross-entropy loss as the objective
%}
function [w1, b1, w2, b2] = TrainMLP(mini_batch_x, mini_batch_y)
    num_batches = size(mini_batch_y, 1);
    learning_rate = 0.05; % learning rate
    decay_rate = 0.5; % decay rate for learning rate applied at every 1000th iteration
    nIters = 10000;
    decay_interval = 1000;
    w1 = normrnd(0,1,[30, 196]);
    b1 = zeros(30,1);
    w2 = normrnd(0,1,[10, 30]);
    b2 = zeros(10,1);
    k = 1;
    for iter = 1 : nIters
        if rem(iter, decay_interval) == 0
            learning_rate = learning_rate * decay_rate;
        end
        dLdw1 = 0;
        dLdb1 = 0;
        dLdw2 = 0;
        dLdb2 = 0;
        batch_size = size(mini_batch_y{k}, 2);
        for i = 1 : batch_size
            x = mini_batch_x{k}(:, i);
            %forward propagation code
            y1 = FC(x, w1, b1);
            a1 = ReLu(y1);
            y2 = FC(a1, w2, b2);
            y_true = mini_batch_y{k}(:, i);
            l, dldy2 = Loss_cross_entropy_softmax(y2, y_true);
            %back-propagation code
            dlda1, dldw2, dldb2 = FC_backward(dldy2, a1, w2, b2, y2);
            dly1 = ReLu_backward(dlda1, x, y);
            dldx, dldw1, dldb1 = FC_backward(dly1, x, w1, b1, y1);
            dLdw1 = dLdw1 + dldw1;
            dLdb1 = dLdb1 + dldb1;
            dLdw2 = dLdw2 + dldw2;
            dLdb2 = dLdb2 + dldb2;
        end
        k = k + 1;
        if k > num_batches
            k = 1;
        end
        w1 = w1 - (learning_rate*dLdw1)/batch_size;
        b1 = b1 - (learning_rate*dLdb1)/batch_size;
        w2 = w2 - (learning_rate*dLdw2)/batch_size;
        b2 = b2 - (learning_rate*dLdb2)/batch_size;
    end
    
end