function MSE = Iris_project(Nfeatures, alpha, splitMode)
    [x1, x2, x3] = getData(Nfeatures);
    
    % Ntot = Number of test patterns, dimx = Number of features
    [Ntot,dimx] = size(x1);
    Nclasses = 3;

    W = eye(Nclasses, dimx+1);
    
    % Takes the first 30 samples of each class for training, reserves the rest
    % for testing
    Ntrain = 30;
    Ntest = Ntot - Ntrain;
    [x_train, x_test] = splitSamples(Ntrain, Ntot, dimx, x1, x2, x3, splitMode);
    
    %Creates arrays for checking results
    t_train = createt(Nclasses, Ntrain);
    t_test = createt(Nclasses, Ntest);
    
    % Start training our model
    for i = 1:5081
        %Calculates the full g matrix
        g_train = calcg(Nclasses, Ntrain, x_train, W);
    
        %Calculates current gradient of MSE dependent on W
        gMSE = calcGradientMSE(Nclasses, dimx, Ntrain, t_train, g_train, x_train);

        W = W - alpha*gMSE;
    end
    %calculates current MSE

    g_train = calcg(Nclasses, Ntrain, x_train, W);
    g_test = calcg(Nclasses, Ntest, x_test, W);
    g_test = Heavyside(g_test, Ntest, Nclasses);
    MSE = calcMSE(Ntest, g_test, t_test);
    disp(W);

    displayConf(Ntrain, Ntest, Nclasses, g_train, g_test);
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


function [x_train, x_test] = splitSamples(Ntrain, Ntot, dimx, x1, x2, x3, splitMode)
    if(splitMode == 1)
        start_train = 1;
        end_train = Ntrain;
        start_test = Ntrain+1;
        end_test = Ntot;
    elseif(splitMode == 2)
        start_train = Ntot-Ntrain+1;
        end_train = Ntot;
        start_test = 1;
        end_test = Ntot-Ntrain;
    end
    x1_train = zeros(Ntrain, dimx);
    x1_train(: , 1:dimx) = x1(start_train:end_train, :);
    x1_train(:, dimx+1) = 1;
    
    x2_train = zeros(Ntrain, dimx);
    x2_train(: , 1:dimx) = x2(start_train:end_train, :);
    x2_train(:, dimx+1) = 1;
    
    x3_train = zeros(Ntrain, dimx);
    x3_train(: , 1:dimx) = x3(start_train:end_train, :);
    x3_train(:, dimx+1) = 1;
    
    x1_test = zeros(Ntot-Ntrain, dimx);
    x1_test(: , 1:dimx) = x1(start_test:end_test, :);
    x1_test(:, dimx+1) = 1;
    
    x2_test = zeros(Ntot-Ntrain, dimx);
    x2_test(: , 1:dimx) = x3(start_test:end_test, :);
    x2_test(:, dimx+1) = 1;
    
    x3_test = zeros(Ntot-Ntrain, dimx);
    x3_test(: , 1:dimx) = x3(start_test:end_test, :);
    x3_test(:, dimx+1) = 1;
    
    % Puts all training and test sets in one matrix
    x_train = [x1_train; x2_train; x3_train];
    x_test = [x1_test; x2_test; x3_test];
end

function g = calcg(Nclasses, N, x, W)
    g = zeros(Nclasses, N);
        for k = 1:N*Nclasses
            for c = 1:Nclasses
                w_class = W(c, :);
                current_x = x(k, :);
                g(c, k) = w_class * current_x';
                g(c, k) = 1/(1+exp(-g(c, k)));
            end
        end
end

function MSE = calcMSE(N, g, t) %Calculates current MSE of system
    MSE = 0;
        for k = 1:N*3
            dMSE = 0.5 * dot(g(:, k)-t(:,k), g(:, k)-t(:,k));
    
            MSE = MSE + dMSE;
        end
end

function gMSE = calcGradientMSE(Nclasses, dimx, N, t, g, x) %Calculates the gradient of the MSE dependent on W
    gMSE = zeros(Nclasses, dimx+1); 
        for k = 1:N*3
            dgMSE = (g(:,k)-t(:,k)) .* g(:,k); % delta gradient MSE
            dgMSE = dgMSE .* (1-g(:,k));
            dgMSE = dgMSE * x(k,:);
    
            gMSE = gMSE + dgMSE;
        end
end

function t = createt(Nclasses, N)
    t = zeros(Nclasses, N*3);
    for i = 1:Nclasses
        t(i, N*(i-1)+1:N*i) = 1;
    end

end

function g = Heavyside(g, N, Nclasses)
    for k = 1:N*Nclasses
        [argvalue, argmax] = max(g(:, k));
        g(:, k) = 0;
        g(argmax, k) = 1;
    end
end

function conf = fillConf(N, Nclasses, g)
    conf = zeros(Nclasses, Nclasses);
    for c = 1:Nclasses
        for k = (c-1)*N+1:N*c
            for c_chosen = 1:Nclasses
                conf(c, c_chosen) = conf(c, c_chosen) + g(c_chosen, k);
            end
        end
    end
end

function [conf_train, conf_test] = displayConf(Ntrain, Ntest, Nclasses, g_train, g_test)
    g_train = Heavyside(g_train, Ntrain, Nclasses);
    conf_train = fillConf(Ntrain, Nclasses, g_train);

    g_test = Heavyside(g_test, Ntest, Nclasses);
    conf_test = fillConf(Ntest, Nclasses, g_test);
    
	disp([conf_train conf_test])
end



