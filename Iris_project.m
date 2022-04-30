function MSE = Iris_project(Nfeatures, alpha)
    [x1, x2, x3] = getData(Nfeatures);
    
    % Ntot = Number of test patterns, dimx = Number of features
    [Ntot,dimx] = size(x1);
    Nclasses = 3;
    
    W = createW(Nclasses, dimx);
    
    % Takes the first 30 samples of each class for training, reserves the rest
    % for testing
    Ntrain = 30;
    bs = ones(Ntrain);
    bs = bs(1, :);
    [x_train, x_test] = splitSamples(Ntrain, Ntot, dimx, bs, x1, x2, x3);
    
    %Creates an array for checking results
    t_train = zeros(Nclasses, Ntrain*3);
    for i = 1:Nclasses
        t_train(i, Ntrain*(i-1)+1:Ntrain*i) = bs;
    end
    
    % Start training our model
    for i = 1:1000
        %Calculates the full g matrix
        g_train = calcg(Nclasses, Ntrain, x_train, W);
    
        %calculates current MSE and prints it
        MSE = calcMSE(Ntrain, x_train, g_train, t_train, bs);
    
        %Calculates current gradient of MSE dependent on W
        gMSE = calcGradientMSE(Nclasses, dimx, Ntrain, t_train, g_train, x_train, bs);
    
        break %Just testing my code so far, do not want it to run a thousand times yet
    end
end

function [x1, x2, x3] = getData(Nfeatures) % Henter ut data
    x1all = load('class_1','-ascii');
    x2all = load('class_2','-ascii');
    x3all = load('class_3','-ascii');

    if Nfeatures == 1
        x1= [x1all(:,4)];
        x2= [x2all(:,4)];
        x3= [x3all(:,4)];
    elseif Nfeatures == 2
        x1= [x1all(:,3) x1all(:,4)];
        x2= [x2all(:,3) x2all(:,4)];
        x3= [x3all(:,3) x3all(:,4)];
    elseif Nfeatures == 3
        x1= [x1all(:,4) x1all(:,1) x1all(:,2)];
        x2= [x2all(:,4) x2all(:,1) x2all(:,2)];
        x3= [x3all(:,4) x3all(:,1) x3all(:,2)];
    else
        x1 = x1all;
        x2 = x2all;
        x3 = x3all;
    end
end

function W = createW(Nclasses, dimx) %Creates a stupid W
    W = zeros(Nclasses, dimx+1);

    % Create some random values for W
    class1_feature_values = [0.3 1 0.5 0.1];
    class2_feature_values = [0.4 0.2 0.7 1];
    class3_feature_values = [0.9 0.1 0.4 -1];
    w0 = -0.4;
    
    % Fills W with those random values created
    W(1, :) = [class1_feature_values(1:dimx) w0];
    W(2, :) = [class2_feature_values(1:dimx) w0];
    W(3, :) = [class3_feature_values(1:dimx) w0];
end

function [x_train, x_test] = splitSamples(Ntrain, Ntot, dimx, bs, x1, x2, x3)
    x1_train = zeros(Ntrain, dimx);
    x1_train(: , 1:dimx) = x1(1:Ntrain, :);
    x1_train(:, dimx+1) = bs;
    
    x2_train = zeros(Ntrain, dimx);
    x2_train(: , 1:dimx) = x2(1:Ntrain, :);
    x2_train(:, dimx+1) = bs;
    
    x3_train = zeros(Ntrain, dimx);
    x3_train(: , 1:dimx) = x3(1:Ntrain, :);
    x3_train(:, dimx+1) = bs;
    
    x1_test = zeros(Ntot-Ntrain, dimx);
    x1_test(: , 1:dimx) = x1(Ntrain+1:Ntot, :);
    x1_test(:, dimx+1) = bs(1:20);
    
    x2_test = zeros(Ntot-Ntrain, dimx);
    x2_test(: , 1:dimx) = x3(Ntrain+1:Ntot, :);
    x2_test(:, dimx+1) = bs(1:20);
    
    x3_test = zeros(Ntot-Ntrain, dimx);
    x3_test(: , 1:dimx) = x3(Ntrain+1:Ntot, :);
    x3_test(:, dimx+1) = bs(1:20);
    
    % Puts all training and test sets in one matrix
    x_train = [x1_train; x2_train; x3_train];
    x_test = [x1_test; x2_test; x3_test];
end

function g = calcg(Nclasses, Ntrain, x, W)
    g = zeros(Nclasses, Ntrain);
        for k = 1:Ntrain*3
            for c = 1:Nclasses
                w_class = W(c, :);
                current_x = x(k, :);
                g(c, k) = dot(w_class, current_x);
                g(c, k) = 1/(1+exp(-g(c,k)));
            end
        end
end

function MSE = calcMSE(N, x, g, t, bs)
    MSE = 0;
        for k = 1:N*3
            dMSE = dot(g(:, k)-t(:,k), g(:, k));
            dMSE = dMSE*(bs(1:3)'-g(:, k));
            dMSE = dot(dMSE, x(k, :)');
    
            MSE = MSE + dMSE;
        end
        disp(MSE);
end

function gMSE = calcGradientMSE(Nclasses, dimx, N, t, g, x, bs) %Calculates the gradient of the MSE dependent on W
    gMSE = zeros(Nclasses, dimx+1); 
        for k = 1:N*3
            dgMSE = g(:, k)-t(:, k); % delta gradient MSE
            dgMSE = dot(dgMSE, g(:, k));
            dgMSE = dgMSE * (bs(1:3)' - g(:, k));
            dgMSE = dgMSE * x(k, :);
    
            gMSE = gMSE + dgMSE;
        end
        disp(gMSE);
end






