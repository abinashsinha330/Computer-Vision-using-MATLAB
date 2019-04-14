%{
function to perform mini-batch gradient descent to train configured
convolutional neural network and get final values of weights and biases
parameters using softmax cross-entropy loss as the objective;


The network is composed of: 
a single channel input (14×14×1)
            |
            v
Conv layer (3×3 convolution with 3 channel output and stride 1)
            |
            v
        ReLu layer
            |
            v
Max-pooling layer (2 × 2 with stride 2)
            |
            v
Flattening layer (147 units)
            |
            v
    FC layer (10 units)
            |
            v
        Soft-max
%}
function [w_conv, b_conv, w_fc, b_fc] = TrainCNN(mini_batch_x, mini_batch_y)
    num_batches = size(mini_batch_y, 1);
    learning_rate = 0.05; % learning rate
    decay_rate = 0.5; % decay rate for learning rate applied at every 1000th iteration
    nIters = 10000;
    decay_interval = 1000;
    w_conv = normrnd(0,1,[3, 3, 1, 3]);
    b_conv = zeros(3, 1);
    w_fc = normrnd(0,1,[10, 147]);
    b_fc = zeros(10,1);
    k = 1;
    for iter = 1 : nIters
        if rem(iter, decay_interval) == 0
            learning_rate = learning_rate * decay_rate;
        end
        dLdw_conv = 0;
        dLdb_conv = 0;
        dLdw_fc = 0;
        dLdb_fc = 0;
        batch_size = size(mini_batch_y{k}, 2);
        for i = 1 : batch_size
            x = mini_batch_x{k}(:, i);
            reshaped_x = reshape(x, [14, 14]);
            %forward propagation code
            y = Conv(reshaped_x, w_conv, b_conv);
            a = ReLu(y);
            pooled_a = Pool2x2(a);
            flat_a = Flattening(pooled_a);
            y_fc = FC(flat_a, w_fc, b_fc);
            l, dldy_fc = Loss_cross_entropy_softmax(y_fc, y_true);
            %back-propagation code
            [dldflattened_a, dldw_fc, dldb_fc] = FC_backward(dldy_fc,...
                flat_a, w_fc, b_fc, y_fc);
            dldpooled_a = Flattening_backward(dldflattened_a, pooled_a, flat_a);
            dlda = Pool2x2_backward(dldpooled_a, a, pooled_a);
            dldy = ReLu_backward(dlda, y, a);
            [dldw_conv, dldb_conv] = Conv_backward(dldy,...
                reshaped_x, w_conv, b_conv, y);
            dLdw_conv = dLdw_conv + dldw_conv;
            dLdb_conv = dLdb_conv + dldb_conv;
            dLdw_fc = dLdw_fc + dldw_fc;
            dLdb_fc = dLdb_fc + dldb_fc;
        end
        k = k + 1;
        if k > num_batches
            k = 1;
        end
        w_conv = w_conv - (learning_rate*dLdw_conv)/batch_size;
        b_conv = b_conv - (learning_rate*dLdb_conv)/batch_size;
        w_fc = w_fc - (learning_rate*dLdw_fc)/batch_size;
        b_fc = b_fc - (learning_rate*dLdb_fc)/batch_size;
    end
    
end