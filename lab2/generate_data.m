function [training_data_x , training_data_y , testing_data_x , testing_data_y] = generate_data(always_generate) 
    % Try to loading data
    training_data_path = 'training.mat' ;
    testing_data_path = 'testing.mat';
    if exist(training_data_path,'file') ~= 0 && exist(testing_data_path , 'file') ~= 0 && ~always_generate
        load(training_data_path , 'training_data_x' , 'training_data_y') ;
        load(testing_data_path , 'testing_data_x' , 'testing_data_y') ;
        disp(['loaded dataset from file ' ,training_data_path , ' ' ,testing_data_path ]) ;
        return ;
    end
    % define class
    CLASS_NUM = 4 ;
    CLASS_1 = 1 ;
    CLASS_2 = 2 ;
    CLASS_3 = 3 ;
    CLASS_4 = 4 ;
    % define trainging and testing data size
    TRAINING_DATA_PER_CLASS_SIZE = 1000 ;
    TESTING_DATA_PER_CLASS_SIZE = 100 ;
    PER_CLASS_SIZE = TRAINING_DATA_PER_CLASS_SIZE + TESTING_DATA_PER_CLASS_SIZE ;
    % generate data
    % % class 1 data 
    mu_1 = [0 ; 0 ; 0 ] ;
    sigma_1 = eye(3) ;
    class_1_data = mvnrnd(mu_1 , sigma_1 , PER_CLASS_SIZE) ;
    % % class 2 data
    mu_2 = [0 ; 1 ; 0] ;
    sigma_2 = [ 1 0 1 ; 0 2 2 ; 1 2 5] ;
    class_2_data = mvnrnd(mu_2 , sigma_2 , PER_CLASS_SIZE) ;
    % % class 3 data
    mu_3 = [-1 0 1 ] ;
    sigma_3 = diag([2 6 1]) ;
    class_3_data = mvnrnd(mu_3 , sigma_3 , PER_CLASS_SIZE) ;
    % % class 4 data
    mu_4 = [0 0.5 1] ;
    sigma_4 = diag([2 1 3]) ;
    class_4_data = mvnrnd(mu_4 , sigma_4 , PER_CLASS_SIZE) ;
    
    % % generate data set
    training_data_x = [ class_1_data(1:TRAINING_DATA_PER_CLASS_SIZE , :) ; ...
                      class_2_data(1:TRAINING_DATA_PER_CLASS_SIZE , :) ; ...
                      class_4_data(1:TRAINING_DATA_PER_CLASS_SIZE , :) ; ...
                      class_3_data(1:TRAINING_DATA_PER_CLASS_SIZE , :) ; ...
                       ] ;
   training_data_y = [ ones(TRAINING_DATA_PER_CLASS_SIZE , 1) * CLASS_1 ; ...
                       ones(TRAINING_DATA_PER_CLASS_SIZE , 1) * CLASS_2 ; ...
                       ones(TRAINING_DATA_PER_CLASS_SIZE , 1) * CLASS_4 ; ...
                       ones(TRAINING_DATA_PER_CLASS_SIZE , 1) * CLASS_3 ; ...
                        ] ;
   testing_data_x =  [class_1_data(TRAINING_DATA_PER_CLASS_SIZE + 1 : end , : ) ; ...
                      class_2_data(TRAINING_DATA_PER_CLASS_SIZE + 1 : end , : ) ; ...
                      class_3_data(TRAINING_DATA_PER_CLASS_SIZE + 1 : end , : ) ; ...
                      class_4_data(TRAINING_DATA_PER_CLASS_SIZE + 1 : end , : ) ] ;
   testing_data_y = [ ones(TESTING_DATA_PER_CLASS_SIZE , 1) * CLASS_1 ; ... 
                      ones(TESTING_DATA_PER_CLASS_SIZE , 1) * CLASS_2 ; ...
                      ones(TESTING_DATA_PER_CLASS_SIZE , 1) * CLASS_3 ; ...
                      ones(TESTING_DATA_PER_CLASS_SIZE , 1) * CLASS_4 ] ;
                  
   %% training data should be random !!
   % 如果不随机，就是25%...
   
   disp('shuffling training data') ;
   permutation_idx = randperm(TRAINING_DATA_PER_CLASS_SIZE * CLASS_NUM) ;
   randomed_training_data_x = ones(size(training_data_x)) ;
   randomed_training_data_y = ones(size(training_data_y)) ;
   for i = 1 : TRAINING_DATA_PER_CLASS_SIZE * CLASS_NUM 
        randomed_training_data_x(i,:) = training_data_x(permutation_idx(i),:) ;
        randomed_training_data_y(i,:) = training_data_y(permutation_idx(i),:) ;
   end
   training_data_x = randomed_training_data_x ;
   training_data_y = randomed_training_data_y ;
   disp('saving data to file .') ;
   save(training_data_path , 'training_data_x' , 'training_data_y') ;
   save(testing_data_path , 'testing_data_x' , 'testing_data_y') ;
   disp('done') ;
end