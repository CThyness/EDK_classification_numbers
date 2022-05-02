%This will hopefully work
function res = Numbers(K, M)
    %Get data from workspace into the script
    Nnumbers = 10;
    Ntest = evalin('base', 'num_test');
    C_test = evalin('base', 'testlab');
    C_train = evalin('base', 'trainlab');
    features_test = evalin('base', 'testv');
    features_train = evalin('base', 'trainv');
    
    tic;
    if M > 0        
        [guess, guess1D] = test_with_clustering(features_test, features_train, C_train, Nnumbers, Ntest, M, K);
    else
        % Classify (No clustering, K = 1)
        [guess, guess1D] = test(features_test, features_train, C_train, Nnumbers, Ntest, K);
    end
    toc;

    fignum = 1;
    % Plot confusion matrix
    fignum = specificConfPlot(fignum, guess, C_test, K, Nnumbers, Ntest, M);
    
    % Plot two misclassified numbers
    fignum = showMisclassified(C_test, guess1D, features_test, fignum);

    %Plot three correctly classified numbers
    fignum = showCorrect(C_test, guess1D, features_test, 3, fignum);
    
end

function fignum = weirdDisplayMethod(fignum, x) %This was really ugly and I did it several times, so I wanted to push into it's own function XD
    figure(fignum);
    fignum = fignum + 1;
    image(x);
end

function [guess, guess1D] = test(features_test, features_train, C_train, Nnumbers, Ntest, K)
    guess = zeros(Nnumbers,Ntest);
    guess1D = zeros(Ntest, 1);
    if K < 2 %Looks ugly, but should minimize run speed for K = 0
        for k = 1:Ntest
            test = features_test(k, :);
            dists = dist(features_train,test');
            [d,ind] = min(dists);
            pred = C_train(ind);
            guess1D(k) = pred;
            guess(pred+1,k) = 1;
        end
    else
        for k = 1:Ntest
            classes = zeros(K, 1);
            test = features_test(k, :);
            dists = dist(features_train,test');
            [d, ind] = sort(dists); %ind is an array of the indexes from dists sorted dependent on the values from lowest to higest
            for i = 1:K
                classes(i) = C_train(ind(i));
            end
            pred = mode(classes);
            guess1D(k) = pred;
            guess(pred+1,k) = 1;
        end
    end
end

function [guess, guess1D] = test_with_clustering(features_test, features_train, C_train, Nnumbers, Ntest, M, K)
    %Sort the training data by class
    features_train = sortC(C_train, features_train, Nnumbers);

    %clustering
    for c = 1:Nnumbers
        [idx, temp_C] = kmeans(features_train{c}, M);
        features_train{c} = temp_C;
    end

    %Reformat and make new C_train
    features_train = cell2mat(features_train);
    C_train = zeros(Nnumbers*M, 1);
    for c = 1:Nnumbers
        C_train((c-1)*M+1:c*M) = c-1;
    end

    %Actual testing
    [guess, guess1D] = test(features_test, features_train, C_train, Nnumbers, Ntest, K);
end

function fignum = specificConfPlot(fignum, guess, C_test, K, Nnumbers, Ntest, M)
    % Make wanted result matrix for confusion matrix plotting
    known = zeros(Nnumbers,Ntest);
    for k = 1:Ntest
        c = C_test(k);
        known(c+1,k) = 1;
    end
    
    %Do the actual plotting
    figure(fignum);
    fignum = fignum + 1;
    plotconfusion(known,guess);
    titl = get(get(gca,'title'),'string');
    if M == 0
        text = [num2str(K),'NN with no clustering'];
    else
        text = [num2str(K),'NN with clustering and M=',num2str(M)];
    end
    title({titl, text});
    xticklabels({'0','1','2','3','4','5','6','7','8','9'});
    yticklabels({'0','1','2','3','4','5','6','7','8','9'});
end

function fignum = showMisclassified(C_test, guess1D, features_test, fignum)
    misclass = C_test - guess1D; %Creates an array with how much we missed the mark on the different samples
    [minimum, index_min] = min(misclass); %Finds one where we classified it as too big of a number
    [maximum, index_max] = max(misclass); %Finds one where we classified it as too small of a number
    
    x = zeros(28, 28);
    x(:) = features_test(index_min, :);
    text = ['Figure ',num2str(fignum),' shows a(n) ',num2str(C_test(index_min))," misclassified as a(n) ",num2str(guess1D(index_min))];
    disp(text);
    fignum = weirdDisplayMethod(fignum, x);
    
    x = zeros(28, 28);
    x(:) = features_test(index_max, :);
    text = ['Figure ',num2str(fignum),' shows a(n) ',num2str(C_test(index_max))," misclassified as a(n) ",num2str(guess1D(index_max))];
    disp(text);
    fignum = weirdDisplayMethod(fignum, x);
end

function fignum = showCorrect(C_test, guess1D, features_test, Nshow, fignum)
    found = 0;
    k = 1;
    while found < Nshow %Plots first three correctly classified numbers
        if guess1D(k) == C_test(k)
            found = found + 1;
            x = zeros(28, 28);
            x(:) = features_test(k, :);
            text = ['Figure ',num2str(fignum),' shows a(n) ',num2str(C_test(k))];
            disp(text);
            fignum = weirdDisplayMethod(fignum, x);            
        end
        k = k + 1;
    end
end

function features_train_sorted = sortC(C_train, features_train, Nnumbers) %For sake of your eyes I would recommend not looking at this function
    features_train_sorted = cell(10, 1);
    for c = 0:Nnumbers-1 % c = current class
        features_train_sorted{c+1} = features_train(C_train == c, :);
    end
end



